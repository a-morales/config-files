pack_add("rmehri01/onenord.nvim")
pack_add("serhez/teide.nvim")
pack_add("neanias/everforest-nvim")
pack_add("rebelot/kanagawa.nvim")
pack_add("EdenEast/nightfox.nvim")
pack_add("shaunsingh/nord.nvim")
pack_add("olimorris/onedarkpro.nvim")
pack_add("ishan9299/nvim-solarized-lua")
pack_add("folke/tokyonight.nvim")
pack_add({
  source = "zenbones-theme/zenbones.nvim",
  depends = {
    "rktjmp/lush.nvim",
  },
})

require("everforest").setup({
  background = "medium",
  transparent_background_level = 1,
  dim_inactive_windows = true,
  show_eob = true,
  on_highlights = function(hl, palette)
    hl.CurrentWord = { underline = true, bold = true }
  end,
})

vim.cmd.colorscheme("everforest")
