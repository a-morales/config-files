-- Set Colorscheme
vim.cmd[[colorscheme onenord]]

require('onenord').setup({
  italics = {
    comments = true,
    keywords = false,
  }
})


-- LSP settings
local lsp = require('lspconfig')
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)

local on_attach = function(client, bufnr)
  require("lsp_signature").on_attach()

  nnoremap('gD', '<cmd>lua vim.lsp.buf.declaration()<CR>')
  nnoremap('gd', '<cmd>lua vim.lsp.buf.definition()<CR>')
  nnoremap('gr', '<cmd>lua vim.lsp.buf.references()<CR>')
  nnoremap('gi', '<cmd>lua vim.lsp.buf.implementation()<CR>')
  nnoremap('K', '<cmd>lua vim.lsp.buf.hover()<CR>')
  nnoremap('<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>')
  nnoremap('<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>')
  nnoremap('<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>')
  nnoremap('<space>f', '<cmd>lua vim.lsp.buf.formatting()<CR>')
end

local cmp = require('cmp')
cmp.setup {
  mapping = {
    ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
    ['<CR>'] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = true
    },
    ['<Tab>'] = function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      else
        fallback()
      end
    end,
    ['<S-Tab>'] = function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      else
        fallback()
      end
    end
  },
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'buffer' }
  })
}

local servers = { 'tsserver' }
for _, server in ipairs(servers) do
  lsp[server].setup{
    capabilities = capabilities,
    on_attach = on_attach
  }
end

-- Scala Metals

vim.g['metals_server_version']='0.10.9'

vim.cmd([[autocmd!]])
vim.cmd([[autocmd FileType scala setlocal omnifunc=v:lua.vim.lsp.omnifunc]])
vim.cmd([[autocmd FileType scala,sbt lua require("metals").initialize_or_attach(metals_config)]])
vim.cmd([[augroup end]])

vim.cmd([[hi! link LspReferenceText CursorColumn]])
vim.cmd([[hi! link LspReferenceRead CursorColumn]])
vim.cmd([[hi! link LspReferenceWrite CursorColumn]])
vim.cmd([[hi! link LspCodeLens CursorColumn]])
vim.cmd([[hi! link LspReferenceText CursorColumn]])
vim.cmd([[hi! link LspReferenceRead CursorColumn]])
vim.cmd([[hi! link LspReferenceWrite CursorColumn]])

metals_config = require("metals").bare_config()

metals_config.settings = {
  showImplicitArguments = true,
}

metals_config.capabilities = capabilities
metals_config.on_attach = on_attach

-- Editor UI
require('gitsigns').setup()
require('nvim-autopairs').setup{}
require('nvim-treesitter.configs').setup {
  autotag = {
    enable = true,
  }
}

require("indent_blankline").setup {
    space_char_blankline = " ",
    show_current_context = true,
}

require('hop').setup {
  keys = 'etovxqpdygfblzhckisuran'
}
