vim.pack.add({ gh("folke/lazydev.nvim") })

require("lazydev").setup({
  library = {
    { path = "${3rd}/luv/library", words = { "vim%.uv" } },
  },
})
