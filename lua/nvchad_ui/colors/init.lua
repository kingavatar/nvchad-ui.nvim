local M = {}
local options = require("nvchad_ui.config").options
local statusline = require "nvchad_ui.colors.statusline"
local tbline = require "nvchad_ui.colors.tbline"
local nvdash = require "nvchad_ui.colors.nvdash"
local g = vim.g

g.toggle_theme_icon = "   "

M.load_all_highlights = function()
  statusline.apply_highlights(options.statusline.theme)
  tbline.apply_highlights()
  nvdash.apply_highlights()
  ---@type table<string, table<string, any>>
  local groups = vim.tbl_extend("keep", statusline[options.statusline.theme], tbline.highlights, nvdash.highlights)
  for hl, col in pairs(groups) do
    vim.api.nvim_set_hl(0, hl, col)
  end
end

M.toggle_theme = function()
  local themes = options.theme_toggle
  if themes == nil or #themes < 2 then
    g.toggle_theme_icon = g.toggle_theme_icon == "   " and "   " or "   "
    vim.notify("Set two themes in theme_toggle option in plugin setup", vim.log.levels.WARN)
    return
  end
  if g.toggle_theme_icon == "   " then
    vim.cmd.colorscheme(themes[2])
    g.toggle_theme_icon = "   "
  else
    vim.cmd.colorscheme(themes[1])
    g.toggle_theme_icon = "   "
  end
end

---check if we can use lualine colors
---@return boolean
M.can_use_lualine = function()
  return statusline.can_use_lualine
end

return M
