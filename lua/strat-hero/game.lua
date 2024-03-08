local Stratagems = require("strat-hero.stratagems")
local Ui = require("strat-hero.ui")
local Timer = require("strat-hero.timer")

---Saved value of `timeoutlen` to restore after the game is over.
---
---This is a hack to prevent delays for game keys when the keys are operators or
---prefixes of other mappings.
---@type integer?
local timeout

---Represents a Vim pseudokey, such as "w" or "<Up>".
---@alias StratHero.PseudoKey string

---Mapping of Vim pseudokeys to game motions.
---@type table<StratHero.PseudoKey, StratHero.Motion>
local Motions = {
  -- Vim mode
  k = "Up",
  j = "Down",
  h = "Left",
  l = "Right",

  -- Helldivers mode
  w = "Up",
  s = "Down",
  a = "Left",
  d = "Right",

  -- Skill issue mode (arrow keys)
  ["<Up>"] = "Up",
  ["<Down>"] = "Down",
  ["<Left>"] = "Left",
  ["<Right>"] = "Right",
}

---Reference to the state names to ease development. Do not mutate this.
---@type table<string, StratHero.State>
local State = {
  READY = "ready",
  STARTING = "starting",
  PLAYING = "playing",
  FAILED = "failed",
  OVER = "over",
}

---@alias StratHero.State "ready" | "starting" | "playing" | "failed" | "over"

---The core game object. It is responsible for managing the game loop, state,
---and UI, as well as handling user input.
---
---Acts as a state machine, with the following states:
--- - ready: the game is ready to start
--- - starting: the game is starting (i.e. countdown is active)
--- - playing: the game is active and the player has not made a mistake
--- - failed: the player has made a mistake, but the game is still active
--- - over: the game is over (there is no "lose" state, the game is score-based)
---
---State transitions:
---
---```plaintext
---
---        move key            countdown           out of time
---  Ready──────────► Starting───────────► Playing─────────────► Over
---                                         ▲  │                  ▲
---                           end of delay, │  │<bad input        │<out of time
---                           or new *good*>│  │                  │
---                           input         │  └─────────► Failed─┘
---                                         │    ▲           │
---                                         │    │<bad input │
---                                         └────┴───────────┘
---                                         has time remaining
---```
---
---@class StratHero.Game
---The current state of the game
---@field state StratHero.State
---The current score
---@field score number
---The current round
---@field round number
---Reference to the active stratagem (null if state has not yet transitioned to "playing")
---@field current StratHero.Stratagem
---The current input sequence index
---@field entered integer
---The number of successful sequences
---@field successes integer
---The game loop timer
---@field timer StratHero.Timer
---The time remaining in the current round, in nanoseconds
---@field remaining integer
---Last tick timestamp, in nanoseconds
---@field last_tick integer
---Whether the game has started or not
---@field started boolean
---The list of available stratagems for this game (possibly filtered from the main list)
---@field stratagems StratHero.Stratagem[]
---The UI instance, see `strat-hero/ui.lua`
---@field ui StratHero.Ui
local Game = {}

---Constants

---Mapping of game states to ease development.
Game.STATE = State

---Mapping of Vim pseudokeys to game motions.
Game.MOTIONS = Motions

---TODO:
--- - Speed bonus at the end of round = percentage of time remaining
--- - Bonus points for perfect round = 100

---Configuration (probably shouldn't be changed though)

---NOTE: These values may not be perfectly accurate to what is in Helldivers 2.
---I found these values by trial and error / playing the game. I timed the sequences,
---and counted the points per sequence, bonuses at the end of rounds, and round length.
---I will update them as needed to make the game more consistent with the reference
---version, though these values should be pretty close.

---The time limit of a game round in milliseconds.
---@type integer
Game.TIME_LIMIT = 10000
---The base number of stratagems to show in a round.
---The actual number is `BASE_LENGTH + round` (round starts at 1).
---@type integer
Game.BASE_LENGTH = 5
---Bonus time for a successful sequence, in milliseconds.
---@type integer
Game.SUCCESS_TIME_BONUS = 500
---Number of points awarded for *each motion* of a successful sequence.
---@type integer
Game.SUCCESS_POINTS = 5

---NOTE: These values are more arbitrary and can be changed to suit the game's feel.
---      Unrelated to the reference game.

---The UI tickrate in milliseconds.
---@type integer
Game.TICKRATE = 25 -- 40 fps is maybe a bit much?
---The delay in milliseconds before the next stratagem is shown / the next round starts.
---@type integer
Game.SUCCESS_DELAY = 150
---The delay in milliseconds before the mistake UI is hidden.
---@type integer
Game.MISTAKE_DELAY = 300
---The delay in milliseconds before the game starts.
---@type integer
Game.COUNTDOWN_DELAY = 3000

---Creates a new game instance, sets up the UI and input handling, and returns it.
---@return StratHero.Game
function Game.new()
  local self = setmetatable({}, { __index = Game })

  self.state = State.READY
  self.started = false

  self.stratagems = Stratagems.list({})

  self.ui = Ui.new()
  for key, motion in pairs(Motions) do
    self.ui:map(key, function()
      self:on_key(motion)
    end)
  end
  self.ui:on("BufLeave", function()
    self:stop()
    self.ui:unmount()
  end)

  self.timer = Timer.new(self.TICKRATE, function()
    self:tick()
  end)

  return self
end

---Steps the game forward by one tick, updating the UI and checking for win/lose conditions.
function Game:tick()
  local time = vim.uv.hrtime()
  local delta = time - self.last_tick
  self.remaining = self.remaining - delta
  self.last_tick = time

  self.ui:draw(self)

  if self.remaining <= 0 then
    if self.state == State.PLAYING then
      self:stop()
    elseif self.state == State.STARTING then
      self.remaining = self.TIME_LIMIT * 1e6
      self.state = State.PLAYING
    end
  end
end

---Handles a motion event, checking if it is the correct input for the current sequence.
---@param motion StratHero.Motion
function Game:on_key(motion)
  if not self.started then
    self:start()
    return
  end
  if self.state == State.FAILED then
    self.state = State.PLAYING
  end
  local expected = self.current.sequence[self.entered + 1]

  if expected ~= motion then
    self:fail()
    return
  end
  self.entered = self.entered + 1
  if self.entered == #self.current.sequence then
    self:success()
  end
end

---Picks a stratagem from the list, and attempts to avoid
---using the same stratagem twice in a row.
---@return StratHero.Stratagem
function Game:pick_stratagem()
  local rand = math.random(#self.stratagems)
  local strat = self.stratagems[rand]
  -- lazy way to avoid the same stratagem twice in a row
  while #self.stratagems > 1 and strat == self.current do
    rand = math.random(#self.stratagems)
    strat = self.stratagems[rand]
  end

  return strat
end

---Triggers a success event, when the player correctly enters a full sequence.
function Game:success()
  self.score = self.score + (self.SUCCESS_POINTS * #self.current.sequence)
  self.successes = self.successes + 1
  self.remaining = self.remaining + (self.SUCCESS_TIME_BONUS * 1e6)

  if self.successes >= self.BASE_LENGTH + self.round then
    self.round = self.round + 1
    self.successes = 0
    self.stratagems = Stratagems.list({})
    self.remaining = self.COUNTDOWN_DELAY * 1e6
    self.current = self:pick_stratagem()
    self.entered = 0
    self.state = State.STARTING
  else
    vim.defer_fn(function()
      self.current = self:pick_stratagem()
      self.entered = 0
    end, self.SUCCESS_DELAY)
  end
end

---Triggers a failure event, when the player enters an incorrect motion.
function Game:fail()
  self.entered = 0
  self.state = State.FAILED
  vim.defer_fn(function()
    if self.state == State.FAILED then
      self.state = State.PLAYING
    end
  end, self.MISTAKE_DELAY)
end

---Shows the game UI, but doesn't start the game.
function Game:show()
  self.ui:mount()
  self.ui:draw(self)
end

---Starts the game countdown, and then the game itself.
---Shows the game UI if it hasn't been shown yet.
function Game:start()
  if self.started and self.state ~= "over" then
    return
  end
  if timeout == nil then
    timeout = vim.o.timeoutlen
  end
  vim.o.timeoutlen = 0

  self.score = 0
  self.round = 1
  self.entered = 0
  self.successes = 0

  self.current = self:pick_stratagem()

  self.started = true

  self.last_tick = vim.uv.hrtime()
  self.timer:start()

  self.remaining = self.COUNTDOWN_DELAY * 1e6
  self.state = State.STARTING

  self:show()
end

---Stops the game, and triggers the display of the game over UI.
---
---This does *not* close the game UI.
function Game:stop()
  self.timer:stop()
  self.state = State.OVER
  self.ui:draw(self)
  if timeout ~= nil then
    vim.o.timeoutlen = timeout
  end
  timeout = nil
end

return Game
