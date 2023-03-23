local M = {}
local options = require("nvchad_ui.config").options
local statusline = require "nvchad_ui.colors.statusline"

M.load_all_highlights = function()
  if options.statusline.lualine then
    statusline.use_lualine_highlights(options.statusline.theme)
  end
  local groups = statusline[options.statusline.theme]
  for hl, col in pairs(groups) do
    vim.api.nvim_set_hl(0, hl, col)
  end
end

return M
