local utils = require("utils")

vim.pack.add({
  gh("mfussenegger/nvim-dap"),
  gh("scalameta/nvim-metals"),
})

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
    enableSemanticHighlighting = true,
    inlayHints = {
      byNameParameters = { enable = true },
      hintsInPatternMatch = { enable = true },
      implicitArguments = { enable = true },
      implicitConversions = { enable = true },
      inferredTypes = { enable = true },
      typeParameters = { enable = true },
    },
    serverVersion = "latest.snapshot",
    superMethodLensesEnabled = false,
  },
  init_options = {
    statusBarProvider = "on",
  },
  on_attach = function(_, bufnr)
    vim.tbl_deep_extend("force", _G.Config.leader_group_clues, {
      { mode = "n", keys = "<leader>m", desc = "+Metals" },
    })

    vim.keymap.set("v", "K", metals.type_of_range, { desc = "Type of selection" })
    vim.keymap.set("n", "<leader>fm", metals.commands, { desc = "metal commands" })
    vim.keymap.set("n", "<leader>mc", metals.compile_cascade, { desc = "compile cascade" })
    vim.keymap.set("n", "<leader>mh", function()
      metals.hover_worksheet()
    end, { desc = "hover worksheet" })
    vim.keymap.set("n", "<leader>mt", require("metals.tvp").toggle_tree_view, { desc = "tvp tree view" })
    vim.keymap.set("n", "<leader>dt", utils.run_nearest_codelens, { desc = "run nearest test" })
    vim.keymap.set("n", "<leader>dT", utils.run_first_codelens, { desc = "run test file" })

    vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost" }, {
      callback = vim.lsp.codelens.refresh,
      buffer = bufnr,
      group = nvim_metals_group,
    })

    metals.setup_dap()
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
