---The countdown view for starting the game.
---@class StratHero.Ui.Countdown: StratHero.Ui.View

---@type StratHero.Ui.Countdown
local Countdown = {}

function Countdown.render(game, win_config)
	local progress_blocks = require("strat-hero.icons").progress_blocks
	local Text = require("nui.text")
	local Line = require("nui.line")

	win_config.footer = progress_blocks[8]:rep(40)

	local countdown = game.remaining / 1e9
	return {
		Line(),
		Line({ Text(("Round %s"):format(game.round), "Title") }),
		Line(),
		Line({ Text(("Starting in %.1fs"):format(countdown), "Comment") }),
		Line(),
	}
end

return Countdown
