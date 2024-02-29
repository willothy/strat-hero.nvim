---@class StratHero.Ui.Countdown: StratHero.Ui.View
local Countdown = {}

function Countdown.render(game, win_config)
	local progress_blocks = require("strat-hero.icons").progress_blocks
	local Text = require("nui.text")
	local Line = require("nui.line")

	win_config.footer = progress_blocks[8]:rep(40)

	local countdown = (game.COUNTDOWN_DELAY - game.elapsed) / 1e9
	return {
		Line(),
		Line({ Text("Get ready!", "Title") }),
		Line(),
		Line({ Text(("Starting in %.1fs"):format(countdown), "Comment") }),
		Line(),
	}
end

return Countdown
