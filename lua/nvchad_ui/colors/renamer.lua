local M = {}
local utils = require "nvchad_ui.colors.utils"

M.apply_highlights = function()
  local colors = {
    black = utils.extract_highlight_colors("Normal", "bg"),
    red = vim.g.terminal_color_1,
  }
  M.highlights = {
    RenamerTitle = { fg = colors.black, bg = colors.red },
    RenamerBorder = { fg = colors.red },
  }
end

return M
