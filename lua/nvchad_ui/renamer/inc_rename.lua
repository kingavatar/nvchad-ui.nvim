local M = {}
local api = vim.api

---@source https://github.com/smjonas/inc-rename.nvim/blob/main/lua/inc_rename/init.lua
--- Modifications where done to accomodate the use of popup instead of cmdline which
--- enables the movement of cursor in input buffer which is absent in original plugin

M.config = {
  hl_group = "Substitute",
  show_message = true,
}

local state = {
  should_fetch_references = true,
  cached_lines = nil,
  err = nil,
  input_win_id = nil,
  input_bufnr = nil,
  preview_win = nil,
  curr_name = nil,
  preview_ns = nil,
}

local set_error = function(msg, level)
  state.err = { msg = msg, level = level }
  state.cached_lines = nil
end

local initialize_input_popup = function(win_id, curr_win)
  state.input_win_id = win_id
  state.input_bufnr = api.nvim_win_get_buf(win_id)
  state.preview_win = curr_win
  state.preview_ns = vim.api.nvim_create_augroup("inc-rename", { clear = true })
end

---@param bufnr integer
---@return boolean
local function buf_is_visible(bufnr)
  if api.nvim_buf_is_loaded(bufnr) then
    for _, win in ipairs(api.nvim_tabpage_list_wins(0)) do
      if api.nvim_win_get_buf(win) == bufnr then return true end
    end
  end
  return false
end

---@param result table<integer,{uri:string, range:{start: {character: integer, line:integer}, end:{character:integer, line:integer}}}>
local function cache_lines(result)
  ---@type table<integer, table<integer, {bufnr: integer, end_col: integer, is_visible: boolean, start_col: integer, text: string}[]>>
  local cached_lines = vim.defaulttable()
  for _, res in ipairs(result) do
    local range = res.range
    -- E.g. sumneko_lua sends ranges across multiple lines when a table value is a function, skip this range
    if range.start.line == range["end"].line then
      local bufnr = vim.uri_to_bufnr(res.uri)
      local is_visible = buf_is_visible(bufnr)
      local line_nr = range.start.line
      -- Make sure buffer is loaded before retrieving the line
      if not api.nvim_buf_is_loaded(bufnr) then vim.fn.bufload(bufnr) end
      local line = api.nvim_buf_get_lines(bufnr, line_nr, line_nr + 1, false)[1]
      local start_col, end_col = range.start.character, range["end"].character
      local line_info = { text = line, start_col = start_col, end_col = end_col, bufnr = bufnr, is_visible = is_visible }

      -- Same line was already seen
      if cached_lines[bufnr][line_nr] then
        table.insert(cached_lines[bufnr][line_nr], line_info)
      else
        cached_lines[bufnr][line_nr] = { line_info }
      end
    end
  end
  return cached_lines
end

--- Some LSP servers like bashls send items with the same positions multiple times,
--- filter out these duplicates to avoid highlighting issues.
---@param cached_lines table<integer, table<integer, {bufnr: integer, end_col: integer, is_visible: boolean, start_col: integer, text: string}[]>>
local function filter_duplicates(cached_lines)
  for buf, line_info_per_bufnr in pairs(cached_lines) do
    for line_nr, line_info in pairs(line_info_per_bufnr) do
      local len = #line_info
      if len > 1 then
        -- This naive implementation only filters out items that are duplicates
        -- of the first item. Let's leave it like this and see if someone complains.
        local start_col, end_col = line_info[1].start_col, line_info[1].end_col
        local filtered_lines = { line_info[1] }
        for i = 2, len do
          if line_info[i].start_col ~= start_col and line_info[i].end_col ~= end_col then filtered_lines[i] = line_info[i] end
        end
        cached_lines[buf][line_nr] = filtered_lines
      end
    end
  end
  return cached_lines
end

-- Get positions of LSP reference symbols
local function fetch_lsp_references(bufnr)
  local clients = vim.lsp.get_active_clients {
    bufnr = bufnr,
  }
  ---@diagnostic disable-next-line: no-unknown
  clients = vim.tbl_filter(function(client) return client.supports_method "textDocument/rename" end, clients)

  if #clients == 0 then
    set_error "[inc-rename] No active language server with rename capability"
    return
  end

  local params = vim.lsp.util.make_position_params(state.preview_win)
  params.context = { includeDeclaration = true }
  vim.lsp.buf_request(bufnr, "textDocument/references", params, function(err, result, _, _)
    if err then
      set_error("[inc-rename] Error while finding references: " .. err.message, vim.lsp.log_levels.ERROR)
      return
    end
    if not result or vim.tbl_isempty(result) then
      set_error("[inc-rename] Nothing to rename", vim.lsp.log_levels.WARN)
      return
    end
    state.cached_lines = filter_duplicates(cache_lines(result))
  end)
end

local function tear_down()
  state.should_fetch_references = true
  state.cached_lines = nil
  if state.input_win_id and api.nvim_win_is_valid(state.input_win_id) then
    -- Close the popup
    api.nvim_win_close(state.input_win_id, true)
    -- Clear highlights
    api.nvim_buf_clear_namespace(api.nvim_win_get_buf(state.preview_win), state.preview_ns, 0, -1)
    -- Clear autocmd group
    api.nvim_del_augroup_by_id(state.preview_ns)
    state.input_win_id = nil
    state.input_bufnr = nil
    state.preview_ns = nil
  end
end

-- Called when the user is typing the new name
local function incremental_rename_preview(preview_bufnr, old_name)
  local new_name = old_name or vim.trim(vim.fn.getline ".")
  vim.v.errmsg = ""
  -- Store the lines of the buffer at the first invocation.
  -- should_fetch_references will be reset when the command is cancelled (see setup function).
  if state.should_fetch_references then
    state.should_fetch_references = false
    state.err = nil
    fetch_lsp_references(preview_bufnr)
  end

  -- Started fetching references but the results did not arrive yet
  -- (or an error occurred while fetching them).
  if not state.cached_lines then
    -- when state.cached_lines is still nil
    return
  end
  --
  -- if not M.config.preview_empty_name and new_name:find "^%s*$" then
  --   return M.config.input_buffer ~= nil and 2
  -- end

  ---@param line_info table<integer, {is_visible: boolean, start_col: integer, end_col: integer}>
  local function apply_highlights_fn(bufnr, line_nr, line_info)
    local hl_positions = {}

    for idx, info in ipairs(line_info) do
      if info.is_visible then
        -- Use nvim_buf_set_text instead of nvim_buf_set_lines to preserve ext-marks
        api.nvim_buf_set_text(bufnr, line_nr, info.start_col, line_nr, info.end_col, { new_name })
        state.cached_lines[bufnr][line_nr][idx].end_col = info.start_col + #new_name
        table.insert(hl_positions, {
          start_col = info.start_col,
          end_col = info.start_col + #new_name,
        })
      end
    end

    ---@diagnostic disable-next-line: no-unknown
    for _, hl_pos in ipairs(hl_positions) do
      api.nvim_buf_add_highlight(
        bufnr or preview_bufnr,
        state.preview_ns,
        M.config.hl_group,
        line_nr,
        hl_pos.start_col,
        hl_pos.end_col
      )
    end
  end

  for bufnr, line_info_per_bufnr in pairs(state.cached_lines) do
    for line_nr, line_info in pairs(line_info_per_bufnr) do
      apply_highlights_fn(bufnr, line_nr, line_info)
    end
  end
end

-- Sends a LSP rename request and optionally displays a message to the user showing
-- how many instances were renamed in how many files
local function perform_lsp_rename(new_name)
  state.curr_name = new_name
  local params = vim.lsp.util.make_position_params(state.preview_win)
  params.newName = new_name
  vim.lsp.buf_request(0, "textDocument/rename", params, function(err, result, ctx, _)
    if err and err.message then
      vim.notify("[inc-rename] Error while renaming: " .. err.message, vim.lsp.log_levels.ERROR)
      return
    end

    if not result or vim.tbl_isempty(result) then
      M.set_error("[inc-rename] Nothing renamed", vim.lsp.log_levels.WARN)
      return
    end

    ---@type {offset_encoding: string}
    local client = vim.lsp.get_client_by_id(ctx.client_id)
    vim.lsp.util.apply_workspace_edit(result, client.offset_encoding)

    if M.config.show_message then
      local changed_instances = 0
      local changed_files = 0

      local with_edits = result.documentChanges ~= nil
      ---@diagnostic disable-next-line: no-unknown
      for _, change in pairs(result.documentChanges or result.changes) do
        changed_instances = changed_instances + (with_edits and #change.edits or #change)
        changed_files = changed_files + 1
      end

      local message = string.format(
        "Renamed %s instance%s in %s file%s",
        changed_instances,
        changed_instances == 1 and "" or "s",
        changed_files,
        changed_files == 1 and "" or "s"
      )
      vim.notify(message)
    end
    -- if M.config.post_hook then
    --   M.config.post_hook(result)
    -- end
  end)
end

M.inc_rename_execute = function()
  if vim.v.errmsg ~= "" then
    vim.notify("[inc-rename] An error occurred in the preview function \n" .. vim.v.errmsg, vim.lsp.log_levels.ERROR)
  elseif state.err then
    vim.notify(state.err.msg, state.err.level)
  else
    local newName = vim.trim(vim.fn.getline ".")
    tear_down()
    if #newName > 0 and newName ~= state.curr_name then perform_lsp_rename(newName) end
  end
end

M.cancel_preview = function()
  incremental_rename_preview(api.nvim_win_get_buf(state.preview_win), state.curr_name)
  tear_down()
end

M.inc_rename_initialize = function(win, curr_buf, curr_win, curr_name)
  initialize_input_popup(win, curr_win)
  state.curr_name = curr_name
  api.nvim_create_autocmd("TextChangedI", {
    group = state.preview_ns,
    callback = function() incremental_rename_preview(curr_buf) end,
  })
end

return M
