local M = {}

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

-- TODO:
-- 1. Create a command to start the game
-- 2. Manage the game progress with a timer
-- 3. Create buffer-local mappings or use `vim.on_key` to play the game
-- 4. UI window with nice appearance
-- 5. Subcommands / bang to stop / restart the game

function M.setup()
	local Game = require("strat-hero.game")
	vim.api.nvim_create_user_command("StratHero", function()
		pcall(function()
			if _G.game then
				_G.game:stop()
				_G.game = nil
			end
		end)
		local game = Game.new()

		game:start()

		_G.game = game
	end, {
		nargs = 0,
		bang = false,
	})
end

for k in pairs(package.loaded) do
	if k:match("^strat%-hero") then
		package.loaded[k] = nil
	end
end
vim.opt.rtp:prepend(vim.uv.cwd())
M.setup()
vim.cmd.StratHero()

return M
