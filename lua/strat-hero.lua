local M = {}

-- TODO:
-- 0. Rework game loop to be pausable so rounds can be implemented
--    - Need to separate the game countdown timer from the redraw / game loop timer.
-- 1. Start game with filters
-- 2. More advanced filters
-- 3. Finish UI
-- 4. Sequential game round with increasing difficulty
-- 5. Subcommands / bang to stop / restart the game
-- 6. Mode-specific games (limit to wasd, hjkl, etc.)

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
		game:show()

		_G.game = game
	end, {
		nargs = 0,
		bang = false,
	})
end

return M
