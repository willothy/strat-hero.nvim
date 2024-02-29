local Stratagems = require("strat-hero.stratagems")
local Ui = require("strat-hero.ui")
local Timer = require("strat-hero.timer")

local timeout

local motion_keys = {
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

---@alias StratHero.State "ready" | "starting" | "playing" | "over"

---@class StratHero.Game
---@field public state StratHero.State
---@field public score number
---@field public level number
---@field public did_fail boolean
---@field public current StratHero.Stratagem
---@field public entered integer
---@field timer StratHero.Timer
---@field started integer
---@field real_start integer Start with added countdown delay
---@field elapsed integer
---@field stratagems StratHero.Stratagem[]
---@field ui StratHero.Ui
---@field ns integer
local Game = {}

Game.LENGTH = 5e9 -- todo: make dynamic
Game.TICKRATE = 16 -- ms
Game.SUCCESS_DELAY = 150 -- ms
Game.MISTAKE_DELAY = 300 -- ms
Game.COUNTDOWN_DELAY = 3000 -- ms

---@return StratHero.Game
function Game.new()
	local self = setmetatable({}, { __index = Game })

	self.state = "ready"
	self.stratagems = Stratagems.list({})

	self.ui = Ui.new()
	for key, motion in pairs(motion_keys) do
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

function Game:tick()
	self.elapsed = vim.uv.hrtime() - (self.real_start or 0) -- self.started
	self.ui:draw(self)

	-- if self.elapsed > Game.LENGTH then
	-- 	self:stop()
	-- end
end

function Game:on_key(motion)
	if not self.started then
		self:start()
		return
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

function Game:pick_stratagem()
	local rand = math.random(#self.stratagems)
	local strat = self.stratagems[rand]
	-- lazy way to avoid the same stratagem twice in a row
	while strat == self.current do
		rand = math.random(#self.stratagems)
		strat = self.stratagems[rand]
	end

	return strat
end

function Game:success()
	-- TODO: separate game "engine" timer (tick) and in-game level timer
	-- so that we can pause the timer for a tiny bit to show feedback.
	-- self.timer:stop()

	vim.defer_fn(function()
		self.current = self:pick_stratagem()
		self.entered = 0
		-- self.timer:start()
	end, self.SUCCESS_DELAY)
end

function Game:fail()
	self.entered = 0
	self.did_fail = true
	vim.defer_fn(function()
		self.did_fail = false
	end, self.MISTAKE_DELAY)
end

function Game:show()
	-- self.started = vim.uv.hrtime()
	-- self.real_start = self.started + (self.COUNTDOWN_DELAY * 1e6)
	-- self.elapsed = 0
	self.ui:mount()
	self.timer:start()
end

function Game:start()
	if self.started and self.state ~= "over" then
		return
	end
	if timeout == nil then
		timeout = vim.o.timeoutlen
	end
	vim.o.timeoutlen = 0

	self.score = 0
	self.level = 1
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