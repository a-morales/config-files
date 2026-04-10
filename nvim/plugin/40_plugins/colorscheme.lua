vim.pack.add({
  gh("rktjmp/lush.nvim"),
  gh("rmehri01/onenord.nvim"),
  gh("serhez/teide.nvim"),
  gh("neanias/everforest-nvim"),
  gh("rebelot/kanagawa.nvim"),
  gh("EdenEast/nightfox.nvim"),
  gh("shaunsingh/nord.nvim"),
  gh("olimorris/onedarkpro.nvim"),
  gh("ishan9299/nvim-solarized-lua"),
  gh("folke/tokyonight.nvim"),
  gh("zenbones-theme/zenbones.nvim"),
})

require("everforest").setup({
  background = "medium",
  transparent_background_level = 1,
  dim_inactive_windows = true,
  show_eob = true,
  ui_contrast = "high",
  on_highlights = function(hl, palette)
    hl.CurrentWord = { underline = true, bold = true }
  end,
})

vim.cmd.colorscheme("everforest")
