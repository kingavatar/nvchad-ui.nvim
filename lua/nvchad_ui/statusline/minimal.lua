local fn = vim.fn
local options = require("nvchad_ui.config").options.statusline
local sep_style = options.separator_style
local use_lualine = require("nvchad_ui.colors").can_use_lualine
local use_lazyvim = require("nvchad_ui.config").options.lazyVim

sep_style = (sep_style ~= "round" and sep_style ~= "block") and "block" or sep_style

local default_sep_icons = {
  round = { left = "", right = "" },
  block = { left = "█", right = "█" },
}

local separators = (type(sep_style) == "table" and sep_style) or default_sep_icons[sep_style]

local sep_l = separators["left"]
-- local sep_r = "%#St_sep_r#" .. separators["right"] .. " %#ST_EmptySpace#"
local lualine_hl = ""

local M = {}

local sepR = function(ll_hl)
  return "%#St_sep_r" .. ll_hl .. "#" .. separators["right"] .. " %#ST_EmptySpace#"
end

local function gen_block(icon, txt, sep_l_hlgroup, iconHl_group, txt_hl_group, ll_hl)
  return sep_l_hlgroup .. sep_l .. iconHl_group .. icon .. " " .. txt_hl_group .. " " .. txt .. sepR(ll_hl)
end

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
  return gen_block(
    "",
    M.modes[mode][1],
    "%#" .. M.modes[mode][2] .. "Sep#",
    "%#" .. M.modes[mode][2] .. "#",
    "%#" .. M.modes[mode][2] .. "Text#",
    lualine_hl
  )
end

---@param lualine_hl string
M.fileInfo = function(lualine_hl)
  local icon = ""
  local filename = (fn.expand "%" == "" and "Empty") or fn.expand "%:t"

  if filename ~= "Empty" then
    ---@type boolean ,{get_icon: fun(string) : string}
    local devicons_present, devicons = pcall(require, "nvim-web-devicons")

    if devicons_present then
      ---@type string?
      local ft_icon = devicons.get_icon(filename)
      icon = (ft_icon ~= nil and ft_icon) or icon
    end
  end

  return gen_block(icon, filename, "%#St_file_sep#", "%#St_file_bg#", "%#St_file_txt#", "")
end

M.git = function()
  ---@diagnostic disable-next-line: undefined-field
  if not vim.b.gitsigns_head or vim.b.gitsigns_git_status then
    return ""
  end

  ---@type { added: integer , changed: integer , head: integer , removed: integer  }
  ---@diagnostic disable-next-line: undefined-field
  local git_status = vim.b.gitsigns_status_dict

  local added = (git_status.added and git_status.added ~= 0) and ("  " .. git_status.added) or ""
  local changed = (git_status.changed and git_status.changed ~= 0) and ("  " .. git_status.changed) or ""
  local removed = (git_status.removed and git_status.removed ~= 0) and ("  " .. git_status.removed) or ""
  local branch_name = " " .. git_status.head

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

M.noice = function()
  local noice_status = "%#St_lspInfo#"
  if package.loaded["noice"] and require("noice").api.status.command.has() then
    noice_status = noice_status .. require("noice").api.status.command.get() .. " "
  end
  if package.loaded["noice"] and require("noice").api.status.mode.has() then
    noice_status = noice_status .. require("noice").api.status.mode.get() .. " "
  end

  return noice_status
end

M.lazy_updates = function()
  if require("lazy.status").has_updates() then
    ---@type {updated: string[]}
    local Checker = require "lazy.manage.checker"
    local updates = #Checker.updated
    return gen_block(
      require("lazy.core.config").options.ui.icons.plugin:sub(1, -2), -- better whitespace removal :gsub("%s+", ""),
      tostring(updates),
      "%#St_lsp_sep" .. lualine_hl .. "#",
      "%#St_lsp_bg" .. lualine_hl .. "#",
      "%#St_lsp_txt" .. lualine_hl .. "#",
      lualine_hl
    )
  end
  return ""
end

M.LSP_status = function()
  if rawget(vim, "lsp") then
    ---@diagnostic disable-next-line: no-unknown
    for _, client in ipairs(vim.lsp.get_active_clients()) do
      if client.attached_buffers[vim.api.nvim_get_current_buf()] then
        return (
          vim.o.columns > 100
          and gen_block(
            "",
            client.name,
            "%#St_lsp_sep" .. lualine_hl .. "#",
            "%#St_lsp_bg" .. lualine_hl .. "#",
            "%#St_lsp_txt" .. lualine_hl .. "#",
            lualine_hl
          )
        ) or "  LSP "
      end
    end
  end
end

---@param lualine_hl string
M.cwd = function(lualine_hl)
  return (
    vim.o.columns > 85
    and gen_block("", fn.fnamemodify(fn.getcwd(), ":t"), "%#St_cwd_sep#", "%#St_cwd_bg#", "%#St_cwd_txt#", "")
  ) or ""
end

M.pos = function()
  return gen_block(
    "",
    "%l/%c",
    "%#St_Pos_sep" .. lualine_hl .. "#",
    "%#St_Pos_bg" .. lualine_hl .. "#",
    "%#St_Pos_txt" .. lualine_hl .. "#",
    lualine_hl
  )
end

M.cursor_position = function() end

M.run = function()
  ---@type table
  local modules = require "nvchad_ui.statusline.minimal"

  if options.overriden_modules then
    modules = vim.tbl_deep_extend("force", modules, options.overriden_modules())
  end

  local m = vim.api.nvim_get_mode().mode
  lualine_hl = use_lualine() and M.modes[m][3] or ""

  return table.concat {
    modules.mode(m),
    modules.fileInfo(),
    modules.git(),

    "%=",
    not use_lazyvim and modules.LSP_progress() or "",
    "%=",

    string.upper(vim.bo.fileencoding) == "" and "" or string.upper(vim.bo.fileencoding) .. "  ",
    modules.LSP_Diagnostics(),
    use_lazyvim and modules.noice() or "",
    use_lazyvim and modules.lazy_updates() or "",
    modules.LSP_status() or "",
    modules.cwd(),
    modules.pos(),
  }
end

return M
