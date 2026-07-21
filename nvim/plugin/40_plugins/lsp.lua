vim.pack.add({
  gh("neovim/nvim-lspconfig"),
  gh("kosayoda/nvim-lightbulb"),
  gh("mhanberg/output-panel.nvim"),
  gh("DrKJeff16/wezterm-types"),
  gh("folke/lazydev.nvim")
})

-- LSP servers are installed outside of nvim (Homebrew for lua_ls/ts_ls/bashls,
-- Coursier for smithy_ls) and must be on PATH. Configs live in after/lsp/.
vim.lsp.enable({ "lua_ls", "ts_ls", "smithy_ls", "bashls", "rust_analyzer" })

vim.api.nvim_create_user_command("LspLog", function()
  vim.cmd.tabnew(vim.lsp.log.get_filename())
end, { desc = "Open the Nvim LSP client log" })

require("output_panel").setup({
  max_buffer_size = 5000
})

require("lazydev").setup({
  library = {
    { path = "${3rd}/luv/library", words = { "vim%.uv" } },
    { path = "wezterm-types",      mods = { "wezterm" } },
  }
})

require("nvim-lightbulb").setup({
  autocmd = {
    enabled = true,
  },
  sign = {
    text = "",
    lens_text = "",
  },
})
