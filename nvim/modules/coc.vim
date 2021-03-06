" let g:coc_global_extensions = [
"   \ 'coc-snippets',
"   \ 'coc-actions',
"   \ 'coc-sh',
"   \ 'coc-java-debug',
"   \ 'coc-lists',
"   \ 'coc-emmet',
"   \ 'coc-tasks',
"   \ 'coc-pairs',
"   \ 'coc-tsserver',
"   \ 'coc-floaterm',
"   \ 'coc-html',
"   \ 'coc-emoji',
"   \ 'coc-yaml',
"   \ 'coc-explorer',
"   \ 'coc-vimlsp',
"   \ 'coc-xml',
"   \ 'coc-yank',
"   \ 'coc-json',
"   \ 'coc-marketplace',
"   \ ]
"   " \ 'coc-metals',


" " Use tab for trigger completion with characters ahead and navigate.
" inoremap <silent><expr> <TAB>
"       \ pumvisible() ? "\<C-n>" :
"       \ <SID>check_back_space() ? "\<TAB>" :
"       \ coc#refresh()
" inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

" function! s:check_back_space() abort
"   let col = col('.') - 1
"   return !col || getline('.')[col - 1]  =~# '\s'
" endfunction

" " Use <c-space> to trigger completion.
" inoremap <silent><expr> <C-space> coc#refresh()

" " Use <cr> to confirm completion, `<C-g>u` means break undo chain at current
" " position. Coc only does snippet and additional edit on confirm.
" if exists('*complete_info')
"   inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"
" else
"   imap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
" endif


" " GoTo code navigation.
" " nmap <silent> gd <Plug>(coc-definition)
" " nmap <silent> gt <Plug>(coc-type-definition)
" " nmap <silent> gi <Plug>(coc-implementation)
" " nmap <silent> gr <Plug>(coc-references)
" " nmap <silent> gc coc#refresh()


" " Show documentation
" nnoremap <leader>t :call <SID>show_documentation()<CR>;

" function! s:show_documentation()
"   if (index(['vim', 'help'], &filetype) >= 0)
"     execute 'h '.expand('<cword>')
"   else
"     call CocAction('doHover')
"   endif
" endfunction


" " Highlight the symbol and its references when holding the cursor.
" autocmd CursorHold * silent call CocActionAsync('highlight')


" " Add `:Format` command to format current buffer.
" command! -nargs=0 Format :call CocAction('format')
" " Add `:Fold` command to fold current buffer.
" command! -nargs=? Fold :call     CocAction('fold', <f-args>)
" " Add `:OR` command for organize imports of the current buffer.
" command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')
