---View interface for drawing to the UI. A view takes the current game state and
---the window config of the UI, and returns a list of Nui lines to render.
---
---The view should mutate the win_config as needed to make any updates; the Ui
---will call `vim.api.nvim_win_set_config` with the updated config automatically.
---@class StratHero.Ui.View
---Renders the view into NuiLines, and optionally mutates the window config.
---Return nil to not redraw the view. The win_config will only be updated if it's
---changed.
---@field render fun(game: StratHero.Game, win_config: vim.api.keyset.win_config, first_render: boolean): NuiLine[]?

---The UI for the game.
---The UI is managed by the Game object, and is *only* responsible for drawing its current
---state and handling window/buffer logic. It should have no knowledge of the game's internals.
---@class StratHero.Ui
---Window opened by the Ui, if it is shown.
---@field win integer?
---Buffer currently owned by the Ui, if any.
---@field buf integer?
---Namespace for the Ui buffer.
---@field ns integer
local Ui = {}

---@type table<StratHero.State, string>
local views = {
	ready = "splash",
	starting = "countdown",
	playing = "gameview",
	failed = "gameview",
	over = "gameover",
}

---Creates a new Ui instance.
---@return StratHero.Ui
function Ui.new()
	return setmetatable({}, { __index = Ui })
end

---Gets a handle to the Ui buffer, creating one if it doesn't exist.
---Since autocmds and mappings for the Ui need to be buffer-local, it is
---important that all operations happen on the same buffer.
---@return integer
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

---@class StratHero.Ui.EventOpts
---@field user boolean? Whether to use the User autocmd event.
---@field buffer boolean? Whether to use the buffer-local autocmd event.

---Registers an autocmd for the Ui.
---@param event string
---Callback to be invoked by the autocmd. The callback should return true if the
---autocmd should be removed after being invoked.
---@param callback fun(args: table): boolean?
---@param opts StratHero.Ui.EventOpts?
---@return integer autocmd The autocmd id
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
	local id
	id = vim.api.nvim_create_autocmd(event, {
		pattern = pattern,
		callback = function(args)
			if callback(args) then
				self:off(id)
			end
		end,
		buffer = buffer,
	})
	return id
end

---Removes an autocmd registered to the Ui, given its id.
---@param event_id integer The autocmd id returned by `Ui:on`
function Ui:off(event_id)
	vim.api.nvim_del_autocmd(event_id)
end

---Shows the Ui window.
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

---@class StratHero.Ui.KeymapOpts
---@field mode string? The mode to map the key in. Default: "n"
---@field expr boolean? Whether to use an expression mapping.

---Creates a buffer-local mapping for the Ui.
---@param key string
---@param action fun() | string
---@param opts StratHero.Ui.KeymapOpts?
function Ui:map(key, action, opts)
	opts = opts or {}
	local buf = self:get_buf()

	local mode = opts.mode or "n"
	opts.mode = nil

	vim.keymap.set(
		mode,
		key,
		action,
		vim.tbl_deep_extend("force", opts, {
			buffer = buf,
			noremap = true,
			expr = opts.expr,
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

	local new_view = false
	local view = require("strat-hero.view." .. views[game.state]) ---@type StratHero.Ui.View
	if view ~= self.view then
		self.view = view
		new_view = true
	end
	local buf = self:get_buf()

	local Text = require("nui.text")

	---TODO: Benchmark this. Is it beneficial to (maybe) not make native calls as often?
	local win_config_dirty = false
	local win_config_mutator = setmetatable({}, {
		__index = win_config,
		__newindex = function(_, k, v)
			win_config_dirty = true
			rawset(win_config, k, v)
		end,
	})

	local lines = view.render(game, win_config_mutator, new_view)

	if lines then
		if #lines < vim.api.nvim_buf_line_count(buf) then
			vim.api.nvim_buf_set_lines(buf, 0, -1, false, {})
		end
		vim.iter(lines)
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
	end

	if win_config_dirty then
		vim.api.nvim_win_set_config(self.win, win_config)
	end
end

---Closes the Ui window.
function Ui:unmount()
	if self.win and vim.api.nvim_win_is_valid(self.win) then
		vim.api.nvim_win_close(self.win, true)
	end
end

---Closes the game window, and deletes the buffer.
function Ui:destroy()
	self:unmount()
	if self.buf and vim.api.nvim_buf_is_valid(self.buf) then
		vim.api.nvim_buf_delete(self.buf, { force = true })
	end
end

return Ui
