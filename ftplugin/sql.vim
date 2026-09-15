" 啟用語法高亮
setlocal syntax=sql

" 設定自動縮排
setlocal shiftwidth=4
setlocal softtabstop=4
setlocal expandtab

" 語法檢查設置
let g:syntastic_sql_checkers = ['sqlfluff']  " 確保安裝了 sqlfluff

" 語法提示設置
setlocal completeopt=menuone,noinsert

" SQL keyword 不區分大小寫
setlocal ignorecase
setlocal smartcase

setlocal commentstring=--\ %s

" 格式化命令，使用 autoformat
autocmd BufWritePre *.sql Autoformat

" 其他選項（如需要）
"setlocal spell
"setlocal spelllang=en_us

" 執行目前 SQL (PostgreSQL only)
"nnoremap <buffer> <leader>r :!psql -f %<CR>
"nnoremap <buffer> <leader>r :!psql mydb -f %<CR>