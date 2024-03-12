return {
  "echasnovski/mini.nvim",
  config = function()
    require("mini.ai").setup({ nlines = 500 })
    require("mini.surround").setup()
    require("mini.pairs").setup()
  end,
}
