-- local cmd = vim.cmd
-- local g = vim.g

----------------------------------
-- OPTIONS -----------------------
----------------------------------
-- global
opt('o', 'completeopt', 'menuone,noinsert,noselect')
vim.o.shortmess = string.gsub(vim.o.shortmess, 'F', '') .. 'c'

-- LSP
Keybind.global({
	{ 'n', '<leader>g', '<cmd>lua vim.lsp.buf.definition()<CR>', {nowait = true} },
	-- { 'n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>' },
	{ 'n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>' },
	{ 'n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>' },
	{ 'n', 'gds', '<cmd>lua vim.lsp.buf.document_symbol()<CR>' },
	{ 'n', 'gws', '<cmd>lua vim.lsp.buf.workspace_symbol()<CR>' },
	{ 'n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>' },
	{ 'n', '<leader>f', '<cmd>lua vim.lsp.buf.formatting()<CR>' },
	-- { 'n', 'ca', '<cmd>lua vim.lsp.buf.code_action()<CR>' },
	{ 'n', '<leader>ws', '<cmd>lua require"metals".worksheet_hover()<CR>' },
	{ 'n', '<leader>a', '<cmd>lua require"metals".open_all_diagnostics()<CR>' },
	{ 'n', '<leader>d', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>' }, -- buffer diagnostics only
	{ 'n', '[c', '<cmd>lua vim.lsp.diagnostic.goto_prev { wrap = false }<CR>' },
	{ 'n', ']c', '<cmd>lua vim.lsp.diagnostic.goto_next { wrap = false }<CR>' },
})

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
    orgmode = true;
  };
}

map('i', '<S-Tab>', 'pumvisible() ? "\\<C-p>" : "\\<Tab>"', {expr = true})
map('i', '<Tab>', 'pumvisible() ? "\\<C-n>" : "\\<Tab>"', {expr = true})
map('i', '<CR>', 'compe#confirm("\\<CR>")', {expr = true})

----------------------------------
-- COMMANDS ----------------------
----------------------------------

-- Need for symbol highlights to work correctly
cmd [[hi! link LspReferenceText CursorColumn]]
cmd [[hi! link LspReferenceRead CursorColumn]]
cmd [[hi! link LspReferenceWrite CursorColumn]]
----------------------------------
-- LSP Setup ---------------------
----------------------------------
metals_config = require'metals'.bare_config
metals_config.init_options.statusBarProvider = 'on'

-- Example of settings
metals_config.settings = {
  showImplicitArguments = true,
  showInferredType = true,
  excludedPackages = {'akka.actor.typed.javadsl', 'com.github.swagger.akka.javadsl'},
        
}

-- Example of how to ovewrite a handler
metals_config.handlers['textDocument/publishDiagnostics'] =
    vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {virtual_text = {prefix = ''}})

-- Example if you are including snippets
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

metals_config.capabilities = capabilities

-- LSP
cmd [[augroup lsp]]
cmd [[autocmd!]]
cmd [[autocmd FileType scala setlocal omnifunc=v:lua.vim.lsp.omnifunc]]
cmd [[autocmd FileType scala,sbt lua require("metals").initialize_or_attach(metals_config)]]
cmd [[augroup end]]
