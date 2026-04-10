vim.pack.add({
  gh("neovim/nvim-lspconfig"),
  gh("mason-org/mason.nvim"),
  gh("mason-org/mason-lspconfig.nvim"),
  gh("kosayoda/nvim-lightbulb"),
})
require("mason").setup()

require("mason-lspconfig").setup({
  ensure_installed = { "lua_ls", "ts_ls", "smithy_ls", "bashls" },
  automatic_enable = true,
})

require("nvim-lightbulb").setup({
  autocmd = {
    enabled = true,
  },
  sign = {
    text = "",
    lens_text = "",
  },
})
