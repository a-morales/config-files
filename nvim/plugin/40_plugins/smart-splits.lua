vim.pack.add({
  {
    -- src = local_pack("Code/smart-splits/smart-splits.nvim"),
    src = gh("smart-splits-nvim/smart-splits.nvim"),
    version = "v3",
  },
  gh("smart-splits-nvim/backend-wezterm"),
})

require("smart-splits").setup({
  mux = {
    backend = "smart-splits-backend-wezterm",
  },
})
