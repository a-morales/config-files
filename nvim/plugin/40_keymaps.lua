local set = vim.keymap.set

_G.Config.leader_group_clues = {
  { mode = "n", keys = "<leader>b", desc = "+Buffer" },
  { mode = "n", keys = "<leader>f", desc = "+Find" },
  { mode = "n", keys = "<leader>t", desc = "+Toggle" },
  { mode = "n", keys = "<leader>d", desc = "+Dap" },
  { mode = "n", keys = "<leader>x", desc = "+Trouble" },
  { mode = "n", keys = "<leader>h", desc = "+Haunt" },
}

-- stylua: ignore start
set("n", "<leader><space>", "<cmd>nohlsearch<CR>", { noremap = true })

-- smart-splits
set("n", "<C-h>", "<cmd> SmartCursorMoveLeft<CR>")
set("n", "<C-j>", "<cmd> SmartCursorMoveDown<CR>")
set("n", "<C-k>", "<cmd> SmartCursorMoveUp<CR>")
set("n", "<C-l>", "<cmd> SmartCursorMoveRight<CR>")
set("n", "<A-h>", "<cmd> SmartResizeLeft<CR>")
set("n", "<A-j>", "<cmd> SmartResizeDown<CR>")
set("n", "<A-k>", "<cmd> SmartResizeUp<CR>")
set("n", "<A-l>", "<cmd> SmartResizeRight<CR>")
set("n", "<leader>h", "<cmd> SmartSwapLeft<CR>", { desc = "Swap Left" })
set("n", "<leader>j", "<cmd> SmartSwapUp<CR>", { desc = "Swap Up" })
set("n", "<leader>k", "<cmd> SmartSwapDown<CR>", { desc = "Swap Down" })
set("n", "<leader>l", "<cmd> SmartSwapRight<CR>", { desc = "Swap Right" })

-- neo-tree
set("n", "<C-n>", "<cmd> Neotree filesystem reveal float<CR>")
set("n", "<leader>n", "<cmd> Neotree filesystem reveal left<CR>")

-- bufferline
set("n", "<leader>ba", "<cmd> b#<CR>", { desc = "Alternate" })
set("n", "<leader>bp", "<cmd> BufferLinePick<CR>", { desc = "Pick" })
set("n", "<leader>bc", "<cmd> BufferLinePickClose<CR>", { desc = "Close Pick" })
set("n", "<leader>bo", "<cmd> BufferLineCloseOthers<CR>", { desc = "Close Others" })
set("n", "<leader>bd", "<cmd> lua MiniBufremove.delete()<CR>", { desc = "Delete" })

-- fzf-lua
set("n", "<C-p>", "<cmd> FzfLua files<CR>")
set("n", "<C-space>", "<cmd> FzfLua buffers<CR>")
set("n", "<leader>/", "<cmd> FzfLua grep_cword<CR>")
set("v", "<leader>/", "<cmd> FzfLua grep_visual<CR>")
set("n", "<leader>fh", "<cmd> FzfLua help_tags<CR>", { desc = "Help tags" })
set("n", "<leader>fg", "<cmd> FzfLua live_grep<CR>", { desc = "Live grep" })
set("n", "<leader>fw", "<cmd> FzfLua grep_cword<CR>", { desc = "Current word" })
set("n", "<leader>fq", "<cmd> FzfLua quickfix<CR>", { desc = "Quickfix" })
set("n", "<leader>fr", "<cmd> FzfLua lsp_references<CR>", { desc = "LSP references" })
set("n", "<leader>fc", "<cmd> FzfLua commands<CR>", { desc = "Commands" })
set("n", "<leader>fd", "<cmd> FzfLua diagnostics_document<CR>", { desc = "Diagnostics document" })
set("n", "<leader>fd", "<cmd> FzfLua diagnostics_workspace<CR>", { desc = "Diagnostics workspace" })
set("n", "<leader>fi", "<cmd> Nerdy<CR>", { desc = "Icons" })
set("n", "<leader>fo", "<cmd> FzfLua resume<CR>", { desc = "Resume" })
set("n", "<leader>fb", "<cmd>HauntShowAll<cr>", { desc = "Bookmarks" })

-- bracketed
set("n", "[;", "<cmd> DropbarContextStart<cr>", { desc = "Go to start of current context" })
set("n", "];", "<cmd> DropbarContextNext<cr>", { desc = "Select next context" })

--dropbar
set("n", "<Leader>;", "<cmd> DropbarPick<cr>", { desc = "Pick symbols in winbar" })

-- dap
set("n", "<leader>dc", "<cmd> DapContinue<cr>", { desc = "continue" })
set("n", "<leader>dr", "<cmd> DapToggleRepl<cr>", { desc = "toggle repl" })
set("n", "<leader>db", "<cmd> DapToggleBreakpoint<cr>", { desc = "toggle breakpoint" })
set("n", "<leader>dso", "<cmd> DapStepOver<cr>", { desc = "step over" })
set("n", "<leader>dsi", "<cmd> DapStepInto<cr>", { desc = "step into" })

-- trouble
set("n", "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", { desc = "Diagnostics" })
set("n", "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", { desc = "Buffer Diagnostics (Trouble)" })
set("n", "<leader>xs", "<cmd>Trouble symbols toggle focus=false<cr>", { desc = "Symbols" })
set("n", "<leader>xl", "<cmd>Trouble lsp toggle focus=false win.position=right<cr>", { desc = "LSP Definitions / references" })
set("n", "<leader>xq", "<cmd>Trouble qflist toggle<cr>", { desc = "Quickfix List" })

-- haunt
set("n", "<leader>ha", "<cmd>HauntAnnotate<cr>", { desc = "Annotate" })
set("n", "<leader>ht", "<cmd>HauntToggleAll<cr>", { desc = "Toggle annotate" })
set("n", "<leader>hd", "<cmd>HauntDelete<cr>", { desc = "Delete" })
set("n", "<leader>hD", "<cmd>HauntClearAll<cr>", { desc = "Delete all" })
set("n", "<leader>hp", "<cmd>HauntPrev<cr>", { desc = "Previous" })
set("n", "<leader>hn", "<cmd>HauntNext<cr>", { desc = "Next" })
set("n", "<leader>hl", "<cmd>HauntList<cr>", { desc = "List" })
set("n", "<leader>hq", "<cmd>HauntQfAll<cr>", { desc = "Quickfix" })

-- toggles
set("n", "<leader>ta", "<cmd>HauntToggleAll<cr>", { desc = "Toggle Haunt Annotations"})

-- stylua: ignore end
