"automated installation of vimplug if not installed
if empty(glob('~/.vim/autoload/plug.vim'))
    silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall --sync | source ~/.vimrc
endif

call plug#begin('~/.vim/plugged')
Plug 'vim-syntastic/syntastic'
Plug 'Shawnc2/vim-deoplete'
call plug#end()

" 啟用語法高亮
setlocal syntax=python

" 設定自動縮排
setlocal shiftwidth=4
setlocal softtabstop=4
setlocal expandtab
setlocal autoindent
setlocal smartindent

" 啟用行號
setlocal number

" 語法檢查
let g:syntastic_python_checkers = ['flake8']
let g:syntastic_python_flake8_exec = 'flake8'  " 確保安裝了 flake8

" 程式提示設置
let g:deoplete#enable_at_startup = 1
autocmd FileType python setlocal omnifunc=deoplete#complete

" 自動顯示補全選項
setlocal completeopt=menuone,noinsert

" 排版設置
let g:formatdef_autopep8 = "'autopep8 - --max-line-length 120 --range '.a:firstline.' '.a:lastline"
let g:formatters_python = ['autopep8']

" 設置格式化命令，使用 autoformat
autocmd BufWritePre *.py Autoformat

" 其他選項（如需要）
"setlocal spell
"setlocal spelllang=en_us