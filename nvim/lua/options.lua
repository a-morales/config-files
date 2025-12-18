vim.o.mouse = "a" -- Enable mouse
vim.o.switchbuf = "usetab" -- Use already opened buffers when switching
vim.o.undofile = true -- Enable persistent undo
--
vim.o.shada = "'100,<50,s10,:1000,/100,@100,h" -- Limit ShaDa file (for startup)
--
-- -- Enable all filetype plugins and syntax (if not enabled, for better startup)
vim.cmd("filetype plugin indent on")
vim.cmd("syntax enable")
--
-- -- UI =========================================================================
-- vim.o.breakindent = true -- Indent wrapped lines to match line start
-- vim.o.breakindentopt = "list:-1" -- Add padding for lists (if 'wrap' is set)
-- vim.o.colorcolumn = "+1" -- Draw column on the right of maximum width
-- vim.o.cursorline = true -- Enable current line highlighting
-- vim.o.linebreak = true -- Wrap lines at 'breakat' (if 'wrap' is set)
-- vim.o.list = true -- Show helpful text indicators
-- vim.o.number = true -- Show line numbers
vim.o.pumheight = 5 -- Make popup menu smaller
-- vim.o.ruler = false -- Don't show cursor coordinates
-- vim.o.shortmess = "CFOSWaco" -- Disable some built-in completion messages
-- vim.o.showmode = false -- Don't show mode in command line
vim.o.signcolumn = "yes" -- Always show signcolumn (less flicker)
vim.o.splitbelow = true -- Horizontal splits will be below
vim.o.splitkeep = "screen" -- Reduce scroll during window split
vim.o.splitright = true -- Vertical splits will be to the right
vim.o.winborder = "single" -- Use border in floating windows vim.o.winborder = "single" -- Use border in floating windows
vim.o.wrap = false -- Don't visually wrap lines (toggle with \w)
vim.opt.clipboard = "unnamedplus"
--
-- vim.o.cursorlineopt = "screenline,number" -- Show cursor line per screen line
--
-- -- Special UI symbols. More is set via 'mini.basics' later.
vim.o.fillchars = "eob: ,fold:╌"
vim.o.listchars = "extends:…,nbsp:␣,precedes:…,tab:> "
--
-- Folds (see `:h fold-commands`, `:h zM`, `:h zR`, `:h zA`, `:h zj`)
vim.o.foldlevel = 10 -- Fold nothing by default; set to 0 or 1 to fold
vim.o.foldmethod = "indent" -- Fold based on indent level
vim.o.foldnestmax = 10 -- Limit number of fold levels
vim.o.foldtext = "" -- Show text under fold with its highlighting
--
-- -- Editing ====================================================================
vim.o.autoindent = true -- Use auto indent
vim.o.expandtab = true -- Convert tabs to spaces
vim.o.shiftwidth = 2 -- Use this number of spaces for indentation
vim.o.tabstop = 2 -- Show tab as this number of spaces

-- vim.o.formatoptions = "rqnl1j" -- Improve comment editing
-- vim.o.ignorecase = true -- Ignore case during search
-- vim.o.incsearch = true -- Show search matches while typing
-- vim.o.infercase = true -- Infer case in built-in completion
-- vim.o.smartcase = true -- Respect case if search pattern has upper case
-- vim.o.smartindent = true -- Make indenting smart
-- vim.o.spelloptions = "camel" -- Treat camelCase word parts as separate words
-- vim.o.virtualedit = "block" -- Allow going past end of line in blockwise mode
--
-- vim.o.iskeyword = "@,48-57,_,192-255,-" -- Treat dash as `word` textobject part
--
-- -- Pattern for a start of numbered list (used in `gw`). This reads as
-- -- "Start of list item is: at least one special character (digit, -, +, *)
-- -- possibly followed by punctuation (. or `)`) followed by at least one space".
-- vim.o.formatlistpat = [[^\s*[0-9\-\+\*]\+[\.\)]*\s\+]]
--
-- -- Built-in completion
-- vim.o.complete = ".,w,b,kspell" -- Use less sources
-- vim.o.completeopth= "menuone,noselect,fuzzy,nosort" -- Use custom behavior
vim.o.laststatus = 3
vim.opt.syntax = "on"
vim.opt.encoding = "UTF-8"
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.hidden = true
vim.opt.joinspaces = false
vim.opt.scrolloff = 4
vim.opt.shiftround = true
vim.opt.sidescrolloff = 8
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.termguicolors = true
vim.opt.background = "dark"
vim.opt.wildmode = "list:longest"
vim.opt.clipboard = "unnamedplus"
vim.opt.smarttab = true
vim.opt.backup = false
vim.opt.writebackup = false
vim.opt.listchars = { tab = "→ ", trail = "·", extends = "❯", precedes = "❮" }
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.autoindent = true
vim.opt.swapfile = false
vim.opt.list = true
vim.opt.number = true
vim.opt.wrap = false
vim.opt.mouse = "a"
vim.opt.cursorline = true
vim.opt.timeoutlen = 350
vim.opt.signcolumn = "yes"
vim.opt.updatetime = 250
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.inccommand = "split"
vim.opt.scrolloff = 10
vim.opt.hlsearch = true
vim.opt.conceallevel = 1
vim.opt.showmode = false
vim.opt.breakindent = true
vim.opt.laststatus = 3
