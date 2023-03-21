local M = {}

-- From https://github.com/nvim-lualine/lualine.nvim/blob/master/lua/lualine/utils/utils.lua#L11
-- Note for now only works for termguicolors scope can be bg or fg or any other
-- attr parameter like bold/italic/reverse
---@param color_group string hl_group name
---@param scope       string bg | fg | sp
---@return table|string returns #rrggbb formatted color when scope is specified
----                       or complete color table when scope isn't specified
function M.extract_highlight_colors(color_group, scope)
  local color = vim.api.nvim_get_hl_by_name(color_group, true)
  if color.background ~= nil then
    color.bg = string.format("#%06x", color.background)
    color.background = nil
  end
  if color.foreground ~= nil then
    color.fg = string.format("#%06x", color.foreground)
    color.foreground = nil
  end
  if color.special ~= nil then
    color.sp = string.format("#%06x", color.special)
    color.special = nil
  end
  if scope then
    return color[scope]
  end
  return color
end

return M
