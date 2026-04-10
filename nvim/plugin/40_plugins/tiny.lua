vim.pack.add({ gh("rachartier/tiny-inline-diagnostic.nvim") })
-- pack_add("rachartier/tiny-cmdline.nvim")

require("tiny-inline-diagnostic").setup({
  preset = "simple",
  options = {
    show_source = {
      if_many = true,
    },
    use_icons_from_diagnostic = true,
  },
})

-- require("tiny-cmdline").setup()
-- on_reposition = require("tiny-cmdline").adapters.blink,
-- )
