local M = {}

-- TODO:
-- 1. Start game with filters
-- 2. More advanced filters
-- 3. Finish UI
-- 4. Sequential game levels with increasing difficulty
-- 5. Subcommands / bang to stop / restart the game

function M.setup()
	local Game = require("strat-hero.game")
	vim.api.nvim_create_user_command("StratHero", function()
		-- NOTE: just for debugging
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

return M
