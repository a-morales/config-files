vim.pack.add({ 
  gh("MunifTanjim/nui.nvim"),
  gh("esmuellert/codediff.nvim"),
  gh("lewis6991/gitsigns.nvim"),
  gh("m00qek/baleia.nvim"),
  gh("NeogitOrg/neogit")
})

require("gitsigns").setup()

-- TODO: configure this more
require("codediff").setup()

require("neogit").setup()
