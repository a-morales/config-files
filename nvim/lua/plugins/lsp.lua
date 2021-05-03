local nvim_lsp = require("lspconfig")

require('lspsaga').init_lsp_saga({
  code_action_prompt = {
    enable = true,
    virtual_text = true,
    sign = true,
  },
  server_filetype_map = { metals = { 'sbt', 'scala' }}
})

require('trouble').setup({
})

Keybind.global({
  { 'n', 'gh', [[:Lspsaga lsp_finder<CR>]]},
  { 'n', 'gd', [[:Lspsaga preview_definition<CR>]]},
  { 'n', 'gs', [[:Lspsaga signature_help<CR>]]},
  { 'n', 'gr', [[:Lspsaga rename<CR>]]},
  { 'n', 'ca', [[:Lspsaga code_action<CR>]]},
  { 'n', 'K',  [[:Lspsaga hover_doc<CR>]] },
  { 'n', 'tx', [[:LspTroubleToggle<CR>]]},
})


nvim_lsp.tsserver.setup {
  on_attach = function(client)
    client.resolved_capabilities.document_formatting = false
    on_attach(client)
  end
}

local filetypes = {
    typescript = "eslint",
    typescriptreact = "eslint",
}
local linters = {
    eslint = {
        sourceName = "eslint",
        command = "eslint",
        rootPatterns = {".eslintrc.js", "package.json"},
        debounce = 100,
        args = {"--stdin", "--stdin-filename", "%filepath", "--format", "json"},
        parseJson = {
            errorsRoot = "[0].messages",
            line = "line",
            column = "column",
            endLine = "endLine",
            endColumn = "endColumn",
            message = "${message} [${ruleId}]",
            security = "severity"
        },
        securities = {[2] = "error", [1] = "warning"}
    }
}
local formatters = {
    prettier = {command = "prettier", args = {"--stdin-filepath", "%filepath"}}
}
local formatFiletypes = {
    typescript = "prettier",
    typescriptreact = "prettier"
}
nvim_lsp.diagnosticls.setup {
    on_attach = on_attach,
    filetypes = vim.tbl_keys(filetypes),
    init_options = {
        filetypes = filetypes,
        linters = linters,
        formatters = formatters,
        formatFiletypes = formatFiletypes
    }
}
