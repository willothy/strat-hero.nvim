---@class StratHero.Ui.GameView: StratHero.Ui.View
local GameView = {}

function GameView.render(game, config)
	local Line = require("nui.line")
	local Text = require("nui.text")

	config.title = string.format(
		"SCORE %d%sROUND %d",
		game.score,
		string.rep(" ", 40 - (#("score " .. game.score) + #("round " .. game.level))),
		game.level
	)

	local percent_remaining = 1 - (math.max(0, game.elapsed - game.COUNTDOWN_DELAY) / game.LENGTH)

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
	config.footer = progress_bar

	local sequence = Line()

	local stratagem = game.current
	local entered = game.entered
	local did_fail = game.did_fail

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
