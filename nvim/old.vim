filetype off

source ~/.config/nvim/modules/plugins.vim
source ~/.config/nvim/modules/settings.vim
source ~/.config/nvim/modules/coc.vim
source ~/.config/nvim/modules/metals.vim
source ~/.config/nvim/modules/autocommands.vim

" Leader
let mapleader = " "

" Themes and Colors

set termguicolors
set background=dark
let g:hybrid_custom_term_colors = 1
let g:hybrid_reduced_contrast = 1
colorscheme hybrid

let g:javascript_plugin_jsdoc = 1
let g:javascript_plugin_flow = 1

if !empty(&viminfo)
  set viminfo^=!
endif

"custom functions

function! NumberToggle()
  if(&relativenumber == 1)
    set norelativenumber
    set number
  else
    set relativenumber
  endif
endfunc


" Keyboard Shortcuts

"disable the arrow keys
noremap <Up> <NOP>
noremap <Down> <NOP>
noremap <Left> <NOP>
noremap <Right> <NOP>
inoremap <up> <nop>
inoremap <down> <nop>
inoremap <left> <nop>
inoremap <right> <nop>

"go to matching brace
nnoremap <tab> %
vnoremap <tab> %

"allows vertical movements one row at a time instead of one line at a time
nnoremap j gj
nnoremap k gk

" Leader Shortcuts

"clear highlighted words from search
nnoremap <leader><space> :noh<cr>

"shortcuts to open edit window on current file path
cnoremap %% <C-R>=fnameescape(expand('%:h')).'/'<cr>
map <leader>ew :e %%
map <leader>es :sp %%
map <leader>ev :vsp %%
map <leader>et :tabe %%
map <leader>mk :!mkdir %%

map <leader>c "*y
map <leader>v "*p

map <leader>r :windo redraw!<cr>
map <leader>R :so $MYVIMRC<cr>

nmap <leader>ts "=strftime("%Y-%m-%d %H:%M")<CR>p
nnoremap <leader>n :call NumberToggle()<cr>

" Plugin Settings

"indent line
let indentLine_char = '│'

" lighline functions
function! FugitiveLightLine()
  if exists("*fugitive#head")
    let _ = fugitive#head()
    return strlen(_) ? '⭠ '._ : ''
  endif
endfunction

let g:tender_lightline = 1
let g:lightline = {
  \ 'colorscheme': 'one',
  \ 'active': {
  \   'left': [ ['mode'], ['fugitive', 'filename', 'modified']],
  \   'right': [ ['lineinfo'], ['percent'], ['fileformat', 'fileencoding', 'filetype']]
  \ },
  \ 'separator': { 'left': '', 'right': '' },
  \ 'subseparator': { 'left': '', 'right': '' },
  \ 'component_function': {
  \   'fugitive': 'FugitiveLightLine'
  \ }
\}

let g:qs_highlight_on_keys = ['f', 'F', 't', 'T']

let g:ags_enable_async=1
let g:ags_winheight='30'

let g:fzf_action = {'ctrl-s': 'split', 'ctrl-v': 'vsplit'}
let g:fzf_layout = {'down': '~20%'}
let g:fzf_nvim_statusline = 0

let g:deoplete#enable_at_startup=1
let g:deoplete#file#enable_buffer_path=1

let g:deoplete#sources = {}
let g:deoplete#sources._ = ['buffer', 'file']

let g:fzf_layout = {'up':'~90%', 'window': { 'width': 0.8, 'height': 0.4,'yoffset':0.0,'xoffset': 0.5, 'highlight': 'Todo', 'border': 'sharp' } }
command! -bang -nargs=? -complete=dir Files
    \ call fzf#vim#files(<q-args>, fzf#vim#with_preview({'options': ['--layout=reverse', '--info=inline']}), <bang>0)

nnoremap <C-p> :Files<cr>
nnoremap <C-space> :Buffers<cr>
nnoremap <leader>ag :Ag<CR>

let g:fzf_colors =
\ { 'fg':      ['fg', 'Normal'],
  \ 'bg':      ['bg', 'Normal'],
  \ 'hl':      ['fg', 'Comment'],
  \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
  \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
  \ 'hl+':     ['fg', 'Statement'],
  \ 'info':    ['fg', 'PreProc'],
  \ 'border':  ['fg', 'Ignore'],
  \ 'prompt':  ['fg', 'Conditional'],
  \ 'pointer': ['fg', 'Exception'],
  \ 'marker':  ['fg', 'Keyword'],
  \ 'spinner': ['fg', 'Label'],
  \ 'header':  ['fg', 'Comment'] }

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

if has('linebreak')
  set breakindent
  let &showbreak = '↳'
  set cpo+=n
end

nmap =j :%!python -m json.tool<CR>:set filetype=json<CR>

set iskeyword-=/
set conceallevel=2

let g:tex_conceal = ""

let g:jsx_ext_required = 0

let g:sql_type_default = 'pgsql'

let g:gitgutter_realtime = 0
let g:gitgutter_eager = 0
let g:vim_markdown_folding_disabled = 1

" set clipboard+=unnamed

  " local nvim_lsp = require("lspconfig")
  " local on_attach = function(_, bufnr)
  "   vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
  "   require'diagnostic'.on_attach()
  "   require'completion'.on_attach()

  "   -- Mappings.
  "   local opts = { noremap=true, silent=true }
  "   vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  "   vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
  "   vim.api.nvim_buf_set_keymap(bufnr, 'n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
  "   vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  "   vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gk', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  "   vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  "   vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  "   vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  "   vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>e', '<cmd>lua vim.lsp.util.show_line_diagnostics()<CR>', opts)
  " end

  " local servers = {'diagnosticls', 'vimls'}
  " for _, lsp in ipairs(servers) do
  "   nvim_lsp[lsp].setup {
  "     on_attach = on_attach,
  "   }
  " end

lua << EOF
-------------------------------------------------------------------------------
-- These are example settings to use with nvim-metals and the nvim built in
-- LSP. Be sure to thoroughly read the the `:help nvim-metals` docs to get an
-- idea of what everything does.
--
-- The below configuration also makes use of the following plugins besides
-- nvim-metals, and therefore a bit opinionated:
--
-- - https://github.com/hrsh7th/nvim-compe
--    (needs hrsh7th/vim-vsnip) for snippet support
-- - https://github.com/wbthomason/packer.nvim for package management
-------------------------------------------------------------------------------
local cmd = vim.cmd
local g = vim.g

local function opt(scope, key, value)
  local scopes = {o = vim.o, b = vim.bo, w = vim.wo}
  scopes[scope][key] = value
  if scope ~= 'o' then
    scopes['o'][key] = value
  end
end

local function map(mode, lhs, rhs, opts)
  local options = {noremap = true}
  if opts then
    options = vim.tbl_extend('force', options, opts)
  end
  vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

----------------------------------
-- PLUGINS -----------------------
----------------------------------
--cmd [[packadd packer.nvim]]
--require('packer').startup(function(use)
  --use {'wbthomason/packer.nvim', opt = true}

  --use {'hrsh7th/nvim-compe', requires = {{'hrsh7th/vim-vsnip'}}}
  --use 'scalameta/nvim-metals'

--end)
----------------------------------
-- VARIABLES ---------------------
----------------------------------
-- nvim-metals
g['metals_server_version'] = '0.9.8+43-e729533a-SNAPSHOT'

----------------------------------
-- OPTIONS -----------------------
----------------------------------
-- global
opt('o', 'completeopt', 'menuone,noinsert,noselect')
vim.o.shortmess = string.gsub(vim.o.shortmess, 'F', '') .. 'c'

-- LSP
map('n', '<leader>g', '<cmd>lua vim.lsp.buf.definition()<CR>', {nowait = true})
map('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>')
map('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>')
map('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>')
map('n', 'gds', '<cmd>lua vim.lsp.buf.document_symbol()<CR>')
map('n', 'gws', '<cmd>lua vim.lsp.buf.workspace_symbol()<CR>')
map('n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>')
map('n', '<leader>f', '<cmd>lua vim.lsp.buf.formatting()<CR>')
map('n', '<leader>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>')
map('n', '<leader>ws', '<cmd>lua require"metals".worksheet_hover()<CR>')
map('n', '<leader>a', '<cmd>lua require"metals".open_all_diagnostics()<CR>')
map('n', '<leader>d', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>') -- buffer diagnostics only
map('n', '[c', '<cmd>lua vim.lsp.diagnostic.goto_prev { wrap = false }<CR>')
map('n', ']c', '<cmd>lua vim.lsp.diagnostic.goto_next { wrap = false }<CR>')

-- completion
-- This is just copied from the docs, edit to your liking
require'compe'.setup {
  enabled = true;
  autocomplete = true;
  debug = false;
  min_length = 1;
  preselect = 'enable';
  throttle_time = 80;
  source_timeout = 200;
  incomplete_delay = 400;
  allow_prefix_unmatch = false;

  source = {
    path = true;
    buffer = true;
    calc = true;
    vsnip = true;
    nvim_lsp = true;
    nvim_lua = true;
    spell = true;
    tags = true;
    snippets_nvim = true;
  };
}

map('i', '<S-Tab>', 'pumvisible() ? "\\<C-p>" : "\\<Tab>"', {expr = true})
map('i', '<Tab>', 'pumvisible() ? "\\<C-n>" : "\\<Tab>"', {expr = true})
map('i', '<CR>', 'compe#confirm("\\<CR>")', {expr = true})

----------------------------------
-- COMMANDS ----------------------
----------------------------------
-- LSP
cmd [[augroup lsp]]
cmd [[autocmd!]]
cmd [[autocmd FileType scala setlocal omnifunc=v:lua.vim.lsp.omnifunc]]
cmd [[autocmd FileType scala,sbt lua require("metals").initialize_or_attach(metals_config)]]
cmd [[augroup end]]

-- Need for symbol highlights to work correctly
vim.cmd [[hi! link LspReferenceText CursorColumn]]
vim.cmd [[hi! link LspReferenceRead CursorColumn]]
vim.cmd [[hi! link LspReferenceWrite CursorColumn]]
----------------------------------
-- LSP Setup ---------------------
----------------------------------
metals_config = require'metals'.bare_config

-- Example of settings
metals_config.settings = {
  showImplicitArguments = true,
  excludedPackages = {'akka.actor.typed.javadsl', 'com.github.swagger.akka.javadsl'}
}

-- Example of how to ovewrite a handler
metals_config.handlers['textDocument/publishDiagnostics'] =
    vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {virtual_text = {prefix = ''}})

-- Example if you are including snippets
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

metals_config.capabilities = capabilities
EOF
let g:diagnostic_enable_virtual_text = 1
let g:completion_enable_fuzzy_match = 1
let g:completion_enable_auto_popup = 1
let g:completion_confirm_key = ""

set completeopt=menuone,noinsert,noselect
nnoremap <leader>y :let @+=expand("%") . ':' . line(".")<CR>

nmap <silent> <leader>tn :TestNearest<CR>
nmap <silent> <leader>tf :TestFile<CR>
nmap <silent> <leader>tl :TestLast<CR>
nmap <silent> <leader>tv :TestVisit<CR>

let test#strategy = "vimux"

highlight CodiVirtualText guifg=cyan

let g:codi#virtual_text_prefix = "❯ "

if has('nvim-0.5')
  augroup lsp
    au!
    au FileType scala,sbt lua require('metals').initialize_or_attach(metals_config)
  augroup end
endif
