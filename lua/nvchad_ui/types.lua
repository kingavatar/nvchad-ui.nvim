---@meta

--- NvChad statusline options
--- Hover on individual properties for more details
---@class NvChadStatusline
--- Set theme for statusline
--- Some seperators are present only default and minimal style
---@field theme "default"| "minimal" | "vscode" | "vscode_colored"
--- Seperators :
---  - default : "" "" Will only work for default Statusline Theme
---  - "round" : "" "" Will only work for default and minimal Statusline Theme
---  - "block" : "█" "█" Will only work for default and minimal Statusline Theme
---  - "arrow" : "" "" Will only work for default Statusline Theme
---@field separator_style "default" | "round" | "block"  | "arrow"
---@field overriden_modules ?table  override statusline modules

--- NvChad tabufline options
--- Hover on individual properties for more details
---@class NvChadTabufline
---@field enabled boolean enable or disable tabufline
---@field lazyload boolean
---@field overriden_modules ?table  override tabufline modules

--- NvChad NvDash dashboard options
--- Hover on individual properties for more details
---@class NvDashConfig
---@field load_on_startup boolean enable or disable loading on startup
---@field header string[] dashboard header
---@field buttons NvChadButton[] dashboard buttons

---@alias NvChadButton string[3] NvChad dashboard button

--- NvChad Lsp function signature options
--- Hover on individual properties for more details
---@class NvChadLsp
---@field signature NvChadLspSignature

--- show function signatures i.e args as you type
--- Hover on individual properties for more details
---@class NvChadLspSignature
---@field enabled boolean enable or disable nvchad lsp function signature. default option : false
---@field silent boolean silences 'no signature help available' message from appearing
