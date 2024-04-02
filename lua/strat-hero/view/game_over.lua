---Game over screen.
---@class StratHero.Ui.Gameover: StratHero.Ui.View

---@type StratHero.Ui.Gameover
local Gameover = {}

local function rpad(str, len)
  str = tostring(str or "")
  return str .. string.rep(" ", len - #str)
end

function Gameover.render(game, win_config, first_render)
  if not first_render then
    return
  end

  local Text = require("nui.text")
  local Line = require("nui.line")

  win_config.title = "Game Over"
  win_config.title_pos = "center"
  win_config.footer = "Press a move key to restart"
  win_config.footer_pos = "center"

  local score = tostring(game.score)
  local round = tostring(game.round)

  local rows = {
    { "Score", score },
    { "Round", round },
    { "" },
    { "High Score", "TODO" },
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
      --
      return Line({
        Text(rpad(row[1] or "", l_len), "Title"),
        Text(rpad(row[2] or "", r_len), "DiagnosticWarn"),
      })
    end)
    :totable()
end

return Gameover
