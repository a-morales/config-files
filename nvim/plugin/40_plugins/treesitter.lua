now(function()
  pack_add({
    source = "nvim-treesitter/nvim-treesitter",
    hooks = {
      post_checkout = function()
        vim.cmd("TSUpdate")
      end,
    },
  })

  local ts = require("nvim-treesitter")

  local ensure_languages = {
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
    "tsx",
    "typescript",
    "yaml",
    "vim",
  }
  local isnt_installed = function(lang)
    return #vim.api.nvim_get_runtime_file("parser/" .. lang .. ".*", false) == 0
  end
  local to_install = vim.tbl_filter(isnt_installed, ensure_languages)
  if #to_install > 0 then
    ts.install(to_install)
  end

  local filetypes = {}
  for _, lang in ipairs(ensure_languages) do
    for _, ft in ipairs(vim.treesitter.language.get_filetypes(lang)) do
      table.insert(filetypes, ft)
    end
  end

  vim.api.nvim_create_autocmd("FileType", {
    pattern = filetypes,
    callback = function(event)
      local lang = vim.treesitter.language.get_lang(event.match) or event.match
      if vim.treesitter.language.add(lang) then
        vim.treesitter.start(event.buf)
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
end)
