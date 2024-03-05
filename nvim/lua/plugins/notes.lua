return {
  -- {
  -- "nvim-neorg/neorg",
  -- build = ":Neorg sync-parsers",
  -- lazy = false, -- specify lazy = false because some lazy.nvim distributions set lazy = true by default
  -- -- tag = "*",
  -- dependencies = { "nvim-lua/plenary.nvim" },
  -- config = function()
  --   require("neorg").setup({
  --     load = {
  --       ["core.defaults"] = {}, -- Loads default behaviour
  --       ["core.concealer"] = {}, -- Adds pretty icons to your documents
  --       ["core.dirman"] = { -- Manages Neorg workspaces
  --         config = {
  --           workspaces = {
  --             notes = "~/Documents/notes",
  --           },
  --         },
  --       },
  --     },
  --   })
  -- end,
  -- },
  {
    "epwalsh/obsidian.nvim",
    version = "*",
    lazy = true,
    ft = "markdown",
    -- Replace the above line with this if you only want to load obsidian.nvim for markdown files in your vault:
    event = {
      -- If you want to use the home shortcut '~' here you need to call 'vim.fn.expand'.
      -- E.g. "BufReadPre " .. vim.fn.expand "~" .. "/my-vault/**.md"
      "BufReadPre "
        .. vim.fn.expand("~")
        .. "/Documents/notes/**.md",
      "BufNewFile " .. vim.fn.expand("~") .. "/Documents/notes/**.md",
    },
    dependencies = {
      -- Required.
      "nvim-lua/plenary.nvim",
      -- see below for full list of optional dependencies 👇
    },
    opts = {
      workspaces = {
        {
          name = "personal",
          path = "~/Documents/notes",
        },
      },
      notes_subdir = "inbox",
      daily_notes = {
        folder = "notes/dailies",
      },
      completion = {
        nvim_cmp = true,
        min_chars = 2,
      },
      new_notes_location = "notes_subdir",
      -- wiki_link_func = "use_alias_only",
      preferred_link_style = "wiki",
      follow_url_func = true,
      picker = {
        name = "telescope.nvim",
        mappings = {
          new = "<C-x>",
          insert_link = "<C-l>",
        },
      },
      open_notes_in = "current",
    },
  },
}
