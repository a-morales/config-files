now_if_args(function()
  pack_add("akinsho/bufferline.nvim")

  require("bufferline").setup({
    options = {
      show_close_icon = false,
      show_buffer_close_icons = false,
      truncate_names = false,
      indicator = { style = "icon" },
      close_command = function(bufnr)
        require("mini.bufremove").delete(bufnr, false)
      end,
      diagnostics = "nvim_lsp",
      diagnostics_indicator = function(_, _, diag)
        local icons = require("icons").diagnostics
        local indicator = (diag.error and icons.ERROR .. " " or "") .. (diag.warning and icons.WARN or "")
        return vim.trim(indicator)
      end,
    },
  })
end)
