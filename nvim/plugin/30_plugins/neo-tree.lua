pack_add({
  source = "nvim-neo-tree/neo-tree.nvim",
  depends = {
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
  },
})

require("neo-tree").setup({
  filesystem = {
    filtered_items = {
      hide_dotfiles = false,
      hide_by_name = {
        ".git",
      },
    },
  },
})
