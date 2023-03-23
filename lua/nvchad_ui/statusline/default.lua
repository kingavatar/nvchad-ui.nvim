local fn = vim.fn
local options = require("nvchad_ui.config").options.statusline
local sep_style = options.separator_style
local use_lualine = options.lualine

local default_sep_icons = {
  default = { left = "", right = " " },
  round = { left = "", right = "" },
  block = { left = "█", right = "█" },
  arrow = { left = "", right = "" },
}

local separators = (type(sep_style) == "table" and sep_style) or default_sep_icons[sep_style]

local sep_l = separators["left"]
local sep_r = separators["right"]

local M = {}

M.modes = {
  ["n"] = { "NORMAL", "St_NormalMode", "_normal" },
  ["niI"] = { "NORMAL i", "St_NormalMode", "_normal" },
  ["niR"] = { "NORMAL r", "St_NormalMode", "_normal" },
  ["niV"] = { "NORMAL v", "St_NormalMode", "_normal" },
  ["no"] = { "N-PENDING", "St_NormalMode", "_normal" },
  ["i"] = { "INSERT", "St_InsertMode", "_insert" },
  ["ic"] = { "INSERT (completion)", "St_InsertMode", "_insert" },
  ["ix"] = { "INSERT completion", "St_InsertMode", "_insert" },
  ["t"] = { "TERMINAL", "St_TerminalMode", "_terminal" },
  ["nt"] = { "NTERMINAL", "St_NTerminalMode", "_terminal" },
  ["v"] = { "VISUAL", "St_VisualMode", "_visual" },
  ["V"] = { "V-LINE", "St_VisualMode", "_visual" },
  ["Vs"] = { "V-LINE (Ctrl O)", "St_VisualMode", "_visual" },
  [""] = { "V-BLOCK", "St_VisualMode", "_visual" },
  ["R"] = { "REPLACE", "St_ReplaceMode", "_replace" },
  ["Rv"] = { "V-REPLACE", "St_ReplaceMode", "_replace" },
  ["s"] = { "SELECT", "St_SelectMode", "_replace" },
  ["S"] = { "S-LINE", "St_SelectMode", "_replace" },
  [""] = { "S-BLOCK", "St_SelectMode", "_replace" },
  ["c"] = { "COMMAND", "St_CommandMode", "_command" },
  ["cv"] = { "COMMAND", "St_CommandMode", "_command" },
  ["ce"] = { "COMMAND", "St_CommandMode", "_command" },
  ["r"] = { "PROMPT", "St_ConfirmMode", "_command" },
  ["rm"] = { "MORE", "St_ConfirmMode", "_command" },
  ["r?"] = { "CONFIRM", "St_ConfirmMode", "_command" },
  ["x"] = { "CONFIRM", "St_ConfirmMode", "_command" },
  ["!"] = { "SHELL", "St_TerminalMode", "_terminal" },
}

---@param mode string
M.mode = function(mode)
  local current_mode = "%#" .. M.modes[mode][2] .. "#" .. "  " .. M.modes[mode][1]
  local mode_sep1 = "%#" .. M.modes[mode][2] .. "Sep" .. "#" .. sep_r

  if use_lualine then
    return current_mode .. mode_sep1 .. "%#ST_EmptySpace" .. M.modes[mode][3] .. "#" .. sep_r
  end

  return current_mode .. mode_sep1 .. "%#ST_EmptySpace#" .. sep_r
end

---@param mode string
M.fileInfo = function(mode)
  local icon = "  "
  local filename = (fn.expand "%" == "" and "Empty ") or fn.expand "%:t"

  if filename ~= "Empty " then
    ---@type boolean ,{get_icon: fun(string) : string}
    local devicons_present, devicons = pcall(require, "nvim-web-devicons")

    if devicons_present then
      ---@type string?
      local ft_icon = devicons.get_icon(filename)
      icon = (ft_icon ~= nil and " " .. ft_icon) or ""
    end

    filename = " " .. filename .. " "
  end

  if use_lualine then
    return "%#St_file_info"
      .. M.modes[mode][3]
      .. "#"
      .. icon
      .. filename
      .. "%#St_file_sep"
      .. M.modes[mode][3]
      .. "#"
      .. sep_r
  end

  return "%#St_file_info#" .. icon .. filename .. "%#St_file_sep#" .. sep_r
end

---@param mode string
M.git = function(mode)
  ---@diagnostic disable-next-line: undefined-field
  if not vim.b.gitsigns_head or vim.b.gitsigns_git_status then
    return ""
  end

  ---@type { added: integer , changed: integer , head: integer , removed: integer  }
  ---@diagnostic disable-next-line: undefined-field
  local git_status = vim.b.gitsigns_status_dict

  local added = (git_status.added and git_status.added ~= 0) and ("  " .. git_status.added) or ""
  local changed = (git_status.changed and git_status.changed ~= 0) and ("  " .. git_status.changed) or ""
  local removed = (git_status.removed and git_status.removed ~= 0) and ("  " .. git_status.removed) or ""
  local branch_name = "  " .. git_status.head

  if use_lualine then
    return "%#St_gitIcons" .. M.modes[mode][3] .. "#" .. branch_name .. added .. changed .. removed
  end
  return "%#St_gitIcons#" .. branch_name .. added .. changed .. removed
end

-- LSP STUFF
M.LSP_progress = function()
  if not rawget(vim, "lsp") then
    return ""
  end

  ---@type { message: string, percentage: integer, title: string }
  local Lsp = vim.lsp.util.get_progress_messages()[1]

  if vim.o.columns < 120 or not Lsp then
    return ""
  end

  local msg = Lsp.message or ""
  local percentage = Lsp.percentage or 0
  local title = Lsp.title or ""
  local spinners = { "", "󰪞", "󰪟", "󰪠", "󰪢", "󰪣", "󰪤", "󰪥" }
  local ms = vim.loop.hrtime() / 1000000
  local frame = math.floor(ms / 120) % #spinners
  local content = string.format(" %%<%s %s %s (%s%%%%) ", spinners[frame + 1], title, msg, percentage)

  if config.lsprogress_len then
    content = string.sub(content, 1, config.lsprogress_len)
  end

  return ("%#St_LspProgress#" .. content) or ""
end

M.LSP_Diagnostics = function()
  if not rawget(vim, "lsp") then
    return ""
  end

  ---@type integer | string
  local errors = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
  ---@type integer | string
  local warnings = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })
  ---@type integer | string
  local hints = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.HINT })
  ---@type integer | string
  local info = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.INFO })

  errors = (errors and errors > 0) and ("%#St_lspError#" .. " " .. errors .. " ") or ""
  warnings = (warnings and warnings > 0) and ("%#St_lspWarning#" .. "  " .. warnings .. " ") or ""
  hints = (hints and hints > 0) and ("%#St_lspHints#" .. "ﯧ " .. hints .. " ") or ""
  info = (info and info > 0) and ("%#St_lspInfo#" .. " " .. info .. " ") or ""

  return errors .. warnings .. hints .. info
end

---@param mode string
M.LSP_status = function(mode)
  if rawget(vim, "lsp") then
    ---@diagnostic disable-next-line: no-unknown
    for _, client in ipairs(vim.lsp.get_active_clients()) do
      if client.attached_buffers[vim.api.nvim_get_current_buf()] then
        if use_lualine then
          return (
            vim.o.columns > 100
            and "%#St_LspStatus" .. M.modes[mode][3] .. "#" .. "   LSP ~ " .. client.name .. " "
          ) or "   LSP "
        end
        return (vim.o.columns > 100 and "%#St_LspStatus#" .. "   LSP ~ " .. client.name .. " ") or "   LSP "
      end
    end
  end
end

---@param mode string
M.cwd = function(mode)
  local dir_icon = "%#St_cwd_icon#" .. " "
  local dir_name = "%#St_cwd_text#" .. " " .. fn.fnamemodify(fn.getcwd(), ":t") .. " "

  if use_lualine then
    dir_icon = "%#St_cwd_icon" .. M.modes[mode][3] .. "#" .. " "
    dir_name = "%#St_cwd_text" .. M.modes[mode][3] .. "#" .. " " .. fn.fnamemodify(fn.getcwd(), ":t") .. " "

    return (vim.o.columns > 85 and ("%#St_cwd_sep" .. M.modes[mode][3] .. "#" .. sep_l .. dir_icon .. dir_name)) or ""
  end

  return (vim.o.columns > 85 and ("%#St_cwd_sep#" .. sep_l .. dir_icon .. dir_name)) or ""
end

---@param mode string
M.cursor_position = function(mode)
  local left_sep = "%#St_pos_sep#" .. sep_l .. "%#St_pos_icon#" .. " "

  local current_line = fn.line "."
  local total_line = fn.line "$"
  local text = math.modf((current_line / total_line) * 100) .. tostring "%%"
  text = string.format("%4s", text)

  text = (current_line == 1 and "Top") or text
  text = (current_line == total_line and "Bot") or text

  if use_lualine then
    left_sep = "%#St_pos_sep"
      .. M.modes[mode][3]
      .. "#"
      .. sep_l
      .. "%#St_pos_icon"
      .. M.modes[mode][3]
      .. "#"
      .. " "

    return left_sep .. "%#St_pos_text" .. M.modes[mode][3] .. "#" .. " " .. text .. " "
  end

  return left_sep .. "%#St_pos_text#" .. " " .. text .. " "
end

M.run = function()
  ---@type table
  local modules = require "nvchad_ui.statusline.default"

  if options.overriden_modules then
    modules = vim.tbl_deep_extend("force", modules, options.overriden_modules())
  end

  ---@type string
  local m = vim.api.nvim_get_mode().mode

  return table.concat {
    modules.mode(m),
    modules.fileInfo(m),
    modules.git(m),

    "%=",
    modules.LSP_progress(),
    "%=",

    modules.LSP_Diagnostics(),
    modules.LSP_status(m) or "",
    modules.cwd(m),
    modules.cursor_position(m),
  }
end

return M
