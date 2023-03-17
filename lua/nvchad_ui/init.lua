local M = {}

---@param opts? NvChadUIConfig
function M.setup(opts)
  require("nvchad_ui.config").setup(opts)
end

return M
