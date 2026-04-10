vim.pack.add({
  gh("nvim-lua/plenary.nvim"),
  gh("MunifTanjim/nui.nvim"),
  gh("nvim-neo-tree/neo-tree.nvim"),
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
