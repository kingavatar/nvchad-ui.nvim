local M = {}

local utils = require "nvchad_ui.colors.utils"
local use_lualine = require("nvchad_ui.config").options.statusline.lualine

---@param theme statusline_theme
M.apply_highlights = function(theme)
  local lualineColors = utils.get_lualine_colors()
  local next = next
  M.can_use_lualine = use_lualine and next(lualineColors) ~= nil
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

  colors.orange = utils.getOrangeColor(colors.red, colors.yellow)
  colors.bright_orange = utils.getOrangeColor(colors.bright_red, colors.bright_yellow)

  if use_lualine and next(lualineColors) ~= nil then
    colors.statusline_bg = lualineColors.normal.c.bg
    colors.light_bg = lualineColors.normal.b.bg
    -- colors.light_grey = lualineColors.normal.b.bg
  end

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
      fg = colors.white,
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
      fg = colors.white,
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
      fg = colors.bright_orange,
      bg = colors.statusline_bg,
    },

    St_ft = {
      fg = colors.blue,
      bg = colors.statusline_bg,
    },
  }

  local lualineMode = {
    Normal = "normal",
    Visual = "visual",
    Insert = "insert",
    Replace = "replace",
    Command = "command",
    Select = "visual",
    Terminal = "command",
    NTerminal = "command",
    Confirm = "command",
  }

  local lualine_highlights = {
    _normal = "normal",
    _insert = "insert",
    _replace = "replace",
    _visual = "visual",
    _command = "command",
    _terminal = "inactive",
  }

  ---Add lualine highlights to elements
  ---@param lualine_config Add_Lualine_Config
  local add_lualine_highlights = function(lualine_config)
    for hl, mod in pairs(lualine_highlights) do
      ---@type string | table
      local final_fg = ""
      ---@type string | table
      local final_bg = ""
      if lualine_config.fg_section ~= nil then
        ---@type string
        final_fg = lualineColors[mod][lualine_config.fg_section][lualine_config.fg_mode]
      elseif lualine_config.fg_col ~= nil then
        final_fg = lualine_config.fg_col
      end
      if lualine_config.bg_section ~= nil then
        ---@type string
        final_bg = lualineColors[mod][lualine_config.bg_section][lualine_config.bg_mode]
      elseif lualine_config.bg_col ~= nil then
        final_bg = lualine_config.bg_col
      end
      ---@diagnostic disable-next-line: no-unknown
      M[lualine_config.theme][lualine_config.mode .. hl] = { fg = final_fg, bg = final_bg }
    end
  end

  -- Using lualine Colors
  local use_lualine_highlights = function(para_theme)
    if para_theme == "minimal" then
      -- Minimal right seperator color
      add_lualine_highlights {
        theme = "minimal",
        mode = "St_sep_r",
        fg_section = "b",
        fg_mode = "bg",
        bg_col = colors.black,
      }
    elseif para_theme == "default" then
      -- Defualt B section
      add_lualine_highlights {
        theme = "default",
        mode = "St_EmptySpace",
        fg_col = utils.extract_highlight_colors("NonText", "fg"),
        bg_section = "b",
        bg_mode = "bg",
      }

      add_lualine_highlights {
        theme = "default",
        mode = "St_file_info",
        fg_section = "b",
        fg_mode = "fg",
        bg_section = "b",
        bg_mode = "bg",
      }

      add_lualine_highlights {
        theme = "default",
        mode = "St_file_sep",
        fg_section = "b",
        fg_mode = "bg",
        bg_section = "c",
        bg_mode = "bg",
      }

      --- Default C section

      add_lualine_highlights {
        theme = "default",
        mode = "St_gitIcons",
        fg_section = "c",
        fg_mode = "fg",
        bg_section = "c",
        bg_mode = "bg",
      }

      --- Default X Y Z
      add_lualine_highlights {
        theme = "default",
        mode = "St_LspStatus",
        fg_section = "a",
        fg_mode = "bg",
        bg_section = "c",
        bg_mode = "bg",
      }

      add_lualine_highlights {
        theme = "default",
        mode = "St_cwd_icon",
        fg_section = "b",
        fg_mode = "fg",
        bg_section = "b",
        bg_mode = "bg",
        -- bg_col = colors.bright_red,
      }
      add_lualine_highlights {
        theme = "default",
        mode = "St_cwd_text",
        fg_section = "b",
        fg_mode = "fg",
        bg_section = "b",
        bg_mode = "bg",
      }
      add_lualine_highlights {
        theme = "default",
        mode = "St_cwd_sep",
        fg_section = "b",
        fg_mode = "bg",
        -- fg_col = colors.bright_red,
        bg_section = "c",
        bg_mode = "bg",
      }
      add_lualine_highlights {
        theme = "default",
        mode = "St_pos_sep",
        fg_section = "a",
        fg_mode = "bg",
        bg_section = "b",
        bg_mode = "bg",
      }
      add_lualine_highlights {
        theme = "default",
        mode = "St_pos_icon",
        fg_section = "c",
        fg_mode = "bg",
        bg_section = "a",
        bg_mode = "bg",
      }
      add_lualine_highlights {
        theme = "default",
        mode = "St_pos_text",
        fg_section = "a",
        fg_mode = "bg",
        bg_section = "b",
        bg_mode = "bg",
      }
    end
  end

  ---@source https://github.com/NvChad/base46/blob/v2.0/lua/base46/integrations/statusline.lua#L267

  ---@param modename string
  ---@param col string
  local function genModes_hl(modename, col)
    M.default["St_" .. modename .. "Mode"] = { fg = colors.black, bg = colors[col], bold = true }
    M.default["St_" .. modename .. "ModeSep"] = { fg = colors[col], bg = utils.extract_highlight_colors("NonText", "fg") }
    M.vscode_colored["St_" .. modename .. "Mode"] = { fg = colors[col], bg = colors.one_bg3, bold = true }

    M.minimal["St_" .. modename .. "Mode"] = { fg = colors.black, bg = colors[col], bold = true }
    M.minimal["St_" .. modename .. "ModeSep"] = { fg = colors[col], bg = colors.black, bold = true }
    M.minimal["St_" .. modename .. "modeText"] = { fg = colors[col], bg = colors.one_bg, bold = true }
    if next(lualineColors) ~= nil and use_lualine then
      M.default["St_" .. modename .. "Mode"] =
        { fg = lualineColors[lualineMode[modename]].a.fg, bg = lualineColors[lualineMode[modename]].a.bg, bold = true }
      M.default["St_" .. modename .. "ModeSep"] =
        { fg = lualineColors[lualineMode[modename]].a.bg, bg = utils.extract_highlight_colors("NonText", "fg") }
      M.vscode_colored["St_" .. modename .. "Mode"] =
        { fg = lualineColors[lualineMode[modename]].a.bg, bg = lualineColors[lualineMode[modename]].b.bg, bold = true }

      M.minimal["St_" .. modename .. "Mode"] = { fg = colors.black, bg = lualineColors[lualineMode[modename]].a.bg, bold = true }
      M.minimal["St_" .. modename .. "ModeSep"] =
        { fg = lualineColors[lualineMode[modename]].a.bg, bg = colors.black, bold = true }
      M.minimal["St_" .. modename .. "modeText"] =
        { fg = lualineColors[lualineMode[modename]].a.bg, bg = lualineColors[lualineMode[modename]].b.bg, bold = true }
    end
  end

  -- add mode highlights
  -- somewhat default nvchad colors
  genModes_hl("Normal", "bright_blue")
  genModes_hl("Visual", "cyan")
  genModes_hl("Insert", "magenta")
  genModes_hl("Terminal", "green")
  genModes_hl("NTerminal", "green")
  genModes_hl("Replace", "bright_orange")
  genModes_hl("Confirm", "bright_magenta")
  genModes_hl("Command", "green")
  genModes_hl("Select", "blue")

  -- add common lsp highlights
  M.default = vim.tbl_extend("force", M.default, lsp_highlights)
  M.vscode_colored = vim.tbl_extend("force", M.vscode_colored, lsp_highlights)

  --- add block highlights for minimal theme
  ---@param name string
  ---@param col string
  ---@param section? string
  local function gen_hl(name, col, section)
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
    if next(lualineColors) ~= nil and use_lualine and section ~= nil then
      add_lualine_highlights {
        theme = "minimal",
        mode = "St_" .. name .. "_bg",
        fg_section = nil,
        bg_section = section,
        bg_mode = "bg",
        fg_col = colors.black,
        bg_col = nil,
      }

      add_lualine_highlights {
        theme = "minimal",
        mode = "St_" .. name .. "_txt",
        fg_section = section,
        fg_mode = "bg",
        -- bg_section = nil,
        bg_section = "b",
        bg_mode = "bg",
        fg_col = nil,
        -- bg_col = colors.one_bg,
      }

      add_lualine_highlights {
        theme = "minimal",
        mode = "St_" .. name .. "_sep",
        fg_section = section,
        fg_mode = "bg",
        bg_section = nil,
        fg_col = nil,
        bg_col = colors.black,
      }
    end
  end

  gen_hl("file", "red")
  gen_hl("Pos", "bright_yellow", "a")
  gen_hl("cwd", "bright_orange")
  gen_hl("lsp", "green", "a")

  if M.can_use_lualine then use_lualine_highlights(theme) end
end

return M
