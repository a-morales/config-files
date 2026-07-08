local config = {
  -- No port arg: the server prefers (and recommends) stdin/stdout, and the
  -- positional port is deprecated.
  -- cmd = { "smithy-language-server" },
  cmd = {
    "/Users/amorales/Code/disney/smithy-language-server/main/build/image/smithy-language-server-darwin-aarch64/bin/smithy-language-server"
  },
  filetypes = { "smithy" },
  root_markers = { "smithy-build.json", "build.gradle", "build.gradle.kts", ".git" },
  message_level = vim.lsp.protocol.MessageType.Log,
  init_options = {
    statusBarProvider = "show-message",
    isHttpEnabled = true,
    compilerOptions = {
      snippetAutoIndent = true,
    },
  },
}

-- `smithy-build.json` keeps filetype `json` (so JSON highlighting/tooling still
-- works), so `vim.lsp.enable` won't auto-start the server for it. Start it
-- manually for just that file. `vim.lsp.start` dedups by name + root_dir, so it
-- reuses the client already started for `.smithy` files in the same project.
vim.api.nvim_create_autocmd({ "BufReadPost", "BufNewFile" }, {
  pattern = {"smithy-build.json", ".smithy-project.json"},
  callback = function(args)
    vim.lsp.start(vim.tbl_extend("force", config, {
      name = "smithy_ls",
      root_dir = vim.fs.root(args.buf, config.root_markers),
    }))
  end,
})

return config
