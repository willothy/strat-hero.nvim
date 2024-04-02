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

local function complete_start(parsed, arg_lead)
  local last = parsed.args[#parsed.args]
  if arg_lead == "" then
    last = ""
  end
  if not last then
    return
  end
  local map = {}
  for _, key in ipairs(parsed.args) do
    local k, v = key:match("([^=]+)=(.+)")
    if k and v then
      map[k] = true
    end
  end
  local key, _val = last:match("([^=]+)=(.*)")

  local keys = {
    mode = {
      "wasd",
      "hjkl",
      "arrows",
    },
    -- filter = {
    --   "min_len:",
    --   "max_len:",
    -- },
  }
  if key and keys[key] and _val then
    return vim
      .iter(keys[key])
      :map(function(value)
        return value
      end)
      :totable()
  end
  if key == nil or key == "" then
    return vim
      .iter(keys)
      :filter(function(k)
        return not map[k]
      end)
      :map(function(k)
        return k .. "="
      end)
      :totable()
  end
  if keys[key] == nil or map[key] then
    return {}
  end
  return vim
    .iter(keys[key])
    :map(function(value)
      return value
    end)
    :totable()
end

M.subcommands = {
  start = {
    execute = function(_args, fargs)
      local args = fargs
      local opts = {}
      for _, arg in ipairs(args) do
        local k, v = arg:match("([^=]+)=(.+)")
        if k and v then
          opts[k] = v
        end
      end
      if opts.filter then
        vim.notify("Filter not implemented", vim.log.levels.ERROR)
        return
      end
      if opts.mode then
        vim.notify("Modes not yet implemented", vim.log.levels.ERROR)
        return
      end
      with_game(function(game)
        game:start()
      end, true)
    end,
    complete = complete_start,
  },
  open = {
    execute = function(_args, _fargs)
      with_game(function(game)
        game:show()
      end, true)
    end,
    complete = complete_start,
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
        game:hide()
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
  local subcommand_name = args.fargs[1]

  if not subcommand_name then
    if running then
      if args.bang then
        running:hide()
        running = nil
      end
    else
      running = Game.new()
      running:show()
    end
    return
  end

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

function M.complete(arg_lead, cmd_line, _cursor_pos)
  local parsed = vim.api.nvim_parse_cmd(cmd_line, {})

  local args = parsed.args

  if #args == 0 or (#args == 1 and arg_lead ~= "") then
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

  return subcommand.complete(parsed, arg_lead)
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
