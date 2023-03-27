-- credits to @Malace : https://www.reddit.com/r/neovim/comments/ql4iuj/rename_hover_including_window_title_and/
-- This is modified version of the above snippet

local M = {}
local inc_rename = require "nvchad_ui.renamer.inc_rename"

M.config = {
  show_message = true,
}

M.open = function()
  local currName = vim.fn.expand "<cword>"

  local curr_bufnr = vim.api.nvim_get_current_buf()
  local curr_win = vim.api.nvim_get_current_win()
  local win = require("plenary.popup").create(currName .. " ", {
    title = "Renamer",
    style = "minimal",
    borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
    relative = "cursor",
    borderhighlight = "RenamerBorder",
    titlehighlight = "RenamerTitle",
    focusable = true,
    width = 25,
    height = 1,
    line = "cursor+2",
    col = "cursor-1",
  })

  local map_opts = { noremap = true, silent = true }

  vim.cmd "normal w"
  vim.cmd "startinsert"

  vim.api.nvim_buf_set_keymap(
    0,
    "i",
    "<Esc>",
    "<cmd>stopinsert | lua require'nvchad_ui.renamer.inc_rename'.cancel_preview()<CR>",
    map_opts
  )
  vim.api.nvim_buf_set_keymap(
    0,
    "n",
    "<Esc>",
    "<cmd>stopinsert | lua require'nvchad_ui.renamer.inc_rename'.cancel_preview()<CR>",
    map_opts
  )

  vim.api.nvim_buf_set_keymap(
    0,
    "i",
    "<CR>",
    "<cmd>stopinsert | lua require'nvchad_ui.renamer.inc_rename'.inc_rename_execute()<CR>",
    map_opts
  )

  vim.api.nvim_buf_set_keymap(
    0,
    "n",
    "<CR>",
    "<cmd>stopinsert | lua require'nvchad_ui.renamer.inc_rename'.inc_rename_execute()<CR>",
    map_opts
  )

  inc_rename.inc_rename_initialize(win, curr_bufnr, curr_win, currName)
end

return M
