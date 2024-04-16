---Game over screen.
---@class StratHero.Ui.RoundEnd: StratHero.Ui.View

---@type StratHero.Ui.RoundEnd
local RoundEnd = {}

local function rpad(str, len)
  str = tostring(str or "")
  return str .. string.rep(" ", len - string.len(str))
end

function RoundEnd.render(game, win_config, first_render)
  if not first_render then
    return
  end

  local Line = require("nui.line")

  win_config.title = string.format("Round %d Over", game.round - 1)
  win_config.title_pos = "center"
  win_config.footer = ""
  win_config.footer_pos = "center"

  local score = tostring(game.score)
  local round = tostring(game.round)
  local time_bonus = tostring(game.last_time_bonus)

  local perfect = game.last_failures == 0
  local perfect_bonus = perfect and tostring(game.PERFECT_ROUND_BONUS) or "0"

  local rows = {
    { "" },
    { "Score", score },
    { "" },
    { "Time Bonus", time_bonus },
    {
      "Perfect Round",
      perfect_bonus,
    },
  }

  local l_max = 0
  local r_max = 0
  for _, row in ipairs(rows) do
    l_max = math.max(l_max, #(row[1] or ""))
    r_max = math.max(r_max, #(row[2] or ""))
  end
  local l_len = l_max + 2
  local r_len = r_max

  return vim
    .iter(rows)
    :map(function(row)
      local line = Line()
      if row[1] then
        line:append(rpad(row[1], l_len), "Title")
      end
      if row[2] then
        line:append(rpad(row[2], r_len), "DiagnosticWarn")
      end
      return line
    end)
    :totable()
end

return RoundEnd
