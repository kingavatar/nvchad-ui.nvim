local M = {}

--- checks if name is valied
---@param name string
---@return boolean
function M.is_valid_filename(name)
  local invalid_chars = "[^a-zA-Z0-9_. -]"
  return name:find(invalid_chars) == nil
end

---@source https://github.com/catppuccin/nvim/blob/main/lua/catppuccin/lib/hashing.lua

---@diagnostic disable-next-line: undefined-global, no-unknown
local B = bit or bit32 or require "nvchad_ui.util.bit"

local hash_str = function(str) -- djb2, https://stackoverflow.com/questions/7666509/hash-function-for-string
  local hash = 5381
  for i = 1, #str do
    hash = B.lshift(hash, 5) + hash + string.byte(str, i)
  end
  return tostring(hash)
end

function M.hash(v) -- Xor hashing: https://codeforces.com/blog/entry/85900
  local t = type(v)
  if t == "table" then
    local hash = 0
    ---@diagnostic disable-next-line: no-unknown
    for p, u in next, v do
      hash = B.bxor(hash, hash_str(p .. M.hash(u)))
    end
    return tostring(hash)
  elseif t == "function" then
    return hash_str(string.dump(v))
  else
    return tostring(v)
  end
end

return M
