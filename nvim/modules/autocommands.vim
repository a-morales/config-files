" Turn spellcheck on for markdown files
augroup auto_spellcheck
  autocmd BufNewFile,BufRead *.md setlocal spell
augroup END

" Resize vim when it is resized
au VimResized * :wincmd =

" Trim whitespace on save
autocmd BufWritePre * :%s/\s\+$//e

" exit insert mode faster
augroup FastEscape
  autocmd!
  au InsertEnter * set timeoutlen=0
  au InsertLeave * set timeoutlen=1000
augroup END

"only show cursorline in current window in normal mode
augroup cline
  au!
  au WinLeave,InsertEnter * set nocursorline
  au WinEnter,InsertLeave * set cursorline
augroup END

au BufRead,BufNewFile *.scala,*.sbt,*.sc set filetype=scala
