setlocal tabstop=2
setlocal shiftwidth=2
setlocal expandtab

setlocal wrap
setlocal linebreak

" VimTeX
" For Linux
"let b:vimtex_view_method = 'zathura'
" For MacOS
let b:vimtex_view_method = 'skim'

" 編譯
nnoremap <buffer> <leader>ll :VimtexCompile<CR>

" 停止編譯
nnoremap <buffer> <leader>lk :VimtexStop<CR>

" 查看 PDF
nnoremap <buffer> <leader>lv :VimtexView<CR>

" 清理 auxiliary files
nnoremap <buffer> <leader>lc :VimtexClean<CR>