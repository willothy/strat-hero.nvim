local Stratagems = require("strat-hero.stratagems")
local Ui = require("strat-hero.ui")

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
---@field timer uv_timer_t
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

	return setmetatable(self, { __index = Game })
end

function Game:on_key(motion)
	local expected = self.current.sequence[self.entered + 1]

	if expected ~= motion then
		self:fail()
		vim.print("fail")
		return
	end
	self.entered = self.entered + 1
	vim.print("entered")
	if self.entered == #self.current.sequence then
		vim.print("success")
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
	self.current = self:pick_stratagem()
	self.entered = 0
end

function Game:fail()
	self.entered = 0
	-- todo: show some feedback
end

function Game:start()
	if self.started and self.state ~= "over" then
		return
	end
	if self.timer == nil or self.timer:is_closing() then
		self.timer = vim.uv.new_timer()
	end

	-- self.ns = vim.on_key(function(key)
	-- 	self:on_key(key)
	-- end, self.ns)

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
	self.ui:mount()

	self.timer:start(
		10,
		10,
		vim.schedule_wrap(function()
			self.elapsed = vim.uv.hrtime() - self.started
			self.ui:draw(self)

			-- if self.elapsed > Game.LENGTH then
			-- 	self:stop()
			-- end
		end)
	)
end

function Game:stop()
	if self.timer and not self.timer:is_closing() then
		self.timer:stop()
	end
	self.state = "over"
	self.ui:draw(self)
end

return Game
