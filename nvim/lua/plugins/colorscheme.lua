return {
  {
    "rmehri01/onenord.nvim",
    lazy = false,
    priority = 1000,
    -- config = function()
    --   require("onenord").setup({
    --     fade_nc = true,
    --   })
    --   vim.cmd.colorscheme("onenord")
    -- end,
  },
  {
    "sainnhe/everforest",
    lazy = false,
    priority = 1000,
    config = function()
      vim.g.everforest_background = "hard"
      vim.g.everforest_enable_italic = 1
      vim.g.everforest_dim_inactive_windows = 1
      vim.cmd.colorscheme("everforest")
    end,
  },
}
