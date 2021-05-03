" auto-install vim-plug
if empty(glob('~/.config/nvim/autoload/plug.vim'))
  silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall | source $MYVIMRC
endif

function! DoRemote(arg)
  UpdateRemotePlugins
endfunction

call plug#begin('~/.config/nvim/plugged')

  Plug 'neoclide/coc.nvim', {'branch': 'release'}
  Plug 'tmux-plugins/vim-tmux'
  Plug 'christoomey/vim-tmux-navigator'
  Plug 'W0ng/vim-hybrid'
  Plug 'neovim/nvim-lsp'
  Plug 'haorenW1025/completion-nvim'
  Plug 'haorenW1025/diagnostic-nvim'

  Plug 'airblade/vim-gitgutter'
  Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
  Plug 'junegunn/fzf.vim'
  Plug 'tpope/vim-commentary'
  Plug 'tpope/vim-fugitive'
  Plug 'tpope/vim-repeat'
  Plug 'tpope/vim-surround'
  Plug 'tpope/vim-unimpaired'
  Plug 'tpope/vim-eunuch'
  Plug 'godlygeek/tabular'
  Plug 'plasticboy/vim-markdown'
  Plug 'HerringtonDarkholme/yats.vim'
  Plug 'rhysd/git-messenger.vim'
  Plug 'troydm/zoomwintab.vim'
  Plug 'cohama/lexima.vim'
  Plug 'janko/vim-test'
  Plug 'benmills/vimux'
  Plug 'itchyny/lightline.vim'
  "Plug 'unblevable/quick-scope'
  "Plug 'tpope/vim-sleuth'
  "Plug 'derekwyatt/vim-scala'
  "Plug 'christoomey/vim-sort-motion'
  "Plug 'mhinz/vim-startify'
  "Plug 'tpope/vim-abolish'
  "Plug 'pangloss/vim-javascript'
  "Plug 'Carpetsmoker/undofile_warn.vim'
  "Plug 'mbbill/undotree'
  "Plug 'reasonml-editor/vim-reason'
  "Plug 'Yggdroot/indentLine'
  "Plug 'gabesoft/vim-ags'
  "Plug 'mattn/emmet-vim'
  "Plug 'wellle/targets.vim'
  "Plug 'danro/rename.vim'
  "Plug 'exu/pgsql.vim'
  Plug 'chrisbra/Colorizer'
  Plug 'scalameta/nvim-metals'
  Plug 'hrsh7th/nvim-compe'
call plug#end()
