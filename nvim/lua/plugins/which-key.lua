return {
  "folke/which-key.nvim",
  opts = {
    preset = "helix",
    notify = true,
    sort = { "desc" },
  },
  init = function()
    local wk = require("which-key")
    wk.add({
      { "<leader>s", group = "Search" },
      -- { "<leader>h", group = "Hunks", icon = { icon = "", color = "red" } },
      -- { "<leader>l", group = "Lsp", icon = { icon = "", color = "blue" } },
    })
  end,
}
