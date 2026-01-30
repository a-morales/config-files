vim.cmd("filetype plugin indent on")

vim.o.autoindent = true
vim.o.background = "dark"
vim.o.breakindent = true
vim.o.breakindentopt = "list:-1"
vim.o.clipboard = "unnamedplus"
vim.o.complete = ".,w,b,kspell"
vim.o.completeopt = "menuone,noselect,fuzzy,nosort,preview"
vim.o.conceallevel = 1
vim.o.cursorline = true -- TODO: view hl-CursorLine highlight to set cursorline
vim.o.encoding = "UTF-8"
vim.o.expandtab = true
vim.o.fillchars = "eob:~,fold:╌"
vim.o.foldlevel = 10
vim.o.foldmethod = "manual"
vim.o.foldnestmax = 10
vim.o.foldtext = ""
vim.o.formatoptions = "rqnl1j"
vim.o.hlsearch = true
vim.o.ignorecase = true
vim.o.inccommand = "split"
vim.o.incsearch = true
vim.o.infercase = true
vim.o.iskeyword = "@,48-57,_,192-255,-"
vim.o.laststatus = 3
vim.o.linebreak = true
vim.o.list = true
vim.o.listchars = "extends:❯,nbsp:␣,precedes:❮,tab:→ ,trail:·"
vim.o.number = true
vim.o.pumheight = 5
vim.o.ruler = false
vim.o.scrolloff = 10
vim.o.shada = "'50,<50,s10,:1000,/100,@100,h"
vim.o.shiftround = true
vim.o.shiftwidth = 2
vim.o.shortmess = "CFOWaco"
vim.o.showbreak = "󱞩 "
vim.o.showmode = false
vim.o.sidescrolloff = 4
vim.o.signcolumn = "yes"
vim.o.smartcase = true
vim.o.smartindent = true
vim.o.smarttab = true
vim.o.softtabstop = 2
vim.o.splitbelow = true
vim.o.splitkeep = "screen"
vim.o.splitright = true
vim.o.swapfile = false
vim.o.switchbuf = "usetab"
vim.o.synmaxcol = 240
vim.o.syntax = "ON"
vim.o.tabstop = 2
vim.o.termguicolors = true
vim.o.timeoutlen = 250
vim.o.undofile = true
vim.o.wildmode = "list:longest"
vim.o.winborder = "rounded"
vim.o.wrap = false

-- stuff to read
-- - statuscolumn
-- - statusline
