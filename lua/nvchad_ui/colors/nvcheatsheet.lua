local M = {}
local utils = require "nvchad_ui.colors.utils"

M.apply_highlights = function()
  local cheatsheet_theme = require("nvchad_ui.config").options.cheatsheet
  local colors = {
    black = vim.g.terminal_color_0,
    red = vim.g.terminal_color_1,
    bright_red = vim.g.terminal_color_9,
    green = vim.g.terminal_color_2,
    vibrant_green = vim.g.terminal_color_10,
    yellow = vim.g.terminal_color_3,
    blue = vim.g.terminal_color_4,
    purple = vim.g.terminal_color_5,
    cyan = vim.g.terminal_color_6,
    white = vim.g.terminal_color_7,
    special = utils.extract_highlight_colors("Special", "fg"),
    normal_bg = utils.extract_highlight_colors("Normal", "bg"),
  }

  colors.orange = utils.getOrangeColor(colors.red, colors.yellow)
  colors.teal = utils.mixColors(colors.blue, colors.green)
  colors.baby_pink = utils.mixColors(colors.bright_red, colors.white)

  M.highlights = {
    NvChHeading = {
      fg = colors.normal_bg,
      bg = colors.special,
      bold = true,
    },

    NvChSection = {
      bg = colors.black,
    },

    NvChAsciiHeader = {
      fg = colors.special,
      bg = colors.black,
    },
  }

  if cheatsheet_theme == "grid" then
    M.highlights.NvChAsciiHeader = {
      fg = colors.special,
    }
    local bgcols = { "blue", "red", "green", "yellow", "orange", "baby_pink", "purple", "white", "cyan", "vibrant_green", "teal" }

    for _, value in ipairs(bgcols) do
      ---@diagnostic disable-next-line: no-unknown
      M.highlights["NvChHead" .. value] = {
        fg = colors.black,
        bg = colors[value],
      }
    end
  end
end

return M
