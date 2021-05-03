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

