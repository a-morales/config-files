now(function()
  pack_add("rmehri01/onenord.nvim")
  pack_add("sainnhe/everforest")
  vim.g.everforest_background = "hard"
  vim.g.everforest_enable_italic = 1
  vim.g.everforest_dim_inactive_windows = 1
  vim.cmd.colorscheme("everforest")
end)
