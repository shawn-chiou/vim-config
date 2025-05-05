"automated installation of vimplug if not installed
if empty(glob('~/.vim/autoload/plug.vim'))
    silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall --sync | source ~/.vimrc
endif

call plug#begin('~/.vim/plugged')
Plug 'vim-syntastic/syntastic'
call plug#end()

" 啟用語法高亮
setlocal syntax=sql

" 設定自動縮排
setlocal shiftwidth=4
setlocal softtabstop=4
setlocal expandtab
setlocal autoindent
setlocal smartindent

" 啟用行號
setlocal number

" 語法檢查設置
let g:syntastic_sql_checkers = ['sqlfluff']  " 確保安裝了 sqlfluff

" 語法提示設置
setlocal completeopt=menuone,noinsert

" 格式化命令，使用 autoformat
autocmd BufWritePre *.sql Autoformat

" 其他選項（如需要）
"setlocal spell
"setlocal spelllang=en_us