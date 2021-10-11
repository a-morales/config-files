local execute = vim.api.nvim_command
local fn = vim.fn

local install_path = fn.stdpath('data')..'/site/pack/packer/opt/packer.nvim'

if fn.empty(fn.glob(install_path)) > 0 then
  execute('!git clone https://github.com/wbthomason/packer.nvim '..install_path)
  execute 'packadd packer.nvim'
end

vim.cmd [[packadd packer.nvim]]
vim.cmd [[autocmd BufWritePost plugins.lua PackerCompile]]

return require('packer').startup(function (use)
  use {'wbthomason/packer.nvim', opt=true }

  -- LSP plugins
  use 'neovim/nvim-lspconfig'
  use 'glepnir/lspsaga.nvim'
  use 'folke/lsp-colors.nvim'
  use 'kyazdani42/nvim-web-devicons'
  use 'folke/lsp-trouble.nvim'
  use {'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }

  use 'W0ng/vim-hybrid'
  use 'tmux-plugins/vim-tmux'
  use 'christoomey/vim-tmux-navigator'
  use { 'junegunn/fzf', run = function() fn['fzf#install']() end }
  use 'junegunn/fzf.vim'
  use 'airblade/vim-gitgutter'
  use 'tveskag/nvim-blame-line'
  use 'tpope/vim-commentary'
  use 'tpope/vim-repeat'
  use 'tpope/vim-surround'
  use 'tpope/vim-unimpaired'
  use 'tpope/vim-eunuch'
  use 'scalameta/nvim-metals'
  use 'windwp/nvim-autopairs'
  use 'GEverding/vim-hocon'
  use {'hrsh7th/nvim-compe', requires = {{'hrsh7th/vim-vsnip'}}}
  use 'folke/tokyonight.nvim'
  use 'keith/swift.vim'
  use 'glepnir/zephyr-nvim'
  use 'shaunsingh/nord.nvim'
  use 'kyazdani42/nvim-tree.lua'
  use 'nvim-lua/popup.nvim'
  use 'nvim-lua/plenary.nvim'
  use 'nvim-telescope/telescope.nvim'
  -- use 'https://gitlab.com/__tpb/monokaipro.nvim'
  use 'kristijanhusak/orgmode.nvim'
  use 'projekt0n/github-nvim-theme'

  require('plugins.fzf')
  require('plugins.metals')
  require('plugins.lsp')
  require('nvim-autopairs').setup({
    local_break_line_filetype = { 'scala' }
  })
  require('plugins.orgmode')
  -- require('nord').set()
  -- require('zephyr')
end)
