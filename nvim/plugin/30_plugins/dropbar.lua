pack_add("Bekaboo/dropbar.nvim")

local dropbar_api = require("dropbar.api")

---@class dropbar_source_t
local lsp_diagnostics = {
  get_symbols = function(buff, _, _)
    local lspIcons = require("icons").diagnostics
    local bar = require("dropbar.bar")

    local errors = vim.diagnostic.get(buff, { severity = vim.diagnostic.severity.ERROR })
    local warnings = vim.diagnostic.get(buff, { severity = vim.diagnostic.severity.WARN })
    local infos = vim.diagnostic.get(buff, { severity = vim.diagnostic.severity.INFO })
    local hints = vim.diagnostic.get(buff, { severity = vim.diagnostic.severity.HINT })

    local stats = {}

    if #errors > 0 then
      table.insert(
        stats,
        bar.dropbar_symbol_t:new({
          icon = lspIcons.ERROR,
          icon_hl = "DiagnosticError",
          name = " " .. tostring(#errors),
          name_hl = "DiagnosticError",
        })
      )
    end

    if #warnings > 0 then
      table.insert(
        stats,
        bar.dropbar_symbol_t:new({
          icon = lspIcons.WARN,
          icon_hl = "DiagnosticWarn",
          name = " " .. tostring(#warnings),
          name_hl = "DiagnosticWarn",
        })
      )
    end

    if #infos > 0 then
      table.insert(
        stats,
        bar.dropbar_symbol_t:new({
          icon = lspIcons.INFO,
          icon_hl = "DiagnosticInfo",
          name = " " .. tostring(#infos),
          name_hl = "DiagnosticInfo",
        })
      )
    end

    if #hints > 0 then
      table.insert(
        stats,
        bar.dropbar_symbol_t:new({
          icon = lspIcons.HINT,
          icon_hl = "DiagnosticHint",
          name = " " .. tostring(#hints),
          name_hl = "DiagnosticHint",
        })
      )
    end

    return stats
  end,
}

require("dropbar").setup({
  sources = {
    path = {
      max_depth = 2,
    },
  },
  bar = {
    sources = function(buf, _)
      local sources = require("dropbar.sources")
      local utils = require("dropbar.utils")
      if vim.bo[buf].ft == "markdown" then
        return {
          sources.path,
          sources.markdown,
        }
      end
      if vim.bo[buf].buftype == "terminal" then
        return {
          sources.terminal,
        }
      end
      return {
        sources.path,
        lsp_diagnostics,
        utils.source.fallback({
          sources.lsp,
          sources.treesitter,
        }),
      }
    end,
  },
})

vim.api.nvim_create_user_command("DropbarPick", function()
  dropbar_api.pick()
end, { desc = "Jump to Treesitter Context", nargs = 0 })

vim.api.nvim_create_user_command("DropbarContextStart", function()
  dropbar_api.goto_context_start(0)
end, { desc = "Jump to Treesitter Context", nargs = 0 })

vim.api.nvim_create_user_command("DropbarContextNext", function()
  dropbar_api.select_next_context()
end, { desc = "Jump to Treesitter Context", nargs = 0 })
