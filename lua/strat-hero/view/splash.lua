---The splash view for when the UI is first opened.
---@class StratHero.Ui.Splash: StratHero.Ui.View

---@type StratHero.Ui.Splash
local Splash = {}

function Splash.render(_game, win_config, first_render)
  if not first_render then
    return
  end
  local Line = require("nui.line")
  local Text = require("nui.text")
  local progress_blocks = require("strat-hero.icons").progress_blocks

  win_config.title_pos = "center"
  win_config.title = "Stratagem Hero"
  win_config.footer = progress_blocks[8]:rep(40)
  win_config.footer_pos = "left"

  return {
    Line(),
    Line(),
    Line({ Text("Press a move key to start", "Title") }),
    Line(),
    Line(),
  }
end

return Splash
