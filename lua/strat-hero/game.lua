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
---@field public state StratHero.State
---The current score
---@field public score number
---The current round
---@field public round number
---Reference to the active stratagem (null if state has not yet transitioned to "playing")
---@field public current StratHero.Stratagem
---The current input sequence index
---@field public entered integer
---The game loop timer
---@field timer StratHero.Timer
---The time, in nanoseconds, at which the game countdown started
---@field started integer
---The time, in nanoseconds, at which the game *actually* started
---@field real_start integer Start with added countdown delay
---The time, in nanoseconds, that has elapsed since the game started
---@field elapsed integer
---The list of available stratagems for this game (possibly filtered from the main list)
---@field stratagems StratHero.Stratagem[]
---The UI instance, see `strat-hero/ui.lua`
---@field ui StratHero.Ui
local Game = {}

---Constants

---Mapping of game states to ease development. Do not mutate.
Game.STATE = State

---Mapping of Vim pseudokeys to game motions. Do not mutate.
Game.MOTIONS = Motions

---Configuration (probably shouldn't be changed though)

---The base length of a game round in nanoseconds.
---TODO: this should be dynamic and actually used as the base value
---@type integer
Game.LENGTH = 5e9
---The UI tickrate in milliseconds.
---@type integer
Game.TICKRATE = 16
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

	self.state = "ready"
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
	self.elapsed = vim.uv.hrtime() - (self.real_start or 0) -- self.started
	self.ui:draw(self)

	-- if self.elapsed > Game.LENGTH then
	-- 	self:stop()
	-- end
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
	vim.defer_fn(function()
		self.current = self:pick_stratagem()
		self.entered = 0
	end, self.SUCCESS_DELAY)
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
	-- self.started = vim.uv.hrtime()
	-- self.real_start = self.started + (self.COUNTDOWN_DELAY * 1e6)
	-- self.elapsed = 0
	self.ui:mount()
	self.timer:start()
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
	self.current = self:pick_stratagem()

	self.started = vim.uv.hrtime()
	self.real_start = self.started + (self.COUNTDOWN_DELAY * 1e6)
	self.elapsed = 0

	self:show()

	self.state = "starting"

	vim.defer_fn(function()
		self.state = "playing"
	end, self.COUNTDOWN_DELAY)
end

---Stops the game, and triggers the display of the game over UI.
---
---This does *not* close the game UI.
function Game:stop()
	self.timer:stop()
	self.state = "over"
	self.ui:draw(self)
	if timeout ~= nil then
		vim.o.timeoutlen = timeout
	end
	timeout = nil
end

return Game
