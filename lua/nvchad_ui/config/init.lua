---@type NvChadUIConfig
local M = {}

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
M.defaults = {
  statusline = {
    style = "default",
    separator_style = "default",
    overriden_modules = nil,
  },
  tabufline = {
    enabled = true,
    lazyload = true,
    overriden_modules = nil,
  },
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
}

---@type NvChadUIConfig
M.options = {}

--- function to Setup NvChad UI Elements
---@param opts ?NvChadUIConfig Use the default Config or user given config
function M.setup(opts)
  M.options = vim.tbl_deep_extend("force", M.defaults, opts or {})

  local new_cmd = vim.api.nvim_create_user_command

  vim.opt.statusline = "%!v:lua.require('nvchad_ui.statusline." .. M.options.statusline .. "').run()"

  if M.options.tabufline.enabled then
    require "nvchad_ui.tabufline.lazyload"
  end

  -- Command to toggle NvDash
  new_cmd("Nvdash", function()
    if vim.g.nvdash_displayed then
      vim.cmd "bd"
    else
      require("nvchad_ui.nvdash").open(vim.api.nvim_create_buf(false, true))
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
  vim.api.nvim_create_autocmd("VimResized", {
    callback = function()
      if vim.bo.filetype == "nvdash" then
        vim.opt_local.modifiable = true
        vim.api.nvim_buf_set_lines(0, 0, -1, false, { "" })
        require("nvchad_ui.nvdash").open()
      elseif vim.bo.filetype == "nvcheatsheet" then
        vim.opt_local.modifiable = true
        vim.api.nvim_buf_set_lines(0, 0, -1, false, { "" })
        require("nvchad_ui.cheatsheet." .. M.options.cheatsheet)()
      end
    end,
  })
end

return M
