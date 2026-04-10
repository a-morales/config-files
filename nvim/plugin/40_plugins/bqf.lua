vim.pack.add({
  gh("kevinhwang91/nvim-bqf")
})

require("bqf").setup({
  preview = {
    winblend = 0,
  },
})
