local M = {}

local Game = require("strat-hero.game")

---@private
---@type StratHero.Game?
local running = nil

---@param cb fun(game: StratHero.Game)
---@param check boolean?
local function with_game(cb, check)
  if running then
    if
      check
      and running.state ~= Game.STATE.OVER
      and running.state ~= Game.STATE.READY
    then
      vim.notify("Game is already running", vim.log.levels.WARN)
      return
    end
  else
    running = Game.new()
  end
  cb(running)
end

M.subcommands = {
  start = {
    execute = function(_args, _fargs)
      with_game(function(game)
        game:start()
      end, true)
    end,
    complete = function()
      return {}
    end,
  },
  show = {
    execute = function(_args, _fargs)
      with_game(function(game)
        game:show()
      end, true)
    end,
    complete = function()
      return {}
    end,
  },
  stop = {
    execute = function(_args, _fargs)
      with_game(function(game)
        game:stop()
      end)
    end,
    complete = function()
      return {}
    end,
  },
  close = {
    execute = function(_args, _fargs)
      with_game(function(game)
        game:stop()
        game.ui:unmount()
      end)
    end,
    complete = function()
      return {}
    end,
  },
  restart = {
    execute = function(_args, _fargs)
      with_game(function(game)
        game:stop()
        game:start()
      end)
    end,
    complete = function()
      return {}
    end,
  },
}

function M.execute(args)
  local subcommand_name = args.fargs[1] or ""
  local subcommand = M.subcommands[subcommand_name]

  if not subcommand then
    vim.notify(
      "Unknown subcommand: '" .. subcommand_name .. "'",
      vim.log.levels.ERROR
    )
    return
  end

  subcommand.execute(args, { unpack(args.fargs, 2) })
end

function M.complete(_arg_lead, cmd_line, _cursor_pos)
  local parsed = vim.api.nvim_parse_cmd(cmd_line, {})

  local args = parsed.args

  if #args == 0 then
    return vim
      .iter(M.subcommands)
      :map(function(subcommand)
        return subcommand
      end)
      :totable()
  end

  local subcommand_name = args[1]
  local subcommand = M.subcommands[subcommand_name]

  if not subcommand then
    return {}
  end

  return subcommand.complete()
end

function M.setup()
  vim.api.nvim_create_user_command("StratHero", M.execute, {
    nargs = "*",
    bang = true,
    complete = M.complete,
    desc = "Control strat-hero.nvim",
  })
end

return M
