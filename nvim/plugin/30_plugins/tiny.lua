pack_add("rachartier/tiny-inline-diagnostic.nvim")

require("tiny-inline-diagnostic").setup({
  preset = "simple",
  options = {
    show_source = {
      if_many = true,
    },
    use_icons_from_diagnostic = true,
  },
})
