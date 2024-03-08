---The splash view for when the UI is first opened.
---@class StratHero.Ui.Splash: StratHero.Ui.View

---@type StratHero.Ui.Splash
local Splash = {}

function Splash.render(_game, config)
  local Line = require("nui.line")
  local Text = require("nui.text")
  local progress_blocks = require("strat-hero.icons").progress_blocks
  config.footer = progress_blocks[8]:rep(40)
  return {
    Line(),
    Line(),
    Line({ Text("Press a move key to start", "Title") }),
    Line(),
    Line(),
  }
end

return Splash
