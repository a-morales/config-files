local set = vim.keymap.set

_G.Config.leader_group_clues = {
  { mode = "n", keys = "<Leader>b", desc = "+Buffer" },
  { mode = "n", keys = "<Leader>f", desc = "+Find" },
}

set("n", "<leader><space>", "<cmd>nohlsearch<CR>", { noremap = true })

-- smart-splits
set("n", "<C-h>", ":SmartCursorMoveLeft<CR>")
set("n", "<C-j>", ":SmartCursorMoveDown<CR>")
set("n", "<C-k>", ":SmartCursorMoveUp<CR>")
set("n", "<C-l>", ":SmartCursorMoveRight<CR>")
set("n", "<A-h>", ":SmartResizeLeft<CR>")
set("n", "<A-j>", ":SmartResizeDown<CR>")
set("n", "<A-k>", ":SmartResizeUp<CR>")
set("n", "<A-l>", ":SmartResizeRight<CR>")
set("n", "<leader>h", ":SmartSwapLeft<CR>", { desc = "Swap Left" })
set("n", "<leader>j", ":SmartSwapUp<CR>", { desc = "Swap Up" })
set("n", "<leader>k", ":SmartSwapDown<CR>", { desc = "Swap Down" })
set("n", "<leader>l", ":SmartSwapRight<CR>", { desc = "Swap Right" })

-- neo-tree
set("n", "<C-n>", ":Neotree filesystem reveal float<CR>")
set("n", "<leader>n", ":Neotree filesystem reveal left<CR>")

-- bufferline
set("n", "<leader>ba", ":b#<CR>", { desc = "Alternate" })
set("n", "<leader>bp", ":BufferLinePick<CR>", { desc = "Pick" })
set("n", "<leader>bc", ":BufferLinePickClose<CR>", { desc = "Close Pick" })
set("n", "<leader>bo", ":BufferLineCloseOthers<CR>", { desc = "Close Others" })
set("n", "<leader>bd", ":lua MiniBufremove.delete()<CR>", { desc = "Delete" })

-- fzf-lua
set("n", "<C-p>", ":FzfLua files<CR>")
set("n", "<C-space>", ":FzfLua buffers<CR>")
set("v", "/", ":FzfLua grep_cword<CR>")
set("n", "<leader>fh", ":FzfLua help_tags<CR>", { desc = "Help tags" })
set("n", "<leader>fg", ":FzfLua live_grep<CR>", { desc = "Live grep" })
set("n", "<leader>fw", ":FzfLua grep_cword<CR>", { desc = "Current word" })
set("n", "<leader>fc", ":FzfLua commands<CR>", { desc = "Commands" })
