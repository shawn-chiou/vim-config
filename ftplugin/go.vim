"automated installation of vimplug if not installed
if empty(glob('~/.vim/autoload/plug.vim'))
    silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall --sync | source ~/.vimrc
endif

call plug#begin('~/.vim/plugged')
Plug 'fatih/vim-go', { 'do': ':GoInstallBinaries' }
call plug#end()

" 啟用語法高亮
setlocal syntax=go

" 設定自動縮排
setlocal shiftwidth=4
setlocal softtabstop=4
setlocal expandtab
setlocal autoindent
setlocal smartindent

" 啟用行號
setlocal number

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