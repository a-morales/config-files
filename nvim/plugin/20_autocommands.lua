local create_group = function(name)
  vim.api.nvim_create_augroup("amorales/" .. name, { clear = true })
end

vim.api.nvim_create_autocmd("TextYankPost", {
  group = create_group("yank_highlight"),
  desc = "Highlight when yanking (copying) text",
  callback = function()
    vim.highlight.on_yank()
  end,
})

vim.api.nvim_create_autocmd("BufReadPost", {
  group = create_group("open_last_position"),
  desc = "Open file at the last position it was edited earlier",
  pattern = "*",
  command = 'silent! normal! g`"zv',
})

vim.api.nvim_create_autocmd("FileType", {
  group = create_group("close_with_q"),
  desc = "Close with <q>",
  pattern = { "git", "help", "man", "qf", "scratch", "tvp" },
  callback = function(args)
    if args.match ~= "help" or not vim.bo[args.buf].modifiable then
      vim.keymap.set("n", "q", "<cmd>quit<cr>", { buffer = args.buf })
    end
  end,
})
vim.api.nvim_create_autocmd("FileType", {
  group = create_group("help_unconceal"),
  desc = "Disable conceal in modifiable help files",
  pattern = "help",
  callback = function(args)
    if vim.bo[args.buf].modifiable then
      vim.wo.conceallevel = 0
    end
  end,
})
