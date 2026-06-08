vim.opt_local.wrap = true
vim.opt_local.conceallevel = 2
vim.opt_local.concealcursor = ""
vim.opt_local.spell = true
vim.opt_local.spelllang = "en_us"
vim.opt_local.textwidth = 0
vim.opt_local.shiftwidth = 2
vim.opt_local.formatoptions = "tcqln"

vim.keymap.set({ "n", "x" }, "j", "gj", { buffer = true })
vim.keymap.set({ "n", "x" }, "k", "gk", { buffer = true })
