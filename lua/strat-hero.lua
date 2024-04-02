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
  require("strat-hero.command").setup()
end

return M
