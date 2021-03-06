Keybind.global({
  { 'n', '<Leader>ew', ":e <C-R>=fnameescape(expand(\'%:h\')).'/'<CR>" },
  { 'n', '<Leader>es', ":sp <C-R>=fnameescape(expand(\'%:h\')).'/'<CR>" },
  { 'n', '<Leader>ev', ":vsp <C-R>=fnameescape(expand(\'%:h\')).'/'<CR>" },
  { 'n', '<Leader>et', ":tabe <C-R>=fnameescape(expand(\'%:h\')).'/'<CR>" },
  { 'n', '<C-p>', ':Files<CR>' },
  { 'n', '<C-space>', ':Buffer<CR>' },
  { 'n', '<leader>ag', ':Ag<CR>' },
  { 'n', '<leader>mk', ":!mkdir <C-R>=fnameescape(expand(\'%:h\')).'/'<CR>" },
  { 'n', '<leader>r', ':windo redraw!<CR>' },
  { 'n', '<leader>R', ':luafile $MYVIMRC<CR>' },
  { 'n', '<leader><space>', ':noh<CR>', { noremap = true }},
  { 'n', '<C-n>', ':NvimTreeToggle<CR>'},
  { 'n', '<leader>n', ':NvimTreeFindFile<CR>'},
})
