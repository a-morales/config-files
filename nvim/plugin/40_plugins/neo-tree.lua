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
  window = {
    mappings = {
      -- Map "Y" to copy the absolute path to the system clipboard
      ["Y"] = function(state)
        local node = state.tree:get_node()
        local path = node:get_id()          -- This returns the full absolute path
        vim.fn.setreg("+", path)            -- Write to system clipboard register
        vim.notify("Copied path: " .. path) -- Optional notification
      end,
    }
  }
})
