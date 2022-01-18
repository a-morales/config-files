require'mapx'.setup{ global = true }

vim.g.mapleader = ' '

nmap('<Leader>ew', ":e <C-R>=fnameescape(expand(\'%:h\')).'/'<CR>")
nmap('<Leader>es', ":sp <C-R>=fnameescape(expand(\'%:h\')).'/'<CR>")
nmap('<Leader>ev', ":vsp <C-R>=fnameescape(expand(\'%:h\')).'/'<CR>")
nmap('<Leader>et', ":tabe <C-R>=fnameescape(expand(\'%:h\')).'/'<CR>")
nmap('<leader>mk', ":!mkdir <C-R>=fnameescape(expand(\'%:h\')).'/'<CR>")
nmap('<leader>r', ':windo redraw!<CR>')
nmap('<leader>R', ':luafile $MYVIMRC<CR>')
nmap('<C-f>', ":HopChar2<CR>")
nmap('<leader>s', ':SidebarNvimToggle<CR>')
nnoremap('<leader><space>', ':noh<CR>')

nmap('<C-p>', ':FzfLua files<CR>')
nmap('<C-space>', ':FzfLua buffers<CR>')
nmap('<leader>p', ':FzfLua commands<CR>')
nmap('<leader>rg', ':FzfLua live_grep<CR>')
-- nmap('<C-n>', ':NvimTreeToggle<CR>)
-- nmap('<leader>n', ':NvimTreeFindFile<CR>)
-- nmap('<leader>b', ':ToggleBlameLine<CR>)
