-- plugins to try at some point
-- https://github.com/jakewvincent/mkdnflow.nvim
return {
  "tpope/vim-sleuth", -- Detect tabstop and shiftwidth automatically
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    opts = {},
    config = function()
      require("ibl").setup()
    end,
  },
  -- to try:
  -- https://github.com/preservim/vim-pencil
}
