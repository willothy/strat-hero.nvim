local M = {}

-- TODO:
-- 0. Refactor views to simplify game/ui interactions and interface
--    - Ideally, the game should pass the composed view + state to the UI, and the UI should *just* handle drawing it.
--    - I don't like having to pass the game to `Ui:draw`, it kinda breaks the encapsulation.
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
