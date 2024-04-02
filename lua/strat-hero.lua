local M = {}

-- TODO:
-- 0. Round transition screen
--    - Overview of round score, time, bonuses
--    - Actually give time and perfect round bonuses
-- 1. Start game with filters
-- 2. More advanced filters
-- 3. Finish UI
-- 4. Subcommands / bang to stop / restart the game
-- 5. Mode-specific games (limit to wasd, hjkl, etc.)
-- 6. Score history and stats
-- 7. Leaderboard (?)
-- 8. Tests
-- 9. Docs

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
