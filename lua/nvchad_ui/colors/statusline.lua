local M = {}

local utils = require "nvchad_ui.colors.utils"

--- Defualt Colors fetched from colorscheme set terminal colors and highlights
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
  -- normal_bg = utils.extract_highlight_colors("Normal", "bg")
}

local lsp_highlights = {
  -- lsp highlights
  St_lspError = {
    fg = utils.extract_highlight_colors("DiagnosticError", "fg"),
    bg = colors.statusline_bg,
  },
  St_lspWarning = {
    fg = utils.extract_highlight_colors("DiagnosticWarn", "fg"),
    bg = colors.statusline_bg,
  },
  St_LspHints = {
    fg = utils.extract_highlight_colors("DiagnosticHint", "fg"),
    bg = colors.statusline_bg,
  },

  St_LspInfo = {
    fg = utils.extract_highlight_colors("DiagnosticInfo", "fg"),
    bg = colors.statusline_bg,
  },
}

M.default = {
  -- git icons
  St_gitIcons = {
    fg = colors.light_grey,
    bg = colors.statusline_bg,
  },

  -- lsp status
  St_LspStatus = {
    fg = colors.special,
    bg = colors.statusline_bg,
  },

  -- lsp progress
  St_LspProgress = {
    fg = colors.bright_green,
    bg = colors.statusline_bg,
  },

  St_LspStatus_Icon = {
    fg = colors.black,
    bg = colors.special,
  },

  St_EmptySpace = {
    fg = utils.extract_highlight_colors("NonText", "fg"),
    bg = colors.light_bg,
  },

  St_EmptySpace2 = {
    fg = utils.extract_highlight_colors("NonText", "fg"),
    bg = colors.statusline_bg,
  },

  St_file_info = {
    bg = colors.light_bg,
    fg = vim.g.terminal_color_7,
  },

  St_file_sep = {
    bg = colors.statusline_bg,
    fg = colors.light_bg,
  },

  St_cwd_icon = {
    fg = colors.one_bg,
    bg = colors.bright_red,
  },

  St_cwd_text = {
    fg = colors.bright_white,
    bg = colors.light_bg,
  },

  St_cwd_sep = {
    fg = colors.bright_red,
    bg = colors.statusline_bg,
  },

  St_pos_sep = {
    fg = colors.bright_green,
    bg = colors.light_bg,
  },

  St_pos_icon = {
    fg = colors.black,
    bg = colors.bright_green,
  },

  St_pos_text = {
    fg = colors.bright_green,
    bg = colors.light_bg,
  },
}

M.minimal = {
  StatusLine = {
    bg = colors.black,
  },

  St_gitIcons = {
    fg = colors.light_grey,
    bg = colors.black,
    bold = true,
  },

  -- LSP
  St_lspError = {
    fg = colors.bright_red,
    bg = colors.black,
  },

  St_lspWarning = {
    fg = colors.yellow,
    bg = colors.black,
  },

  St_LspHints = {
    fg = colors.magenta,
    bg = colors.black,
  },

  St_LspInfo = {
    fg = colors.bright_green,
    bg = colors.black,
  },

  St_LspProgress = {
    fg = colors.bright_green,
    bg = colors.black,
  },

  St_LspStatus_Icon = {
    fg = colors.black,
    bg = colors.bright_blue,
  },

  St_EmptySpace = {
    fg = colors.black,
    bg = colors.black,
  },

  St_EmptySpace2 = {
    fg = colors.black,
  },

  St_file_info = {
    bg = colors.black,
    fg = colors.white,
  },

  St_file_sep = {
    bg = colors.black,
    fg = colors.black,
  },

  St_sep_r = {
    bg = colors.black,
    fg = colors.one_bg,
  },
}

M.vscode = {
  StatusLine = {
    fg = colors.light_grey,
    bg = colors.statusline_bg,
  },

  St_Mode = {
    fg = colors.light_grey,
    bg = colors.one_bg3,
  },

  StText = {
    fg = colors.light_grey,
    bg = colors.statusline_bg,
  },
}

M.vscode_colored = {
  StatusLine = {
    fg = colors.light_grey,
    bg = colors.statusline_bg,
  },

  StText = {
    fg = colors.light_grey,
    bg = colors.statusline_bg,
  },

  -- LSP
  St_lspError = {
    fg = colors.red,
    bg = colors.statusline_bg,
    bold = true,
  },

  St_lspWarning = {
    fg = colors.yellow,
    bg = colors.statusline_bg,
    bold = true,
  },

  St_LspHints = {
    fg = colors.magenta,
    bg = colors.statusline_bg,
    bold = true,
  },

  St_LspInfo = {
    fg = colors.green,
    bg = colors.statusline_bg,
    bold = true,
  },

  St_LspStatus = {
    fg = colors.green,
    bg = colors.statusline_bg,
  },

  St_LspProgress = {
    fg = colors.red,
    bg = colors.statusline_bg,
  },

  St_cwd = {
    fg = colors.red,
    bg = colors.one_bg3,
  },

  St_encode = {
    fg = colors.bright_yellow,
    bg = colors.statusline_bg,
  },

  St_ft = {
    fg = colors.blue,
    bg = colors.statusline_bg,
  },
}

-- From https://github.com/NvChad/base46/blob/v2.0/lua/base46/integrations/statusline.lua#L267
local function genModes_hl(modename, col)
  M.default["St_" .. modename .. "Mode"] = { fg = colors.black, bg = colors[col], bold = true }
  M.default["St_" .. modename .. "ModeSep"] = { fg = colors[col], bg = utils.extract_highlight_colors("NonText", "fg") }
  M.vscode_colored["St_" .. modename .. "Mode"] = { fg = colors[col], bg = colors.one_bg3, bold = true }

  M.minimal["St_" .. modename .. "Mode"] = { fg = colors.black, bg = colors[col], bold = true }
  M.minimal["St_" .. modename .. "ModeSep"] = { fg = colors[col], bg = colors.black, bold = true }
  M.minimal["St_" .. modename .. "modeText"] = { fg = colors[col], bg = colors.one_bg, bold = true }
end

-- add mode highlights
-- somewhat default nvchad colors
genModes_hl("Normal", "bright_blue")
genModes_hl("Visual", "cyan")
genModes_hl("Insert", "magenta")
genModes_hl("Terminal", "green")
genModes_hl("NTerminal", "green")
genModes_hl("Replace", "bright_red")
genModes_hl("Confirm", "bright_magenta")
genModes_hl("Command", "green")
genModes_hl("Select", "blue")

-- add common lsp highlights
M.default = vim.tbl_extend("force", M.default, lsp_highlights)
M.vscode_colored = vim.tbl_extend("force", M.vscode_colored, lsp_highlights)

-- add block highlights for minimal theme
local function gen_hl(name, col)
  M.minimal["St_" .. name .. "_bg"] = {
    fg = colors.black,
    bg = colors[col],
  }

  M.minimal["St_" .. name .. "_txt"] = {
    fg = colors[col],
    bg = colors.one_bg,
  }

  M.minimal["St_" .. name .. "_sep"] = {
    fg = colors[col],
    bg = colors.black,
  }
end

gen_hl("file", "red")
gen_hl("Pos", "yellow")
gen_hl("cwd", "bright_yellow")
gen_hl("lsp", "green")

return M
