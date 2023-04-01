local fn = vim.fn
local options = require("nvchad_ui.config").options.statusline
local sep_style = options.separator_style
local use_lualine = require("nvchad_ui.colors").can_use_lualine
local use_lazyvim = require("nvchad_ui.config").options.lazyVim

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
M.mode = function(mode, lualine_hl)
  local current_mode = "%#" .. M.modes[mode][2] .. "#" .. "  " .. M.modes[mode][1]
  local mode_sep1 = "%#" .. M.modes[mode][2] .. "Sep" .. "#" .. sep_r

  return current_mode .. mode_sep1 .. "%#ST_EmptySpace" .. lualine_hl .. "#" .. sep_r
end

---@param lualine_hl string
M.fileInfo = function(lualine_hl)
  local icon = "  "
  local filename = (fn.expand "%" == "" and "Empty ") or fn.expand "%:t"

  if filename ~= "Empty " then
    ---@type boolean ,{get_icon: fun(string) : string?}
    local devicons_present, devicons = pcall(require, "nvim-web-devicons")

    if devicons_present then
      local ft_icon = devicons.get_icon(filename)
      icon = (ft_icon ~= nil and " " .. ft_icon) or ""
    end

    filename = " " .. filename .. " "
  end

  return "%#St_file_info" .. lualine_hl .. "#" .. icon .. filename .. "%#St_file_sep" .. lualine_hl .. "#" .. sep_r
end

---@param lualine_hl string
M.git = function(lualine_hl)
  ---@diagnostic disable-next-line: undefined-field
  if not vim.b.gitsigns_head or vim.b.gitsigns_git_status then return "" end

  ---@type { added: integer , changed: integer , head: integer , removed: integer  }
  ---@diagnostic disable-next-line: undefined-field
  local git_status = vim.b.gitsigns_status_dict

  local added = (git_status.added and git_status.added ~= 0) and ("  " .. git_status.added) or ""
  local changed = (git_status.changed and git_status.changed ~= 0) and ("  " .. git_status.changed) or ""
  local removed = (git_status.removed and git_status.removed ~= 0) and ("  " .. git_status.removed) or ""
  local branch_name = "  " .. git_status.head

  return "%#St_gitIcons" .. lualine_hl .. "#" .. branch_name .. added .. changed .. removed
end

-- LSP STUFF
M.LSP_progress = function()
  if not rawget(vim, "lsp") then return "" end

  ---@type { message: string, percentage: integer, title: string }
  local Lsp = vim.lsp.util.get_progress_messages()[1]

  if vim.o.columns < 120 or not Lsp then return "" end

  local msg = Lsp.message or ""
  local percentage = Lsp.percentage or 0
  local title = Lsp.title or ""
  local spinners = { "", "󰪞", "󰪟", "󰪠", "󰪢", "󰪣", "󰪤", "󰪥" }
  local ms = vim.loop.hrtime() / 1000000
  local frame = math.floor(ms / 120) % #spinners
  local content = string.format(" %%<%s %s %s (%s%%%%) ", spinners[frame + 1], title, msg, percentage)

  if options.lsprogress_len then content = string.sub(content, 1, options.lsprogress_len) end

  return ("%#St_LspProgress#" .. content) or ""
end

M.LSP_Diagnostics = function()
  if not rawget(vim, "lsp") then return "" end

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

--
-- {
--   function() return require("noice").api.status.command.get() end,
--   cond = function() return package.loaded["noice"] and require("noice").api.status.command.has() end,
--   color = fg("Statement")
-- },
-- -- stylua: ignore
-- {
--   function() return require("noice").api.status.mode.get() end,
--   cond = function() return package.loaded["noice"] and require("noice").api.status.mode.has() end,
--   color = fg("Constant") ,
-- },
-- { require("lazy.status").updates, cond = require("lazy.status").has_updates, color = fg("Special") },
--
M.noice_command = function()
  if package.loaded["noice"] and require("noice").api.status.command.has() then
    return "%#St_lspInfo#" .. require("noice").api.status.command.get() .. " "
  end
  return ""
end

M.noice_mode = function()
  if package.loaded["noice"] and require("noice").api.status.mode.has() then
    return "%#St_lspInfo#" .. require("noice").api.status.mode.get() .. " "
  end
  return ""
end

---@param lualine_hl string
M.lazy_updates = function(lualine_hl)
  if require("lazy.status").has_updates() then
    return "%#St_LspStatus" .. lualine_hl .. "#" .. require("lazy.status").updates()
  end
  return ""
end

---@param lualine_hl string
M.LSP_status = function(lualine_hl)
  if rawget(vim, "lsp") then
    ---@diagnostic disable-next-line: no-unknown
    for _, client in ipairs(vim.lsp.get_active_clients()) do
      if client.attached_buffers[vim.api.nvim_get_current_buf()] then
        return (vim.o.columns > 100 and "%#St_LspStatus" .. lualine_hl .. "#" .. "   LSP ~ " .. client.name .. " ")
          or "   LSP "
      end
    end
  end
end

---@param lualine_hl string
M.cwd = function(lualine_hl)
  local dir_icon = "%#St_cwd_icon" .. lualine_hl .. "#" .. " "
  local dir_name = "%#St_cwd_text" .. lualine_hl .. "#" .. " " .. fn.fnamemodify(fn.getcwd(), ":t") .. " "

  return (vim.o.columns > 85 and ("%#St_cwd_sep" .. lualine_hl .. "#" .. sep_l .. dir_icon .. dir_name)) or ""
end

---@param lualine_hl string
M.cursor_position = function(lualine_hl)
  local left_sep = "%#St_pos_sep" .. lualine_hl .. "#" .. sep_l .. "%#St_pos_icon" .. lualine_hl .. "#" .. " "

  local current_line = fn.line "."
  local total_line = fn.line "$"
  local text = math.modf((current_line / total_line) * 100) .. tostring "%%"
  text = string.format("%4s", text)

  text = (current_line == 1 and "Top") or text
  text = (current_line == total_line and "Bot") or text

  return left_sep .. "%#St_pos_text" .. lualine_hl .. "#" .. " " .. text .. " "
end

M.run = function()
  local modules = require "nvchad_ui.statusline.default" --[[@as table]]

  if options.overriden_modules then modules = vim.tbl_deep_extend("force", modules, options.overriden_modules()) end

  local m = vim.api.nvim_get_mode().mode --[[@as string]]
  local lualine_hl = use_lualine() and M.modes[m][3] or ""

  return table.concat {
    modules.mode(m, lualine_hl),
    modules.fileInfo(lualine_hl),
    modules.git(lualine_hl),
    use_lazyvim and "  " .. modules.LSP_Diagnostics() or "",

    "%=",
    not use_lazyvim and modules.LSP_progress() or "",
    "%=",

    not use_lazyvim and modules.LSP_Diagnostics() or "",
    use_lazyvim and modules.noice_command() or "",
    use_lazyvim and modules.noice_mode() or "",
    use_lazyvim and modules.lazy_updates(lualine_hl) or "",
    modules.LSP_status(lualine_hl) or "",
    modules.cwd(lualine_hl),
    modules.cursor_position(lualine_hl),
  }
end

return M
