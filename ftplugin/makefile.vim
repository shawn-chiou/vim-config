"automated installation of vimplug if not installed
if empty(glob('~/.vim/autoload/plug.vim'))
    silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall --sync | source ~/.vimrc
endif

call plug#begin('~/.vim/plugged')
Plug 'vim-syntastic/syntastic'
call plug#end()

" 啟用語法高亮
setlocal syntax=make

" 設定自動縮排
setlocal shiftwidth=4
setlocal softtabstop=4
setlocal expandtab
setlocal autoindent

" 啟用行號
setlocal number

" 啟用 syntastic
let g:syntastic_enable_signs = 1  " 啟用標記顯示

" 設置 Makefile 的檢查器
let g:syntastic_make_checkers = ['make']

" 可選：設置自動檢查
let g:syntastic_check_on_wq = 1  " 在寫入和退出時檢查

" 語法提示設置
setlocal completeopt=menuone,noinsert

" 其他選項（如需要）
"setlocal spell
"setlocal spelllang=en_us

" 在寫入時自動格式化
autocmd BufWritePre *.mk,Makefile Autoformat