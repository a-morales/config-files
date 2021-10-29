local fn = vim.fn

local install_path = fn.stdpath('data')..'/site/pack/packer/opt/packer.nvim'

if fn.empty(fn.glob(install_path)) > 0 then
  packer_bootstrap = fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
end

vim.cmd [[packadd packer.nvim]]
vim.cmd [[autocmd BufWritePost plugins.lua PackerCompile]]

return require('packer').startup(function (use)
  use {'wbthomason/packer.nvim', opt=true }

  -- Utility
  use "b0o/mapx.nvim" -- mapping DSL library
  use 'christoomey/vim-tmux-navigator'
  use 'tpope/vim-eunuch'

  -- Treesitter
  use {
    'nvim-treesitter/nvim-treesitter',
    run = ':TSUpdate'
  }
  use 'McAuleyPenney/tidy.nvim'
  use 'windwp/nvim-ts-autotag'
  use 'windwp/nvim-autopairs'

  -- Coloscheme
  use 'EdenEast/nightfox.nvim'
  use 'W0ng/vim-hybrid'

  -- Editor
  use {
    'ibhagwan/fzf-lua',
    requires = {
      'vijaymarupudi/nvim-fzf',
      'kyazdani42/nvim-web-devicons'
    }
  }
  use 'tpope/vim-commentary'
  use 'tpope/vim-repeat'
  use 'tpope/vim-surround'
  use 'tpope/vim-unimpaired'
  use {
    'lewis6991/gitsigns.nvim',
    requires = {
      'nvim-lua/plenary.nvim'
    }
  }


  -- LSP
  use 'neovim/nvim-lspconfig'
  use 'hrsh7th/cmp-nvim-lsp'
  use 'hrsh7th/cmp-buffer'
  use 'hrsh7th/nvim-cmp'
  use {
    "scalameta/nvim-metals",
    requires = { "nvim-lua/plenary.nvim" }
  }
  use "ray-x/lsp_signature.nvim"
  use 'kosayoda/nvim-lightbulb'

  -- Language Support
  use 'tmux-plugins/vim-tmux'

  --[[ plugins to try
    use "folke/which-key.nvim"  -- use mapx integration
  --]]

  if packer_bootstrap then
    require('packer').sync()
  end
end)
