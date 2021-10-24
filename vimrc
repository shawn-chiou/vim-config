"automated installation of vimplug if not installed
if empty(glob('~/.vim/autoload/plug.vim'))
    silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall --sync | source ~/.vimrc
endif

call plug#begin('~/.vim/plugged')

Plug 'lervag/vimtex'
Plug 'vim-scripts/vim-pencil'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'scrooloose/nerdTree'
Plug 'preservim/tagbar'
"Plug 'fatih/vim-go', { 'do': ':GoInstallBinaries' }
"Plug 'plasticboy/vim-markdown'
"Plug 'xuhdev/vim-latex-live-preview', { 'for': 'tex' }
"Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }, 'for': ['markdown', 'vim-plug']}

call plug#end()

nmap <F3> :NERDTreeToggle<CR>
nmap <F8> :TagbarToggle<CR>
nmap <C-n> :bn<CR>
nmap <C-p> :bp<CR>

set ai
set background=dark
"set cindent
set cursorline
"set enc=utf8
"set fileencodings=utf-8,big5,utf-bom,iso8859-1
"set hls
set laststatus=2
set nu
set showmatch
"set expandtab shiftwidth=4 tabstop=4
set binary
set noeol
set nocompatible
set colorcolumn=80

syntax on
filetype plugin on

"let g:airline_theme='simple'
let g:airline_theme='murmur'
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#formatter = 'default'

"g:vim_markdown_folding_disabled
let mapleader=','
if exists(":Tabularize")
  nmap <Leader>a= :Tabularize /=<CR>
  vmap <Leader>a= :Tabularize /=<CR>
  nmap <Leader>a: :Tabularize /:\zs<CR>
  vmap <Leader>a: :Tabularize /:\zs<CR>
endif

let g:pencil#wrapModeDefault = 'hard'   " or 'soft'
augroup pencil
  autocmd!
  autocmd FileType markdown,mkd call pencil#init()
  autocmd FileType textile      call pencil#init()
  autocmd FileType text         call pencil#init({'wrap': 'hard'})
augroup END

autocmd BufRead *.htm,*.html,*.jsx,*.js,*.json,*.vue set ai et sw=2 ts=2 softtabstop=2
autocmd BufRead *.php,*.css,*.scss,*.py set ai et sw=4 ts=4 softtabstop=4
autocmd BufRead,BufWrite * if ! &bin | silent! %s/\s\+$//ge | endif " Remove any trailing whitespace that is in the file
autocmd BufWritePost *.go silent! !ctags -R --exclude=.git* --exclude=docs --exclude=.idea --exclude=testdata --exclude=deploy --exclude=*.yaml --exclude=*.md --exclude=Makefile --exclude=go.* --exclude=*.json .
