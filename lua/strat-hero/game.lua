local Stratagems = require("strat-hero.stratagems")
local Ui = require("strat-hero.ui")

---@alias StratHero.State "ready" | "playing" | "over"

---@class StratHero.Game
---@field public state StratHero.State
---@field public score number
---@field public level number
---@field timer uv_timer_t
---@field started integer
---@field elapsed integer
---@field stratagems StratHero.Stratagem[]
---@field ui StratHero.Ui
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

function Game:start()
	if self.started and self.state ~= "over" then
		return
	end
	if self.timer == nil or self.timer:is_closing() then
		self.timer = vim.uv.new_timer()
	end

	self.score = 0
	self.level = 1

	self.started = vim.uv.hrtime()
	self.elapsed = 0

	self.ui:mount()

	self.timer:start(
		10,
		10,
		vim.schedule_wrap(function()
			self.elapsed = vim.uv.hrtime() - self.started
			self.ui:draw(self)

			if self.elapsed > Game.LENGTH then
				self:stop()
			end
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
