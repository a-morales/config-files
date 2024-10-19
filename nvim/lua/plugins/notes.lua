return {
  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    ft = "markdown",
    enabled = true,
    build = function()
      vim.fn["mkdp#util#install"]()
    end,
  },
  {
    "tadmccorkle/markdown.nvim",
    ft = "markdown",
    -- enabled = false,
    config = function()
      require("markdown").setup()
    end,
  },
  {
    "OXY2DEV/markview.nvim",
    ft = "markdown",
    dependencies = {
      -- You may not need this if you don't lazy load
      -- Or if the parsers are in your $RUNTIMEPATH
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons",
    },
    config = function()
      require("markview").setup({
        modes = { "n", "c" },
        hybrid_modes = { "n" },

        callbacks = {
          on_enable = function(_, win)
            vim.wo[win].conceallevel = 2
            -- This will prevent Tree-sitter concealment being disabled on the cmdline mode
            vim.wo[win].concealcursor = "c"
          end,
        },
      })
    end,
  },
}
