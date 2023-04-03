---@type NvChadUIConfig
local M = {}

local api = vim.api
vim.g.base46_cache = vim.fn.stdpath "data" .. "/nvchad/base46/"
local callback_not_happened = true

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
---@field mappings NvChadCheatsheet
M.defaults = {
  statusline = {
    enabled = true,
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
    -- header = {},
    -- buttons = {},
    header = {
      "                              ",
      " ███ █     ████▄ ▄▄▄ ▄▄▄ █    ",
      " █ █ █ █ █ ██ ██ █ ▄ █▄▄ ███  ",
      " █ ███   ███  █  ▄▄█ █ █  ",
      "                              ",
    },

    buttons = {},
  },
  cheatsheet = "grid",
  lsp = {
    signature = {
      enabled = false,
      silent = true,
    },
  },
  lazyVim = false,
  mappings = {},
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
  --- Auto refresh highlights on colorscheme change
  api.nvim_create_autocmd("ColorScheme", {
    group = "nvchad_ui",
    callback = function()
      callback_not_happened = false
      colors.on_colorscheme_change()
    end,
  })

  if not vim.loop.fs_stat(vim.g.base46_cache) then
    vim.fn.mkdir(vim.g.base46_cache, "p")
    colors.load_all_highlights(true)
  else
    --- if colorscheme is not set before this plugin will run default previous theme
    if callback_not_happened then colors.load_on_startup() end
  end

  if M.options.statusline.enabled then
    vim.opt.statusline = "%!v:lua.require('nvchad_ui.statusline." .. M.options.statusline.theme .. "').run()"
    vim.opt.laststatus = 3
  end

  if M.options.tabufline.enabled then require "nvchad_ui.tabufline.lazyload" end

  -- Command to toggle NvDash
  new_cmd("Nvdash", function()
    if vim.g.nvdash_displayed then
      vim.cmd "bd"
    else
      require("nvchad_ui.nvdash").open(api.nvim_create_buf(false, true))
    end
  end, {})

  -- load nvdash
  local nvdash = require "nvchad_ui.nvdash"
  if M.options.nvdash.load_on_startup and not M.options.lazyVim then vim.defer_fn(nvdash.open, 0) end

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
    if M.options.theme_toggle == nil then M.options.theme_toggle = { "tokyonight-day", "tokyonight" } end

    vim.api.nvim_create_autocmd("User", {
      pattern = "LazyVimStarted",
      callback = nvdash.lazyVim_callback,
    })

    vim.keymap.set("n", "<leader>ch", "<cmd> NvCheatsheet <CR>", { desc = "Mapping cheatsheet" })

    M.options.nvdash.buttons = {
      { "  Find File", "f", "Telescope find_files" },
      { "  Recent Files", "r", "Telescope oldfiles" },
      { "  Find Word", "g", "Telescope live_grep" },
      { "  Bookmarks", "b", "Telescope marks" },
      { "  Themes", "t", "Telescope themes" },
      { "  Mappings", "m", "NvCheatsheet" },
      { "  Config", "c", "e $MYVIMRC " },
      {
        "  Restore Session",
        "s",
        function() require("persistence").load() end,
      },
      { "󰒲  Lazy", "l", "Lazy" },
      { "  Quit", "q", "qa" },
    }

    M.options.mappings = vim.tbl_deep_extend("force", require "nvchad_ui.cheatsheet.lazyvim", M.options.mappings)
  end
end

M.reset = function() require("nvchad_ui.colors").on_colorscheme_change(true) end

return M
