local M = {}

--- setup the NvChad UI as a standalone plugin
---@param opts? NvChadUIConfig
function M.setup(opts) require("nvchad_ui.config").setup(opts) end

--- reset settings hash and highlights
function M.reset() require("nvchad_ui.config").reset() end

return M
