# NvChad's UI plugin

## Disclaimer ⚠️

I've created a personalized fork of the original Nvchad UI Plugin that has been heavily modified to complement
lazyvim with Nvchad's sleek aesthetic. By combining the best of both worlds, I've added extra functionality
and mappings from lazyvim. If you're new to this, we highly recommend checking out the default
[Nvchad](https://nvchad.com/) framework, which is the most efficient and effective option. I've made sure to
incorporate all encountered bug fixes into the default framework, ensuring a seamless experience for all
users. For those already using lazyvim, this plugin allows you to incorporate Nvchad UI components while
retaining your preferred lazyvim settings and mappings.

This Lightweight &amp; performant UI plugin provides the following components:

- Statusline with 4 theme styles and also with support for using lualine theme from colorscheme
  - `default` theme with four separators (`default`, `round`, `arrow`, `block`)
    ![default](https://user-images.githubusercontent.com/31726036/229489465-5697134e-8b8c-4ef1-80a5-7ab06084b19a.png)
    ![default round](https://user-images.githubusercontent.com/31726036/229487976-746d8fa7-27e4-4f77-9e14-e7627feae525.png)
    ![default arrow](https://user-images.githubusercontent.com/31726036/229490074-ff29ffb8-5349-47ae-9494-d938082dcf30.png)
    ![default block](https://user-images.githubusercontent.com/31726036/229490321-18aa0c8a-60c6-470c-80e3-78b9eb060e56.png)
  - `minimal` theme with two separators (`round`, `block`)
    ![minimal](https://user-images.githubusercontent.com/31726036/229490947-a0bae908-6a31-4cd2-957a-619d041a827d.png)
    ![minimal block](https://user-images.githubusercontent.com/31726036/229490636-65b34674-d8ad-4544-a014-3ded7bab4529.png)
  - `vscode_colored` theme
    ![vscode_colored](https://user-images.githubusercontent.com/31726036/229554767-d2f28b6d-dd73-4a3a-9343-ccaef26b09af.png)
  - `vscode` theme
    ![vscode](https://user-images.githubusercontent.com/31726036/229555330-be010f01-0ee8-48b6-99ad-cc15e2125014.png)
  - without lualine using standard colors
    ![default round without lualine](https://user-images.githubusercontent.com/31726036/229488744-4b30b33d-728b-4e5e-a7d1-f5bb4ccab1ec.png)
    ![minimal without lualine](https://user-images.githubusercontent.com/31726036/229491247-06bb67e6-a6ff-4f5c-bd85-0eccc90b8d93.png)

- Tabufline ( manages buffers per tab ) The color shades are implemented using color management from
  [bufferline](https://github.com/akinsho/bufferline.nvim) plugin
  ![tabufline](https://user-images.githubusercontent.com/31726036/229492669-eb7a96cc-dd5f-4cdf-b0d8-6a7cc7624b65.png)
  ![toggle_theme](https://user-images.githubusercontent.com/31726036/229622835-500092a9-f03b-4981-b5c8-3059f7c75883.gif)
- NvDash ( dashboard )
  ![dashboard with drops](https://user-images.githubusercontent.com/31726036/229481566-b229d4b5-45a3-4baf-abab-92e1548a7d1e.png)
- NvCheatsheet ( auto-generates cheatsheet based on default & user mappings in nice grid (Masonry layout) /
  column layout )
  ![nvcheatsheet](https://user-images.githubusercontent.com/31726036/229493173-19018616-b684-4c81-84c9-23793bfc7d69.png)
  ![nvcheatsheet simple](https://user-images.githubusercontent.com/31726036/229493470-2173150d-4feb-479b-8d92-4d2482f4d148.png)
- basic Lsp signature

  I haven't personally tested this as lazyvim already has lsp signature, but it should work the same.
  ![lsp signature](https://user-images.githubusercontent.com/31726036/229497297-11be60ce-2996-4663-a82a-8303cc31c5f9.png)
- Lsp renamer window

  I've incorporated additional functionality for Incremental LSP renaming based on the inc-rename.nvim plugin.
  This feature provides an advantage over the [inc-rename](https://github.com/smjonas/inc-rename.nvim) plugin,
  which relies on the command line for user input instead of the pop-up window used by this renamer. The
  window used by the nvchad renamer allows me to observe the cursor's movement from left to right, enhancing
  the overall user experience.
  ![inc_rename](https://user-images.githubusercontent.com/31726036/229500704-3e7f898d-a9f7-462b-9d94-25642882aac3.gif)

## Setup

For LazyVim users:

```lua
{ "nvim-lualine/lualine.nvim", enabled = false },
{ "akinsho/bufferline.nvim", enabled = false },
{ "goolord/alpha-nvim", enabled = false },
{
  "lukas-reineke/indent-blankline.nvim",
  opts = function(_, opts)
    opts.filetype_exclude = vim.tbl_extend("force", opts.filetype_exclude, { "nvdash", "nvcheatsheet" })
  end,
},
{
  "echasnovski/mini.indentscope",
  init = function()
    vim.api.nvim_create_autocmd("FileType", {
      pattern = { "help", "alpha", "dashboard", "neo-tree", "Trouble", "lazy", "mason", "nvdash", "nvcheatsheet" },
      callback = function()
        vim.b.miniindentscope_disable = true
      end,
    })
end,
},
{
  "kingavatar/nvchad-ui.nvim",
  branch = "v2.0",
  lazy = false,
  config = function()
    require("nvchad_ui").setup({
      lazyVim = true,
      statusline = { separator_style = "default", theme = "default", lualine = true },
      theme_toggle = { "tokyonight", "rose-pine" },
      nvdash = { load_on_startup = true },
  })

  -- rename nvchad
  vim.keymap.set("n", "<leader>cn", require("nvchad_ui.renamer").open, { desc = "nvchad Rename" })
  end,
},
```

In the above setup, we've configured the nvchad_ui to include statusline, tabufline, and nvdash components,
which means we need to disable the default lualine, bufferline, and alpha plugins. Additionally, we've
excluded the indent blank lines for the nvdash dashboard and nvcheatsheet file types. We've also set the theme
toggle option to switch between the `tokyonight` and `rose-pine` themes.

If you prefer not to use any UI component, simply set the enabled option to false for the respective
component. For the nvdash component, you can set `load_on_startup` to `false` if you prefer not to load it
during startup.

```lua
require("nvchad_ui").setup({
    lazyVim = true,
    statusline = {enabled = false},
    tabufline = {enabled = false},
    nvdash = {load_on_startup = false},
    lsp = {signature = {enabled = false}}
  })
```

### Default config

The Default config for the plugin if used as a standalone plugin

```lua
{
  lazyVim = false, -- set it true if using LazyVim
  statusline = { --  NvChad UI statusline options
    enabled = true,  -- enable or disable statusline
    theme = "default",   --  Set theme for statusline
    -- Seperators :
    --  - default : "" "" Will only work for default Statusline Theme
    --  - "round" : "" "" Will only work for default and minimal Statusline Theme
    --  - "block" : "█" "█" Will only work for default and minimal Statusline Theme
    --  - "arrow" : "" "" Will only work for default Statusline Theme
    separator_style = "default",  -- "default" | "minimal" | "vscode" | "vscode_colored"
    overriden_modules = nil,  -- ?table  override statusline modules
    lualine = false,  -- set it true if you want to use theme's lualine highlights 
                      -- works only for default and minimal
  },
  tabufline = {
    enabled = true, -- enable or disable tabufline
    lazyload = true, 
    overriden_modules = nil, -- ?table  override tabufline modules
  },
  theme_toggle = nil,  -- {[1]: string , [2]: string} Mention themes for theme_toggle to 
                       -- toggle between
  nvdash = {
    load_on_startup = false,   -- enable or disable loading on startup
    header = {  -- dashboard header
      "                              ",
      " ███ █     ████▄ ▄▄▄ ▄▄▄ █    ",
      " █ █ █ █ █ ██ ██ █ ▄ █▄▄ ███  ",
      " █ ███   ███  █  ▄▄█ █ █  ",
      "                              ",
    },
    buttons = {}, -- dashboard buttons
  },
  cheatsheet = "grid", -- NvCheatsheet has 2 themes ( grid & simple ) default option : grid
  lsp = { -- silences 'no signature help available' message from appearing
    signature = {
      enabled = false,  --  enable or disable nvchad lsp function signature. 
                        -- default option : false
      silent = true, -- silences 'no signature help available' message from appearing
    },
  },
  mappings = {}, -- table containing mappings, have to set it if plugin is installed as 
                 -- standalone for nvcheatsheet to work
}
```

Enabling `lazyVim = true` modifies the default options as follows:

```lua
{
  theme_toggle =  { "tokyonight-day", "tokyonight" },
  nvdash = {
    buttons = {
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
  },
  mappings = require "nvchad_ui.cheatsheet.lazyvim"
}

-- This keymap is also set which should also be setup if plugin is installed as  standalone 
vim.keymap.set("n", "<leader>ch", "<cmd> NvCheatsheet <CR>", { desc = "Mapping cheatsheet" })
```

All of the aforementioned options will be overridden by the user-defined options specified in the setup
function.

### Reset highlights

As user changes settings or themes sometimes the highlights are messed up during startup from cache or during
theme transition.

I will try to fix any such issues but for now to get correct highlights again run this function in command
line

```lua
lua require("nvchad_ui").reset()
```
