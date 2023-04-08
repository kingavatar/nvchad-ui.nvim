---@meta

---Type which provides statusline theme enum
---@alias statusline_theme "default" | "minimal" | "vscode" | "vscode_colored"

--- NvChad statusline options
--- Hover on individual properties for more details
---@class NvChadStatusline
---@field enabled boolean enable or disable statusline
--- Set theme for statusline
--- Some separators are present only default and minimal style
---@field theme statusline_theme
--- Separators :
---  - default : "" "" Will only work for default Statusline Theme
---  - "round" : "" "" Will only work for default and minimal Statusline Theme
---  - "block" : "█" "█" Will only work for default and minimal Statusline Theme
---  - "arrow" : "" "" Will only work for default Statusline Theme
---@field separator_style "default" | "round" | "block"  | "arrow"
---@field overriden_modules ?table  override statusline modules
---@field lualine boolean set it true if you want to use theme's lualine highlights works only for default and minimal
---@field lsprogress_len integer Length of Lsp Progress

--- NvChad tabufline options
--- Hover on individual properties for more details
---@class NvChadTabufline
---@field enabled boolean enable or disable tabufline
---@field lazyload boolean
---@field overriden_modules ?table  override tabufline modules
---@field show_numbers boolean enable or disable numbers

--- NvChad NvDash dashboard options
--- Hover on individual properties for more details
---@class NvDashConfig
---@field load_on_startup boolean enable or disable loading on startup
---@field header string[] dashboard header
---@field buttons table<NvChadButton> dashboard buttons

---@alias NvChadButton string[] NvChad dashboard button

---@alias NvChadCheatsheet table<string, table<NvChadModes, table<string, table<string | table>>>>>

---@alias NvChadModes string

---@alias StringFunc fun():string

--- NvChad Lsp function signature options
--- Hover on individual properties for more details
---@class NvChadLsp
---@field signature NvChadLspSignature

--- show function signatures i.e args as you type
--- Hover on individual properties for more details
---@class NvChadLspSignature
---@field enabled boolean enable or disable nvchad lsp function signature. default option : false
---@field silent boolean silences 'no signature help available' message from appearing

---@class Add_Lualine_Config
---@field theme statusline_theme
---@field mode string
---@field fg_section? string
---@field fg_mode? string
---@field bg_section? string
---@field bg_mode? string
---@field fg_col? table | string
---@field bg_col? table | string
