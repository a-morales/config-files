pack_add({
  source = "TheNoeTrevino/haunt.nvim",
  depends = { "ibhagwan/fzf-lua" },
})

require("haunt").setup({
  picker = "fzf",
  picker_keys = {
    delete = {
      key = "<C-x>",
    },
    edit_annotation = {
      key = "<C-e>",
    },
  },
})

local haunt = require("haunt.api")

vim.api.nvim_create_user_command("HauntToggleAll", function()
  haunt.toggle_all_lines()
end, { desc = "Toggle Bookmarks" })
