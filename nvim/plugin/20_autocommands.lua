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
  pattern = { "git", "help", "man", "qf", "scratch", "tvp", "dap-view", "dap-repl" },
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

vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "CursorHold", "TermClose", "TermLeave" }, {
  group = create_group("auto_reload"),
  desc = "Check for files changed outside Neovim (e.g. edits made by Claude)",
  callback = function()
    if vim.o.buftype ~= "nofile" and vim.fn.mode() ~= "c" then
      vim.cmd("checktime")
    end
  end,
})

vim.api.nvim_create_autocmd("FileChangedShellPost", {
  group = create_group("auto_reload_notify"),
  desc = "Notify when a buffer is reloaded after an external change",
  callback = function()
    vim.notify("File changed on disk; buffer reloaded", vim.log.levels.WARN)
  end,
})

vim.api.nvim_create_autocmd("PackChanged", {
  group = create_group("pack_changed"),
  callback = function(ev)
    local name, kind = ev.data.spec.name, ev.data.kind
    if name == "nvim-treesitter" and kind == "update" then
      if not ev.data.active then
        vim.cmd.packadd("nvim-treesitter")
      end
      vim.cmd("TSUpdate")
    end
  end,
})
