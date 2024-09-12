return {
  "stevearc/conform.nvim",
  opts = {
    notify_on_error = true,
    format_on_save = {
      timeout_ms = 2000,
    },
    formatters_by_ft = {
      lua = { "stylua" },
      scala = { "scalafmt" },
      javascript = { "prettierd", "prettier" },
    },
    init = function()
      vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
    end,
  },
}
