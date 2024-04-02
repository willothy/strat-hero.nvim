---The main game view, responsible for rendering the "playing" and "failed" states
---@class StratHero.Ui.GameView: StratHero.Ui.View

---@type StratHero.Ui.GameView
local GameView = {}

function GameView.render(game, win_config)
  local Line = require("nui.line")
  local Text = require("nui.text")

  win_config.title = string.format(
    "SCORE %d%sROUND %d",
    game.score,
    string.rep(
      " ",
      40 - (#("score " .. game.score) + #("round " .. game.round))
    ),
    game.round
  )

  local percent_remaining
  if game.state == game.STATE.STARTING then
    percent_remaining = (game.remaining / (game.COUNTDOWN_DELAY * 1e6))
  elseif
    game.state == game.STATE.PLAYING or game.state == game.STATE.FAILED
  then
    percent_remaining = (game.remaining / (game.TIME_LIMIT * 1e6))
  elseif game.state == game.STATE.OVER then
    percent_remaining = 0
  elseif game.state == game.STATE.READY then
    percent_remaining = 100
  end

  local raw_width = percent_remaining * 40
  local bar_width = math.floor(raw_width)
  local bar_tail = raw_width - bar_width

  local icons = require("strat-hero.icons")
  local progress_blocks = icons.progress_blocks
  local arrows = icons.arrows

  local block = ""
  if raw_width > 0 and bar_tail > 0 then
    block = progress_blocks[math.floor(bar_tail * 8) + 1]
  end

  local progress_bar = progress_blocks[8]:rep(bar_width) .. block
  win_config.footer = progress_bar

  local sequence = Line()

  local stratagem = game.current
  local entered = game.entered
  local did_fail = game.state == game.STATE.FAILED

  for i, motion in ipairs(stratagem.sequence) do
    local hl
    if did_fail then
      hl = "DiagnosticError"
    elseif i < (entered + 1) then
      hl = "DiagnosticOk"
    else
      hl = "Comment"
    end
    sequence:append(string.format(" %s ", arrows[motion]), hl)
  end

  return {
    Line(),
    Line({ Text(stratagem.name, "Title") }),
    Line(),
    sequence,
  }
end

return GameView
