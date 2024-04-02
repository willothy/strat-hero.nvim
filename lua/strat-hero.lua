local M = {}

-- TODO:
-- 1. Start game with filters
-- 2. More advanced filters
--    - Unlock level
--    - Sequence length
-- 3. Subcommands / bang to stop / restart the game
-- 4. Mode-specific games (limit to wasd, hjkl, etc.)
-- 5. Score history and stats
-- 6. Leaderboard (?)
-- 7. Tests
-- 8. Docs
-- 9. Add stratagems from new updates

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
