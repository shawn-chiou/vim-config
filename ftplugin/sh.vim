" 啟用語法高亮
setlocal syntax=sh

" 設定自動縮排
setlocal shiftwidth=2
setlocal softtabstop=2
setlocal expandtab

" 語法檢查設置
let g:syntastic_shell_checkers = ['shellcheck']
let g:syntastic_shell_shellcheck_exec = 'shellcheck'  " 確保安裝了 shellcheck

" 程式提示設置
let g:deoplete#enable_at_startup = 1
autocmd FileType sh setlocal omnifunc=deoplete#complete

" 格式化命令，使用 autoformat
autocmd BufWritePre *.sh :Autoformat

" 其他選項（如需要）
"setlocal spell
"setlocal spelllang=en_us

nnoremap <buffer> <leader>r :!bash %<CR>