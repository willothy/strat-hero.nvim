---Game over screen.
---@class StratHero.Ui.RoundEnd: StratHero.Ui.View

---@type StratHero.Ui.RoundEnd
local Gameover = {}

local function rpad(str, len)
  str = tostring(str or "")
  return str .. string.rep(" ", len - string.len(str))
end

function Gameover.render(game, win_config, first_render)
  if not first_render then
    return
  end

  local Text = require("nui.text")
  local Line = require("nui.line")

  win_config.title = string.format("Round %d Over", game.round - 1)
  win_config.title_pos = "center"
  win_config.footer = ""
  win_config.footer_pos = "center"

  local score = tostring(game.score)
  local round = tostring(game.round)

  local rows = {
    { "Score", tostring(score) },
    { "Round", tostring(round) },
    { "" },
    { "Time Bonus", tostring(game.last_time_bonus) },
  }

  local l_max = 0
  local r_max = 0
  for _, row in ipairs(rows) do
    l_max = math.max(l_max, #(row[1] or ""))
    r_max = math.max(r_max, #(row[2] or ""))
  end
  local l_len = l_max + 2
  local r_len = r_max

  return {
    Line(),
    Line({
      Text(rpad("Score", l_len), "Title"),
      Text(rpad(tostring(game.score), r_len), "DiagnosticWarn"),
    }),
    Line({
      Text(rpad("Time Bonus", l_len), "Title"),
      Text(rpad(tostring(game.last_time_bonus), r_len), "DiagnosticWarn"),
    }),
  }
end

return Gameover
