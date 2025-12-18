return {
  "stevearc/conform.nvim",
  opts = {
    notify_on_error = false,
    notify_no_formatters = false,
    formatters_by_ft = {
      json = { "prettier", name = "dprint", timeout_ms = 500, lsp_format = "fallback" },
      lua = { "stylua" },
      yaml = { "prettier" },
      scala = { "scala" },
    },
    format_on_save = {
      timeout_ms = 500,
      lsp_format = "fallback",
    },
    formatters = {
      prettier = { require_cwd = true },
    },
  },
  init = function()
    vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
  end,
}
