---Small abstraction over `uv_timer_t` to simplify usage and ensure proper cleanup.
---@class StratHero.Timer
---Interval in milliseconds between timer invocations.
---@field interval integer
---Callback to be invoked by the timer (automatically `vim.schedule`-ed).
---@field callback fun()
---Userdata proxy used to ensure the timer is stopped when the handle object is garbage collected.
---This is the main purpose of this abstraction, as well as making it simpler to pause and resume the
---timer.
---@field private proxy userdata
local Timer = {}

---Creates a new timer instance with the given interval and callback.
---@param interval integer
---@param callback fun()
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

---Starts the timer, or resumes it if it was paused.
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

---Pause / stop the timer. This does not close the timer, so it can be resumed later.
function Timer:stop()
	if self.timer and not self.timer:is_closing() then
		self.timer:stop()
	end
end

---Returns true if the timer is running.
---@return boolean
function Timer:is_active()
	if self.timer == nil or self.timer:is_closing() or not self.timer:is_active() then
		return false
	end
	return true
end

---Returns true if the timer is closing or has been closed.
---@return boolean
function Timer:is_closing()
	if self.timer == nil or self.timer:is_closing() then
		return true
	end
	return false
end

---Performs manual cleanup of the timer.
---It is still safe to start the timer after this, but it will create a new timer instance.
function Timer:close()
	if self.timer and not self.timer:is_closing() then
		self.timer:close()
	end
	self.timer = nil
end

return Timer
