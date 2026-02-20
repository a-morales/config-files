pack_add({
  source = "esmuellert/codediff.nvim",
  depends = { "MunifTanjim/nui.nvim" },
})

-- TODO: configure this more
require("codediff").setup()
