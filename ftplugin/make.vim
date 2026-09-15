setlocal noexpandtab
setlocal tabstop=8
setlocal shiftwidth=8

" 執行 make
nnoremap <buffer> <leader>m :Make<CR>

" make clean
nnoremap <buffer> <leader>c :Make clean<CR>

" make test
nnoremap <buffer> <leader>t :Make test<CR>