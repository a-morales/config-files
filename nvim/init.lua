cmd = vim.cmd
g = vim.g

function opt(scope, key, value)
  local scopes = {o = vim.o, b = vim.bo, w = vim.wo}
  scopes[scope][key] = value
  if scope ~= 'o' then
    scopes['o'][key] = value
  end
end

function map(mode, lhs, rhs, opts)
  local options = {noremap = true}
  if opts then
    options = vim.tbl_extend('force', options, opts)
  end
  vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

require('utils')
require('plugins')

require('variables')
require('keybindings')
require('commands')
require('settings')

-- vim.g.tokyonight_style = 'storm'
vim.cmd 'colorscheme hybrid'
-- vim.cmd 'colorscheme tokyonight'
