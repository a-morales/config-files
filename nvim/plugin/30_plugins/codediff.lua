pack_add({
  source = "esmuellert/codediff.nvim",
  depends = { "MunifTanjim/nui.nvim" },
})

require("codediff").setup()
