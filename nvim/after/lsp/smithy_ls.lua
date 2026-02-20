return {
  cmd = {
    "smithy-language-server",
    "--port",
    "0",
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
