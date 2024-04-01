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
    enabled = true,
    config = function()
      require("markdown").setup()
    end,
  },
}
