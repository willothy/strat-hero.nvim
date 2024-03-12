---@class StratHero.Ui.RoundEnd: StratHero.Ui.View

---@type StratHero.Ui.RoundEnd
local M = {}

local function rpad(str, len)
  str = tostring(str or "")
  return str .. string.rep(" ", len - #str)
end

function M.render(game, win_config, first_render)
  if not first_render then
    return
  end
  local Line = require("nui.line")
  local Text = require("nui.text")

  win_config.title_pos = "center"
  win_config.title = ""
  win_config.footer = ""

  local max_time_bonus = 100
  local remaining = game.remaining / (game.TIME_LIMIT + (game.successes * 500))
  local time_bonus = math.floor(max_time_bonus * remaining)

  local perfect = game.failures == 0

  local rows = {
    { "Score", game.score },
    { "Bonus:" },
    { "Time", tostring(time_bonus) },
    { "Perfect", tostring(perfect and 100 or 0) },
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
      return Line({
        Text(rpad(row[1] or "", l_len), "Title"),
        Text(rpad(row[2] or "", r_len), "DiagnosticWarn"),
      })
    end)
    :totable()
end

return M
