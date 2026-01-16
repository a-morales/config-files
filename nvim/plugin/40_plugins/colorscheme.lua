now(function()
  pack_add("rmehri01/onenord.nvim")
  pack_add("sainnhe/everforest")
  pack_add("serhez/teide.nvim")
  pack_add("rebelot/kanagawa.nvim")
  pack_add("EdenEast/nightfox.nvim")
  pack_add("shaunsingh/nord.nvim")
  pack_add("olimorris/onedarkpro.nvim")
  pack_add("ishan9299/nvim-solarized-lua")
  pack_add("folke/tokyonight.nvim")

  vim.g.everforest_background = "hard"
  vim.g.everforest_enable_italic = 1
  vim.g.everforest_dim_inactive_windows = 1
  vim.g.everforest_transparent_background = 2
  vim.cmd.colorscheme("everforest")
end)
