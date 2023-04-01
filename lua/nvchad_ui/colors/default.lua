local M = {}
local g = vim.g
local set_hl = vim.api.nvim_set_hl

M.apply_default = function()
  g.terminal_color_0 = g.terminal_color_0 or "#1b1d2b"
  g.terminal_color_1 = g.terminal_color_1 or "#ff757f"
  g.terminal_color_2 = g.terminal_color_2 or "#c3e88d"
  g.terminal_color_3 = g.terminal_color_3 or "#ffc777"
  g.terminal_color_4 = g.terminal_color_4 or "#82aaff"
  g.terminal_color_5 = g.terminal_color_5 or "#c099ff"
  g.terminal_color_6 = g.terminal_color_6 or "#86e1fc"
  g.terminal_color_7 = g.terminal_color_7 or "#828bb8"
  g.terminal_color_8 = g.terminal_color_8 or "#414868"
  g.terminal_color_9 = g.terminal_color_9 or "#ff757f"
  g.terminal_color_10 = g.terminal_color_10 or "#c3e88d"
  g.terminal_color_11 = g.terminal_color_11 or "#ffc777"
  g.terminal_color_12 = g.terminal_color_12 or "#82aaff"
  g.terminal_color_13 = g.terminal_color_13 or "#c099ff"
  g.terminal_color_14 = g.terminal_color_14 or "#86e1fc"
  g.terminal_color_15 = g.terminal_color_15 or "#c0caf5"

  set_hl(0, "Normal", { fg = "#c0caf5", bg = "#24283b" })
  set_hl(0, "NonText", { fg = "#545c7e" })
  set_hl(0, "PmenuSel", { bg = "#363c58" })
  set_hl(0, "CursorLine", { bg = "#2f334d" })
  set_hl(0, "Visual", { bg = "#2d3f76" })
  set_hl(0, "Special", { fg = "#65bcff" })
  set_hl(0, "StatusLine", { bg = "#222436" })
end

return M
