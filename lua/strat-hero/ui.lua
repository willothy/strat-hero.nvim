local progress_blocks = {
	"▏",
	"▎",
	"▍",
	"▌",
	"▋",
	"▊",
	"▉",
	"█",
}

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

function Ui:mount()
	if self.win and vim.api.nvim_win_is_valid(self.win) then
		return
	end

	if self.buf == nil or not vim.api.nvim_buf_is_valid(self.buf) then
		self.buf = vim.api.nvim_create_buf(false, true)
	end

	local width = 40
	local height = 10

	local row = math.floor((vim.o.lines / 2) - (height / 2) + 0.5)
	local col = math.floor((vim.o.columns / 2) - (width / 2) + 0.5)

	self.win = vim.api.nvim_open_win(self.buf, true, {
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

---Draw the Ui for the given game state.
---@param game StratHero.Game
function Ui:draw(game)
	if self.win == nil or not vim.api.nvim_win_is_valid(self.win) then
		return
	end

	local percent_remaining = 1 - (game.elapsed / 5e9)

	local raw_width = percent_remaining * 40
	local bar_width = math.floor(raw_width)
	local bar_tail = raw_width - bar_width

	local block = ""
	if raw_width > 0 and bar_tail > 0 then
		block = progress_blocks[math.floor(bar_tail * 8) + 1]
	end

	local progress_bar = progress_blocks[8]:rep(bar_width) .. block

	local config = vim.api.nvim_win_get_config(self.win)

	config.title = string.format("Score: %d, Level: %d, Time: %dms", game.score, game.level, game.elapsed / 1e6)
	config.footer = progress_bar

	vim.api.nvim_win_set_config(self.win, config)
end

function Ui:unmount()
	if self.win and vim.api.nvim_win_is_valid(self.win) then
		vim.api.nvim_win_close(self.win, true)
	end
end

return Ui
