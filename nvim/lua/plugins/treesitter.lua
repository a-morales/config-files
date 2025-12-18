return {
  "nvim-treesitter/nvim-treesitter",
  dependencies = {
    "nvim-treesitter/nvim-treesitter-context",
  },
  lazy = false,
  build = ":TSUpdate",
  config = function()
    local ts = require("nvim-treesitter")

    ts.install({
      "bash",
      "fish",
      "dockerfile",
      "html",
      "javascript",
      "json",
      "lua",
      "make",
      "markdown",
      "smithy",
      "sql",
      "scala",
      "typescript",
      "yaml",
      "vim",
    })

    vim.api.nvim_create_autocmd("FileType", {
      callback = function(event)
        local lang = vim.treesitter.language.get_lang(event.match) or event.match
        if vim.treesitter.language.add(lang) then
          vim.treesitter.start()
          if vim.treesitter.query.get(lang, "indents") then
            vim.bo.indentexpr = "v:lua.require('nvim-treesitter').indentexpr()"
          end
          if vim.treesitter.query.get(lang, "folds") then
            vim.wo.foldmethod = "expr"
            vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
          end
        end
      end,
    })
  end,
}
