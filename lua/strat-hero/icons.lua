local progress_blocks = {
  "▏",
  "▎",
  "▍",
  "▌",
  "▋",
  "▊",
  "▉",
  "█",
}

---@type table<StratHero.Motion, string>
local arrows = {
  Left = "⬅",
  Down = "⬇",
  Up = "⬆",
  Right = "➡",
}

return {
  arrows = arrows,
  progress_blocks = progress_blocks,
}
