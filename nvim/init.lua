vim.g.mapleader = " "
vim.g.maplocalleader = " "

local mini_path = vim.fn.stdpath("data") .. "/site/pack/deps/start/mini.nvim"
if not vim.loop.fs_stat(mini_path) then
  vim.cmd('echo "Installing `mini.nvim`" | redraw')
  local origin = "https://github.com/nvim-mini/mini.nvim"
  local clone_cmd = { "git", "clone", "--filter=blob:none", origin, mini_path }
  vim.fn.system(clone_cmd)
  vim.cmd("packadd mini.nvim | helptags ALL")
  vim.cmd('echo "Installed `mini.nvim`" | redraw')
end

require("mini.deps").setup()

_G.Config = {}

_G.pack_add = MiniDeps.add
_G.now = MiniDeps.now
_G.later = MiniDeps.later
_G.now_if_args = vim.fn.argc(-1) > 0 and now or later
