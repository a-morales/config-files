Keybind.global({
  { 'n', '<Leader>ew', ":e <C-R>=fnameescape(expand(\'%:h\')).'/'<cr>" },
  { 'n', '<Leader>es', ":sp <C-R>=fnameescape(expand(\'%:h\')).'/'<cr>" },
  { 'n', '<Leader>ev', ":vsp <C-R>=fnameescape(expand(\'%:h\')).'/'<cr>" },
  { 'n', '<Leader>et', ":tabe <C-R>=fnameescape(expand(\'%:h\')).'/'<cr>" },
  { 'n', '<C-p>', ':Files<cr>' },
  { 'n', '<C-space>', ':Buffer<cr>' },
  { 'n', '<leader>ag', ':Ag<cr>' },
  { 'n', '<leader>mk', ":!mkdir <C-R>=fnameescape(expand(\'%:h\')).'/'<cr>" },
  { 'n', '<leader>r', ':windo redraw!<cr>' },
  { 'n', '<leader>R', ':luafile $MYVIMRC<cr>' },
  { 'n', '<leader><space>', ':noh<cr>', { noremap = true }},
})
