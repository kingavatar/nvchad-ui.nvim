local M = {}
local options = require("nvchad_ui.config").options
local utils = require "nvchad_ui.colors.utils"
local statusline = require "nvchad_ui.colors.statusline"
local tbline = require "nvchad_ui.colors.tbline"
local nvdash = require "nvchad_ui.colors.nvdash"
local nvcheatsheet = require "nvchad_ui.colors.nvcheatsheet"
local renamer = require "nvchad_ui.colors.renamer"
local g = vim.g

g.toggle_theme_icon = "   "
local can_use_lualine = false
local is_startup = true
local not_loaded_on_startup = true

M.on_colorscheme_change = function(reset)
  reset = reset or false
  if is_startup or reset then
    is_startup = false
    local settings_cache_path = vim.g.base46_cache .. "settings"

    ---@type any
    local cached = nil
    local file = io.open(settings_cache_path)
    if file then
      cached = file:read()
      file:close()
    end
    local hash = require("nvchad_ui.util").hash { options, vim.g.colors_name or "", vim.o.bg }
    if cached ~= hash or reset then
      M.load_all_highlights(true)
      file = io.open(settings_cache_path, "wb")
      if file then
        file:write(hash)
        file:close()
      end
    else
      if not_loaded_on_startup then M.load_on_startup() end
    end
  else
    M.load_all_highlights(false)
  end
end

M.load_all_highlights = function(save_to_cache)
  if vim.g.colors_name == nil then require("nvchad_ui.colors.default").apply_default() end
  statusline.apply_highlights(options.statusline.theme)
  can_use_lualine = statusline.can_use_lualine
  tbline.apply_highlights()
  nvdash.apply_highlights()
  nvcheatsheet.apply_highlights()
  renamer.apply_highlights()
  ---@type table<string, table<string, any>>
  local groups = vim.tbl_extend(
    "keep",
    statusline[options.statusline.theme],
    tbline.highlights,
    nvdash.highlights,
    nvcheatsheet.highlights,
    renamer.highlights
  )
  utils.load(groups)
  if save_to_cache then utils.saveStr_to_cache(groups) end
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
M.can_use_lualine = function() return can_use_lualine end

---Lazylaod on startup from cache
M.load_on_startup = function()
  can_use_lualine = options.statusline.lualine
  not_loaded_on_startup = false
  local ok, _ = pcall(dofile, g.base46_cache .. "default")
  if not ok then M.load_all_highlights(true) end
end

return M
