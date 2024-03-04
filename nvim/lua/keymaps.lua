vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.keymap.set("n", "<Leader>ew", ":e <C-R>=fnameescape(expand('%:h')).'/'<CR>")
vim.keymap.set("n", "<Leader>es", ":sp <C-R>=fnameescape(expand('%:h')).'/'<CR>")
vim.keymap.set("n", "<Leader>ev", ":vsp <C-R>=fnameescape(expand('%:h')).'/'<CR>")
vim.keymap.set("n", "<Leader>et", ":tabe <C-R>=fnameescape(expand('%:h')).'/'<CR>")
vim.keymap.set("n", "<leader>mk", ":!mkdir <C-R>=fnameescape(expand('%:h')).'/'<CR>")
vim.keymap.set("n", "<leader>r", ":windo redraw!<CR>")
vim.keymap.set("n", "<leader><space>", "<cmd>nohlsearch<CR>", { noremap = true })
