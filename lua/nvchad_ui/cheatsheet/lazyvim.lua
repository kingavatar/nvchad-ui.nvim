-- n, v, i, t = mode names

local M = {}

M["general (Movement)"] = {
  n = {
    ["<C-h>"] = { "", "Go to left window" },
    ["<C-j>"] = { "", "Go to lower window" },
    ["<C-k>"] = { "", "Go to upper window" },
    ["<C-l>"] = { "", "Go to right window" },
    ["<C-Up>"] = { "", "Increase window height" },
    ["<C-Down>"] = { "", "Decrease window height" },
    ["<C-Left>"] = { "", "Decrease window width" },
    ["<C-Right>"] = { "", "Increase window width" },
    ["<A-j>"] = { "", "Move down" },
    ["<A-k>"] = { "", "Move up" },
    ["<S-h>"] = { "", "Prev buffer" },
    ["<S-l>"] = { "", "Next buffer" },
    ["[b"] = { "", "Prev buffer" },
    ["]b"] = { "", "Next buffer" },
    ["<leader>bb or <leader>`"] = { "", "Switch to Other Buffer" },
  },
  i = {
    ["<A-j>"] = { "", "Move down" },
    ["<A-k>"] = { "", "Move up" },
  },
  v = {
    ["<A-j>"] = { "", "Move down" },
    ["<A-k>"] = { "", "Move up" },
  },
}

M.general = {
  n = {
    ["<leader>ur"] = { "", "Redraw / clear hlsearch / diff update" },
    ["gw"] = { "", "Search word under cursor (also mode x)" },
    ["n"] = { "", "Next search result (also mode x, o)" },
    ["N"] = { "", "Prev search result (also mode x, o)" },
    ["<C-s>"] = { "", "Save file (also mode i, v, n, s)" },
    ["<leader>l"] = { "", "Lazy" },
    ["<leader>fn"] = { "", "New File" },
  },
}

return M
