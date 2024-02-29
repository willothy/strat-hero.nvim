---@class StratHero.Timer
---@field interval integer
---@field callback fun()
local Timer = {}

function Timer.new(interval, callback)
	local proxy = newproxy(true)
	local self = {
		interval = interval,
		callback = callback,
		proxy = proxy,
	}
	self = setmetatable(self, { __index = Timer })

	getmetatable(proxy).__gc = function()
		if self.timer and not self.timer:is_closing() then
			if self.timer:is_active() then
				self.timer:stop()
			end
			self.timer:close()
		end
	end

	return self
end

function Timer:start()
	if self.timer and not self.timer:is_closing() then
		self.timer:again()
		return
	end
	if self.timer == nil or self.timer:is_closing() then
		self.timer = vim.uv.new_timer()
	end
	self.timer:start(self.interval, self.interval, vim.schedule_wrap(self.callback))
end

function Timer:stop()
	if self.timer and not self.timer:is_closing() then
		self.timer:stop()
	end
end

return Timer
