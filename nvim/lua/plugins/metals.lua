return {
  "scalameta/nvim-metals",
  opts = {
    tvp = {
      icons = {
        enabled = true,
      },
    },
    settings = {
      defaultBspToBuildTool = true,
      enableSemanticHighlighting = false,
      inlayHints = {
        byNameParameters = { enable = true },
        hintsInPatternMatch = { enable = true },
        implicitArguments = { enable = true },
        implicitConversions = { enable = true },
        inferredTypes = { enable = true },
        typeParameters = { enable = true },
      },
      serverVersion = "latest.snapshot",
    },
    init_options = {
      statusBarProvider = "off",
    },
    on_attach = function(client, bufnr)
      vim.keymap.set("v", "K", require("metals").type_of_range)

      local lsp_group = vim.api.nvim_create_augroup("lsp", { clear = true })
      vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost" }, {
        callback = vim.lsp.codelens.refresh,
        buffer = bufnr,
        group = lsp_group,
      })
    end,
  },
  config = function(_, opts)
    local metals = require("metals")

    local nvim_metals_group = vim.api.nvim_create_augroup("nvim-metals", { clear = true })
    local metals_config = vim.tbl_deep_extend("force", metals.bare_config(), opts)

    vim.api.nvim_create_autocmd("FileType", {
      pattern = { "scala", "sbt", "java", "sc" },
      callback = function()
        metals.initialize_or_attach(metals_config)
      end,
      group = nvim_metals_group,
    })

    vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
      pattern = { "*.worksheet.sc" },
      callback = function()
        vim.lsp.inlay_hint.enable(true)
      end,
      group = nvim_metals_group,
    })
  end,
}
