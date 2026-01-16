local M = {}

M.run_nearest_codelens = function()
  local current_line = vim.fn.line(".") - 1
  local nearest_codelens_line = current_line
  local height = math.huge

  for _, codelens in pairs(vim.lsp.codelens.get()) do
    local start_line = codelens.range.start.line

    if start_line <= current_line then
      nearest_codelens_line = start_line + 1
    end
  end

  -- I would like to just pass a line number to vim.api.codelens.run, but it
  -- doesn't work that way, and I don't want to recreate it, so let's just move
  -- the cursor up.
  vim.api.nvim_win_set_cursor(0, { nearest_codelens_line, 0 })
  vim.lsp.codelens.run()
end

M.run_first_codelens = function()
  local first_codelens_line = vim.lsp.codelens.get()[1].range.start.line + 1
  vim.api.nvim_win_set_cursor(0, { first_codelens_line, 0 })
  vim.lsp.codelens.run()
end

return M
