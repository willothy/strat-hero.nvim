---@class StratHero.Ui.View
---@field render fun(game: StratHero.Game, win_config: vim.api.keyset.win_config): NuiLine[]

---The UI for the game.
---The UI is managed by the Game object, and is *only* responsible for drawing its current
---state and handling window/buffer logic. It should have no knowledge of the game's internals.
---@class StratHero.Ui
---@field win integer?
---@field buf integer?
local Ui = {}

---@return StratHero.Ui
function Ui.new()
	local self = setmetatable({}, { __index = Ui })

	return self
end

function Ui:get_buf()
	if self.buf and vim.api.nvim_buf_is_valid(self.buf) then
		return self.buf
	end

	self.buf = vim.api.nvim_create_buf(false, true)

	for k, v in pairs({
		swapfile = false,
		undofile = false,
		buflisted = false,
		buftype = "nofile",
		filetype = "strat-hero",
	}) do
		vim.api.nvim_set_option_value(k, v, { buf = self.buf })
	end

	return self.buf
end

function Ui:on(event, callback, opts)
	opts = opts or {}
	local pattern, buffer
	if opts.user then
		pattern = event
		event = "User"
	end
	if opts.buffer ~= false then
		buffer = self:get_buf()
	end
	vim.api.nvim_create_autocmd(event, {
		pattern = pattern,
		callback = callback,
		buffer = buffer,
	})
end

function Ui:off(event_id)
	vim.api.nvim_del_autocmd(event_id)
end

function Ui:mount()
	if self.win and vim.api.nvim_win_is_valid(self.win) then
		return
	end

	self.ns = self.ns or vim.api.nvim_create_namespace("strat-hero")

	local width = 40
	local height = 6

	local row = math.floor((vim.o.lines / 2) - (height / 2) + 0.5)
	local col = math.floor((vim.o.columns / 2) - (width / 2) + 0.5)

	self.win = vim.api.nvim_open_win(self:get_buf(), true, {
		relative = "editor",
		width = width,
		height = height,
		row = row,
		col = col,
		style = "minimal",
		border = "solid",
		title = "",
		title_pos = "left",
		footer = "",
		footer_pos = "left",
	})
end

function Ui:map(key, action, opts)
	local buf = self:get_buf()
	opts = opts or {}

	local mode = opts.mode or "n"
	opts.mode = nil

	vim.keymap.set(
		mode,
		key,
		action,
		vim.tbl_deep_extend("force", opts, {
			buffer = buf,
		})
	)
end

---Draw the Ui for the given game state.
---@param game StratHero.Game
function Ui:draw(game)
	if self.win == nil or not vim.api.nvim_win_is_valid(self.win) then
		return
	end

	local win_config = vim.api.nvim_win_get_config(self.win)

	local title = "Strategem Hero"
	win_config.title = string.rep(" ", 20 - math.floor((#title / 2) + 0.5)) .. title

	-- This is ugly but I want the names to make sense
	local view_name = ({
		ready = "splash",
		starting = "countdown",
		playing = "gameview",
		over = "gameover",
	})[game.state]
	---@type StratHero.Ui.View
	local view = require("strat-hero.view." .. view_name)

	local buf = self:get_buf()

	local Text = require("nui.text")

	-- win_config may be mutated by the view.render function
	vim.iter(view.render(game, win_config))
		:map(function(line)
			local width = line:width()
			if width <= win_config.width then
				local texts = line._texts
				table.insert(texts, 1, Text(string.rep(" ", math.floor((40 - width) / 2))))
			end
			return line
		end)
		:enumerate()
		:each(function(i, line)
			line:render(buf, self.ns, i)
		end)

	vim.api.nvim_win_set_config(self.win, win_config)
end

function Ui:unmount()
	if self.win and vim.api.nvim_win_is_valid(self.win) then
		vim.api.nvim_win_close(self.win, true)
	end
end

return Ui
