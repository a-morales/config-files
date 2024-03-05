return {
  "rmehri01/onenord.nvim",
  lazy = false,
  name = "onenord",
  priority = 1000,
  config = function()
    require("onenord").setup({
      fade_nc = true,
    })
    vim.cmd.colorscheme("onenord")
  end,
}
