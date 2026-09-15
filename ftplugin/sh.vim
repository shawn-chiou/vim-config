" 設定自動縮排
setlocal shiftwidth=2
setlocal softtabstop=2
setlocal expandtab

" 語法檢查設置
let g:syntastic_sh_checkers = ['shellcheck']  " 確保安裝了 shellcheck
let g:syntastic_sh_shellcheck_args = '-x'

" 格式化命令，使用 autoformat
autocmd BufWritePre *.sh :Autoformat

" 其他選項（如需要）
"setlocal spell
"setlocal spelllang=en_us

nnoremap <buffer> <leader>r :!bash %<CR>