return {
  "nvim-neo-tree/neo-tree.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
  },
  keys = {
    { "<C-n>", ":Neotree filesystem reveal float<CR>" },
    { "<leader>n", ":Neotree filesystem reveal left<CR>" },
  },
}
