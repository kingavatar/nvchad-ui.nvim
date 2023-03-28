-- n, v, i, t = mode names
---@source https://www.lazyvim.org/keymaps

local M = {}

M.general = {
  n = {
    ["<leader>ur"] = { "", "Redraw / clear hlsearch / diff update" },
    ["gw"] = { "", "Search word under cursor (x)" },
    ["n"] = { "", "Next search result (x, o)" },
    ["N"] = { "", "Prev search result (x, o)" },
    ["<C-s>"] = { "", "Save file (i, v, n, s)" },
    ["<leader>l"] = { "", "Lazy" },
    ["<leader>fn"] = { "", "New File" },
    ["<leader>x"] = { "", "Location List" },
    ["<leader>xq"] = { "", "Quickfix List" },
    ["<leader>ui"] = { "", "Inspect Pos" },
    ["<leader>qq"] = { "", "Quit all" },
  },
  Movement = {
    ["<C-h>"] = { "", "Go to left window" },
    ["<C-j>"] = { "", "Go to lower window" },
    ["<C-k>"] = { "", "Go to upper window" },
    ["<C-l>"] = { "", "Go to right window" },
    ["<C-Up>"] = { "", "Increase window height" },
    ["<C-Down>"] = { "", "Decrease window height" },
    ["<C-Left>"] = { "", "Decrease window width" },
    ["<C-Right>"] = { "", "Increase window width" },
    ["<A-j>"] = { "", "Move down (i, v)" },
    ["<A-k>"] = { "", "Move up (i, v)" },
    ["<S-h>"] = { "", "Prev buffer" },
    ["<S-l>"] = { "", "Next buffer" },
    ["[b"] = { "", "Prev buffer" },
    ["]b"] = { "", "Next buffer" },
    ["<leader>bb or <leader>`"] = { "", "Switch to Other Buffer" },
  },
  Window = {
    ["<leader>ww"] = { "", "Other window" },
    ["<leader>wd"] = { "", "Delete window" },
    ["<leader>w-"] = { "", "Split window below" },
    ["<leader>w|"] = { "", "Split window right" },
    ["<leader>-"] = { "", "Split window below" },
    ["<leader>|"] = { "", "Split window right" },
  },
  Toggle = {
    ["<leader>uf"] = { "", "Toggle format on Save" },
    ["<leader>us"] = { "", "Toggle Spelling" },
    ["<leader>uw"] = { "", "Toggle Word Wrap" },
    ["<leader>ul"] = { "", "Toggle Line Numbers" },
    ["<leader>ud"] = { "", "Toggle Diagnostics" },
    ["<leader>uc"] = { "", "Toggle Conceal" },
  },
  Tabs = {
    ["<leader><tab>l"] = { "", "Last Tab" },
    ["<leader><tab>f"] = { "", "First Tab" },
    ["<leader><tab><tab> or <leader><tab>]"] = { "", "New Tab" },
    ["<leader><tab>d"] = { "", "Close Tab" },
    ["<leader><tab>["] = { "", "Previous Tab" },
  },
}

M.lazygit = {
  n = {
    ["<leader>gg"] = { "", "Lazygit (root dir)" },
    ["<leader>gG"] = { "", "Lazygit (cwd)" },
  },
}

M.terminal = {
  n = {
    ["<leader>ft"] = { "", "Terminal (root dir)" },
    ["<leader>fT"] = { "", "Terminal (cwd)" },
    ["<esc><esc>"] = { "", "Enter Normal Mode (t)" },
  },
}

M.Lsp = {
  n = {
    ["<leader>cd"] = { "", "Line Diagnostics" },
    ["<leader>cl"] = { "", "Lsp Inf" },
    ["gd"] = { "", "Goto Definition" },
    ["gr"] = { "", "References" },
    ["gD"] = { "", "Goto Declaration" },
    ["gI"] = { "", "Goto Implementation" },
    ["gt"] = { "", "Goto Type Definition" },
    ["K"] = { "", "Hover" },
    ["gK"] = { "", "Signature Help" },
    ["<c-k>"] = { "", "Signature Help" },
    ["]d"] = { "", "Next Diagnostic" },
    ["[d"] = { "", "Prev Diagnostic" },
    ["]e"] = { "", "Next Error" },
    ["[e"] = { "", "Prev Error" },
    ["]w"] = { "", "Next Warning" },
    ["[w"] = { "", "Prev Warning" },
    ["<leader>ca"] = { "", "Code Action (n, v)" },
    ["<leader>cf"] = { "", "Format Document or Format Range (v)" },
    ["<leader>cr"] = { "", "Rename" },
  },
}

M.bufferline = {
  n = {
    ["<leader>bp"] = { "", "Toggle pin" },
    ["<leader>bP"] = { "", "Delete non-pinned buffers" },
  },
}

M["flit or leap"] = {
  ["n, x, o"] = {
    ["f or F"] = { "", "f F" },
    ["t or T"] = { "", "t T" },
    ["s or S"] = { "", "Leap forward/Backward to" },
    ["gs"] = { "", "Leap from windows" },
  },
}

M.mason = {
  n = {
    ["<leader>cm"] = { "", "Mason" },
  },
}

M.mini = {
  n = {
    ["<leader>bd"] = { "", "Delete Buffer" },
    ["<leader>bD"] = { "", "Delete Buffer (Force)" },
    ["gza"] = { "", "Add surrounding (n, v)" },
    ["gzd"] = { "", "Delete surrounding" },
    ["gzf"] = { "", "Find right surrounding" },
    ["gzF"] = { "", "Find left surrounding" },
    ["gzh"] = { "", "Highlight surrounding" },
    ["gzr"] = { "", "Replace surrounding" },
    ["gzn"] = { "", "Update MiniSurround.config.n_lines" },
  },
}

M["neo-tree"] = {
  n = {
    ["<leader>fe"] = { "", "Explorer NeoTree (root dir)" },
    ["<leader>fE"] = { "", "Explorer NeoTree (cwd)" },
    ["<leader>e"] = { "", "Explorer NeoTree (root dir)" },
    ["<leader>E"] = { "", "Explorer NeoTree (cwd)" },
  },
}

M.noice = {
  n = {
    ["<S-Enter>"] = { "", "Redirect Cmdline (c)" },
    ["<leader>snl"] = { "", "Noice Last Message" },
    ["<leader>snh"] = { "", "Noice History" },
    ["<leader>sna"] = { "", "Noice All" },
    ["<c-f>"] = { "", "Scroll forward (i, n, s)" },
    ["<c-b>"] = { "", "Scroll backward (i, n, s)" },
  },
}

M["nvim-notify"] = {
  n = {
    ["<leader>un"] = { "", "Delete all Notifications" },
  },
}

M["nvim-spectre"] = {
  n = {
    ["<leader>sr"] = { "", "Replace in files (Spectre)" },
  },
}

M["nvim-treesitter"] = {
  n = {
    ["<c-space>"] = { "", "Increment selection" },
    ["<bs>"] = { "", "Decrement selection (x)" },
  },
}

M.persistence = {
  n = {
    ["<leader>qs"] = { "", "Restore Session" },
    ["<leader>ql"] = { "", "Restore Last Session" },
    ["<leader>qd"] = { "", "Don't Save Current Session" },
  },
}

M.telescope = {
  n = {
    ["<leader>,"] = { "", "Switch Buffer" },
    ["<leader>/"] = { "", "Find in Files (Grep)" },
    ["<leader>:"] = { "", "Command History" },
    ["<leader><space>"] = { "", "Find Files (root dir)" },
    ["<leader>fb"] = { "", "Buffers" },
    ["<leader>ff"] = { "", "Find Files (root dir)" },
    ["<leader>fF"] = { "", "Find Files (cwd)" },
    ["<leader>fr"] = { "", "Recent" },
    ["<leader>gc"] = { "", "commits" },
    ["<leader>gs"] = { "", "status" },
    ["<leader>uC"] = { "", "Colorscheme with preview" },
    ["<leader>ss"] = { "", "Goto Symbol" },
    ["<leader>sS"] = { "", "Goto Symbol (Workspace)" },
  },
  search = {
    ["<leader>sa"] = { "", "Auto Commands" },
    ["<leader>sb"] = { "", "Buffer" },
    ["<leader>sc"] = { "", "Command History" },
    ["<leader>sC"] = { "", "Commands" },
    ["<leader>sd"] = { "", "Diagnostics" },
    ["<leader>sg"] = { "", "Grep (root dir)" },
    ["<leader>sG"] = { "", "Grep (cwd)" },
    ["<leader>sh"] = { "", "Help Pages" },
    ["<leader>sH"] = { "", "Search Highlight Groups" },
    ["<leader>sk"] = { "", "Key Maps" },
    ["<leader>sM"] = { "", "Man Pages" },
    ["<leader>sm"] = { "", "Jump to Mark" },
    ["<leader>so"] = { "", "Options" },
    ["<leader>sR"] = { "", "Resume" },
    ["<leader>sw"] = { "", "Word (root dir)" },
    ["<leader>sW"] = { "", "Word (cwd)" },
  },
}

M["todo-comments"] = {
  n = {
    ["]t"] = { "", "Next todo commen" },
    ["[t"] = { "", "Previous todo comment" },
    ["<leader>xt"] = { "", "Todo (Trouble)" },
    ["<leader>xT"] = { "", "Todo/Fix/Fixme (Trouble)" },
    ["<leader>st"] = { "", "Todo" },
  },
}

M.trouble = {
  n = {
    ["<leader>xx"] = { "", "Document Diagnostics (Trouble)" },
    ["<leader>xX"] = { "", "Workspace Diagnostics (Trouble)" },
    ["<leader>xL"] = { "", "Location List (Trouble)" },
    ["<leader>xQ"] = { "", "Quickfix List (Trouble)" },
    ["[q"] = { "", "Previous trouble/quickfix item" },
    ["]q"] = { "", "Next trouble/quickfix item" },
  },
}

M["vim-illuminate"] = {
  n = {
    ["]]"] = { "", "Next Reference" },
    ["[["] = { "", "Prev Reference" },
  },
}

M["nvchad-ui"] = {
  n = {
    ["<leader>ch"] = { "", "Mapping cheatsheet" },
  },
}

return M
