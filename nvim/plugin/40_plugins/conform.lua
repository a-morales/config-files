vim.pack.add({
  gh("stevearc/conform.nvim")
})

require("conform").setup({
  notify_on_error = false,
  notify_no_formatters = false,
  formatters_by_ft = {
    json = { "prettier" },
    lua = { "stylua" },
    markdown = { "prettier_md" },
    ["markdown.mdx"] = { "prettier_md" },
    yaml = { "prettier" },
    -- No formatter so conform defers to the LSP (metals) via lsp_format = "fallback".
    -- Must be a function rather than `{}`, since an empty table falls through to the "_" entry below.
    scala = function()
      return {}
    end,
    bash = { "shfmt" },
    ["_"] = { "trim_whitespace" },
  },
  format_on_save = {
    timeout_ms = 500,
    lsp_format = "fallback",
  },
  formatters = {
    prettier = { require_cwd = true },
    -- same prettier binary, but runs regardless of project cwd/config
    prettier_md = vim.tbl_deep_extend("force", require("conform.formatters.prettier"), {
      require_cwd = false,
    }),
  },
})

vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
