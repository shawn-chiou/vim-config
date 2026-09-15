" 設定自動縮排
setlocal shiftwidth=4
setlocal softtabstop=4
setlocal expandtab

" 語法檢查
let g:syntastic_python_checkers = ['flake8']  " 確保安裝了 flake8

" 自動顯示補全選項
setlocal completeopt=menuone,noinsert

" 排版設置
let g:formatdef_autopep8 = "'autopep8 - --max-line-length 120 --range '.a:firstline.' '.a:lastline"
let g:formatters_python = ['autopep8']

nnoremap <buffer> <leader>r :!python3 %<CR>

" 設置格式化命令，使用 autoformat
autocmd BufWritePre *.py Autoformat

" 其他選項（如需要）
"setlocal spell
"setlocal spelllang=en_us