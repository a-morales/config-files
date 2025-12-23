local set = vim.keymap.set

_G.Config.leader_group_clues = {
  { mode = "n", keys = "<Leader>b", desc = "+Buffer" },
  { mode = "n", keys = "<Leader>f", desc = "+Find" },
}

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
set("v", "/", "<cmd> FzfLua grep_cword<CR>")
set("n", "<leader>fh", "<cmd> FzfLua help_tags<CR>", { desc = "Help tags" })
set("n", "<leader>fg", "<cmd> FzfLua live_grep<CR>", { desc = "Live grep" })
set("n", "<leader>fw", "<cmd> FzfLua grep_cword<CR>", { desc = "Current word" })
set("n", "<leader>fc", "<cmd> FzfLua commands<CR>", { desc = "Commands" })
