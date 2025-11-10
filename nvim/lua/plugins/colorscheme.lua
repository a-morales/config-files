return {
  {
    "rmehri01/onenord.nvim",
    lazy = false,
    name = "onenord",
    priority = 1000,
    opts = {
      borders = true,
      fade_nc = true,
    },
  },

  -- Configure LazyVim to load gruvbox
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "onenord",
    },
  },
}
