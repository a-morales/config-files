return {
  -- pass 0 as the first argument to use STDIN/STDOUT for communication
  cmd = {
    "coursier",
    "launch",
    "software.amazon.smithy:smithy-language-server:0.7.0",
    "-M",
    "software.amazon.smithy.lsp.Main",
    "--",
    "0",
  },
  filetypes = { "smithy" },
  root_markers = { "smithy-build.json", "build.gradle", "build.gradle.kts", ".git" },
  message_level = vim.lsp.protocol.MessageType.Log,
  init_options = {
    statusBarProvider = "show-message",
    isHttpEnabled = true,
    compilerOptions = {
      snippetAutoIndent = false,
    },
  },
}
