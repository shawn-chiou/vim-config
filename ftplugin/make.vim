setlocal noexpandtab
setlocal tabstop=8
setlocal shiftwidth=8
" 語法提示設置
setlocal completeopt=menuone,noinsert

" 其他選項（如需要）
"setlocal spell
"setlocal spelllang=en_us

" 執行 make
nnoremap <buffer> <leader>m :Make<CR>

" make clean
nnoremap <buffer> <leader>c :Make clean<CR>

" make test
nnoremap <buffer> <leader>t :Make test<CR>

" 在寫入時自動格式化
autocmd BufWritePre *.mk,Makefile Autoformat