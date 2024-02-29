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

---@alias StratHero.State "ready" | "playing" | "over"

---@class StratHero.Game
---@field public state StratHero.State
---@field public score number
---@field public level number
---@field timer StratHero.Timer
---@field started integer
---@field elapsed integer
---@field stratagems StratHero.Stratagem[]
---@field current StratHero.Stratagem
---@field entered integer
---@field ui StratHero.Ui
---@field ns integer
local Game = {}

Game.LENGTH = 5e9 -- todo: make dynamic

---@return StratHero.Game
function Game.new()
	local self = {}

	self.state = "ready"
	self.stratagems = Stratagems.list({})
	self.ui = Ui.new()
	self.timer = Timer.new(16, function()
		self:tick()
	end)

	return setmetatable(self, { __index = Game })
end

function Game:tick()
	self.elapsed = vim.uv.hrtime() - self.started
	self.ui:draw(self)

	-- if self.elapsed > Game.LENGTH then
	-- 	self:stop()
	-- end
end

function Game:on_key(motion)
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
	end, 150)
end

function Game:fail()
	self.entered = 0
	-- todo: show some feedback
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
	self.elapsed = 0

	for key, motion in pairs(motion_keys) do
		self.ui:map(key, function()
			self:on_key(motion)
		end)
	end
	self.ui:on("BufLeave", function()
		self:stop()
		self.ui:unmount()
	end)
	self.ui:mount()

	self.timer:start()
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
