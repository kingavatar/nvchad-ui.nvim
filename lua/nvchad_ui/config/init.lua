---@type NvChadUIConfig
local M = {}

local api = vim.api

--- NvChad UI options
--- Hover on individual properties for more details
--- defaultly disabling nvdash and lsp function signatures
---@class NvChadUIConfig
---@field statusline NvChadStatusline
---@field tabufline NvChadTabufline
---@field nvdash NvDashConfig
---NvCheatsheet has 2 themes ( grid & simple ) default option : grid
---@field cheatsheet "grid" | "simple"
---@field lsp NvChadLsp
---@field lazyVim boolean set it true if using LazyVim
---@field theme_toggle? {[1]: string , [2]: string} Mention themes for theme_toggle to toggle between
M.defaults = {
  statusline = {
    theme = "default",
    separator_style = "default",
    overriden_modules = nil,
    lualine = false,
  },
  tabufline = {
    enabled = true,
    lazyload = true,
    overriden_modules = nil,
  },
  theme_toggle = nil,
  nvdash = {
    load_on_startup = false,
  },
  cheatsheet = "grid",
  lsp = {
    signature = {
      enabled = false,
      silent = true,
    },
  },
  lazyVim = false,
}

---@type NvChadUIConfig
M.options = {}

--- function to Setup NvChad UI Elements
---@param opts? NvChadUIConfig Use the default Config or user given config
function M.setup(opts)
  M.options = vim.tbl_deep_extend("force", M.defaults, opts or {})
  local new_cmd = api.nvim_create_user_command
  api.nvim_create_augroup("nvchad_ui", {})
  local colors = require "nvchad_ui.colors"
  colors.load_all_highlights()

  --- Auto refresh highlights on colorscheme change
  api.nvim_create_autocmd("ColorScheme", {
    group = "nvchad_ui",
    callback = colors.load_all_highlights,
  })

  vim.opt.statusline = "%!v:lua.require('nvchad_ui.statusline." .. M.options.statusline.theme .. "').run()"
  vim.opt.laststatus = 3
  if M.options.tabufline.enabled then
    require "nvchad_ui.tabufline.lazyload"
  end

  -- Command to toggle NvDash
  new_cmd("Nvdash", function()
    if vim.g.nvdash_displayed then
      vim.cmd "bd"
    else
      require("nvchad_ui.nvdash").open(api.nvim_create_buf(false, true))
    end
  end, {})

  -- load nvdash
  if M.options.nvdash.load_on_startup then
    vim.defer_fn(function()
      require("nvchad_ui.nvdash").open()
    end, 0)
  end

  -- command to toggle cheatsheet
  new_cmd("NvCheatsheet", function()
    vim.g.nvcheatsheet_displayed = not vim.g.nvcheatsheet_displayed

    if vim.g.nvcheatsheet_displayed then
      require("nvchad_ui.cheatsheet." .. M.options.cheatsheet)()
    else
      vim.cmd "bd"
    end
  end, {})

  -- redraw dashboard on VimResized event
  api.nvim_create_autocmd("VimResized", {
    callback = function()
      if vim.bo.filetype == "nvdash" then
        vim.opt_local.modifiable = true
        api.nvim_buf_set_lines(0, 0, -1, false, { "" })
        require("nvchad_ui.nvdash").open()
      elseif vim.bo.filetype == "nvcheatsheet" then
        vim.opt_local.modifiable = true
        api.nvim_buf_set_lines(0, 0, -1, false, { "" })
        require("nvchad_ui.cheatsheet." .. M.options.cheatsheet)()
      end
    end,
  })

  ---Set defaults for lazyVim
  if M.options.lazyVim then
    if M.options.theme_toggle == nil then
      M.options.theme_toggle = { "tokyonight-day", "tokyonight" }
    end
  end
end

return M
