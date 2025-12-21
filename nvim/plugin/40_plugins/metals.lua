now_if_args(function()
  pack_add("scalameta/nvim-metals")

  local metals = require("metals")
  local nvim_metals_group = vim.api.nvim_create_augroup("nvim-metals", { clear = true })

  local metals_config = vim.tbl_deep_extend("force", metals.bare_config(), {
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
      vim.keymap.set("v", "K", metals.type_of_range)
      vim.keymap.set("n", "<leader>fmc", metals.commands)
      vim.keymap.set("n", "<leader>mc", metals.compile_cascade)
      vim.keymap.set("n", "<leader>mh", function()
        metals.hover_worksheet()
      end)
      vim.keymap.set("n", "<leader>mt", require("metals.tvp").toggle_tree_view)

      vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost" }, {
        callback = vim.lsp.codelens.refresh,
        buffer = bufnr,
        group = nvim_metals_group,
      })
    end,
  })

  vim.api.nvim_create_autocmd("FileType", {
    pattern = { "scala", "sbt", "java", "sc" },
    callback = function()
      -- vim.opt_global.shortmess.remove("F")
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
end)
