" 設定自動縮排
setlocal shiftwidth=4
setlocal softtabstop=4
setlocal noexpandtab

" 語法檢查設置
let g:go_fmt_command = 'gofmt'  " 使用 gofmt 進行格式化
let g:go_mappings_enabled = 1

" 格式化命令，使用 vim-go 的功能
autocmd BufWritePre *.go :GoFmt

" 語法提示設置
let g:go_auto_type_info = 1

" 其他選項（如需要）
"setlocal spell
"setlocal spelllang=en_us

nnoremap <buffer> <leader>b :GoBuild<CR>
nnoremap <buffer> <leader>t :GoTest<CR>
nnoremap <buffer> <leader>r :GoRun<CR>