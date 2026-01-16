now_if_args(function()
  pack_add({
    source = "neovim/nvim-lspconfig",
    depends = {
      "mason-org/mason.nvim",
      "mason-org/mason-lspconfig.nvim",
      "kosayoda/nvim-lightbulb",
    },
  })
  require("mason").setup()

  require("mason-lspconfig").setup({
    ensure_installed = { "lua_ls", "ts_ls", "smithy_ls", "bashls" },
    automatic_enable = true,
  })

  require("nvim-lightbulb").setup({
    autocmd = { enabled = true },
  })
end)
