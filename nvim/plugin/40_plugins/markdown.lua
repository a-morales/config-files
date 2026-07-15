vim.pack.add({
  gh("MeanderingProgrammer/render-markdown.nvim"),
  gh("nvim-treesitter/nvim-treesitter"),
  gh("nvim-mini/mini.nvim"),
  gh("yousefhadder/markdown-plus.nvim"),
  gh("iwe-org/iwe.nvim")
})

require("render-markdown").setup({
  completion = {
    lsp = { enabled = true },
  },
})

require("markdown-plus").setup()

require("iwe").setup()
