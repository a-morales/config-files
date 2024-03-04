return {
  "rmehri01/onenord.nvim",
  lazy = false,
  name = "onenord",
  priority = 1000,
  config = function()
    require("onenord").setup({
      italics = {
        comments = true,
        keywords = false,
      },
    })
    vim.cmd.colorscheme("onenord")
  end,
}
