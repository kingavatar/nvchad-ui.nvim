local M = {}
local utils = require "nvchad_ui.colors.utils"

M.apply_highlights = function()
  local colors = {
    -- black = vim.g.terminal_color_0,
    black = utils.extract_highlight_colors("Normal", "bg"),
    bright_black = vim.g.terminal_color_8,
    red = vim.g.terminal_color_1,
    bright_red = vim.g.terminal_color_9,
    green = vim.g.terminal_color_2,
    bright_green = vim.g.terminal_color_10,
    yellow = vim.g.terminal_color_3,
    bright_yellow = vim.g.terminal_color_11,
    blue = vim.g.terminal_color_4,
    bright_blue = vim.g.terminal_color_12,
    magenta = vim.g.terminal_color_5,
    bright_magenta = vim.g.terminal_color_13,
    cyan = vim.g.terminal_color_6,
    bright_cyan = vim.g.terminal_color_14,
    white = vim.g.terminal_color_7,
    bright_white = vim.g.terminal_color_15,
    light_grey = utils.extract_highlight_colors("NonText", "fg"),
    light_bg = utils.extract_highlight_colors("PmenuSel", "bg"),
    one_bg = utils.extract_highlight_colors("CursorLine", "bg"),
    one_bg3 = utils.extract_highlight_colors("Visual", "bg"),
    special = utils.extract_highlight_colors("Special", "fg"),
    statusline_bg = utils.extract_highlight_colors("StatusLine", "bg"),
    normal_bg = utils.extract_highlight_colors("Normal", "bg"),
  }

  ---@source https://github.com/akinsho/bufferline.nvim/blob/main/lua/bufferline/config.lua#L349
  -- If the colorscheme is bright we shouldn't do as much shading
  -- as this makes light color schemes harder to read
  local is_bright_background = utils.color_is_bright(colors.normal_bg --[[@as string]])
  local separator_shading = is_bright_background and -20 or -45
  colors.black2 = utils.shade_color(colors.normal_bg --[[@as string]], separator_shading)
  colors.one_bg2 = colors.one_bg3

  M.highlights = {

    TblineFill = {
      bg = colors.black2,
    },

    TbLineBufOn = {
      fg = colors.white,
      bg = colors.black,
    },

    TbLineBufOff = {
      fg = colors.light_grey,
      bg = colors.black2,
    },

    TbLineBufOnModified = {
      fg = colors.green,
      bg = colors.black,
    },

    TbBufLineBufOffModified = {
      fg = colors.red,
      bg = colors.black2,
    },

    TbLineBufOnClose = {
      fg = colors.red,
      bg = colors.black,
    },

    TbLineBufOffClose = {
      fg = colors.light_grey,
      bg = colors.black2,
    },

    TblineTabNewBtn = {
      fg = colors.white,
      bg = colors.one_bg3,
      bold = true,
    },

    TbLineTabOn = {
      fg = colors.black,
      bg = colors.special,
      bold = true,
    },

    TbLineTabOff = {
      fg = colors.white,
      bg = colors.one_bg2,
    },

    TbLineTabCloseBtn = {
      fg = colors.black,
      bg = colors.special,
    },

    TBTabTitle = {
      fg = colors.black,
      bg = colors.white,
    },

    TbLineThemeToggleBtn = {
      bold = true,
      fg = colors.white,
      bg = colors.one_bg3,
    },

    TbLineCloseAllBufsBtn = {
      bold = true,
      bg = colors.red,
      fg = colors.black,
    },
  }
end

return M
