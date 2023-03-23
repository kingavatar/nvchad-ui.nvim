local M = {}

--- checks if name is valied
---@param name string
---@return boolean
function M.is_valid_filename(name)
  local invalid_chars = "[^a-zA-Z0-9_. ]"
  return name:find(invalid_chars) == nil
end

return M
