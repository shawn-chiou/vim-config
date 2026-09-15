"automated installation of vimplug if not installed
if empty(glob('~/.vim/autoload/plug.vim'))
    silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall --sync | source ~/.vimrc
endif

call plug#begin('~/.vim/plugged')

" ====== common ======
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'scrooloose/nerdTree'
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-fugitive'
Plug 'preservim/tagbar'
Plug 'brookhong/cscope.vim'
Plug 'vim-autoformat/vim-autoformat'
Plug 'vim-syntastic/syntastic', { 'for': ['sh', 'python'] }
Plug 'ycm-core/YouCompleteMe', { 'do': './install.py --all' }

" ====== Go ======
Plug 'fatih/vim-go', { 'do': ':GoInstallBinaries', 'for': 'go' }

" ========= Python =========
Plug 'vim-python/python-syntax', { 'for': 'python' }

" ====== Markdown ======
Plug 'plasticboy/vim-markdown', { 'for': 'markdown' }
Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }, 'for': 'markdown' }

" ====== Tex ======
Plug 'lervag/vimtex', { 'for': 'tex' }
Plug 'xuhdev/vim-latex-live-preview', { 'for': 'tex' }

" ====== SQL ======
Plug 'vim-scripts/SQLUtilities', { 'for': 'sql' }

" ====== make/Makefile ======
Plug 'tpope/vim-dispatch', { 'for': 'make' }

"Plug 'junegunn/gv.vim'
"Plug 'vim-scripts/vim-pencil'
"Plug 'rbong/vim-flog'

call plug#end()

nmap <F3> :NERDTreeToggle<CR>
nmap <F6> :Autoformat<CR>
nmap <F8> :TagbarToggle<CR>
nmap <C-n> :bn<CR>
nmap <C-p> :bp<CR>

nnoremap <leader>fa :call CscopeFindInteractive(expand('<cword>'))<CR>
nnoremap <leader>l :call ToggleLocationList()<CR>
" s: Find this C symbol
nnoremap  <leader>fs :call CscopeFind('s', expand('<cword>'))<CR>
" g: Find this definition
nnoremap  <leader>fg :call CscopeFind('g', expand('<cword>'))<CR>
" d: Find functions called by this function
nnoremap  <leader>fd :call CscopeFind('d', expand('<cword>'))<CR>
" c: Find functions calling this function
nnoremap  <leader>fc :call CscopeFind('c', expand('<cword>'))<CR>
" t: Find this text string
nnoremap  <leader>ft :call CscopeFind('t', expand('<cword>'))<CR>
" e: Find this egrep pattern
nnoremap  <leader>fe :call CscopeFind('e', expand('<cword>'))<CR>
" f: Find this file
nnoremap  <leader>ff :call CscopeFind('f', expand('<cword>'))<CR>
" i: Find files #including this file
nnoremap  <leader>fi :call CscopeFind('i', expand('<cword>'))<CR>

" ====== Claude 終端機（F9 開關）======
let s:claude_bufnr = 0

function! s:ClaudeToggle() abort
    " 是否已有執行中的 session（buffer 還在且 job 未結束）
    let l:alive = s:claude_bufnr > 0 && bufexists(s:claude_bufnr)
                \ && getbufvar(s:claude_bufnr, '&buftype') ==# 'terminal'
                \ && term_getstatus(s:claude_bufnr) =~# 'running'

    if l:alive
        let l:winid = bufwinid(s:claude_bufnr)
        if l:winid != -1
            " 視窗開著 → 收起來，job 留在背景繼續跑
            call win_gotoid(l:winid)
            if winnr('$') > 1
                close
            elseif buflisted(bufnr('#')) && bufnr('#') != s:claude_bufnr
                buffer #
            else
                enew
            endif
        else
            " job 還在、只是視窗收起來了 → 叫回同一個 session
            execute 'botright sbuffer ' . s:claude_bufnr
            execute 'resize 15'
            normal! i
        endif
        return
    endif

    " 沒有 session（或上次已結束）→ 重新啟動
    botright terminal ++rows=15 ++kill=term claude
    let s:claude_bufnr = bufnr('%')
endfunction

nnoremap <silent> <F9> :call <SID>ClaudeToggle()<CR>
tnoremap <silent> <F9> <C-\><C-n>:call <SID>ClaudeToggle()<CR>

" 在 terminal 中以 <Esc><Esc> 回到 Terminal-Normal 模式（捲動、複製）
tnoremap <Esc><Esc> <C-\><C-n>

set ai
set autoread
set background=dark
"set cindent
set cursorline
set cursorcolumn
set enc=utf8
"set fileencodings=utf-8,big5,utf-bom,iso8859-1
"set hls
set laststatus=2
set ruler
set nu
set showmatch
"set expandtab shiftwidth=4 tabstop=4
set binary
set noeol
set nocompatible
"set textwidth=80
"set colorcolumn=81
set wildmenu
set wildmode=longest:list,full
set tags=./tags,./TAGS,tags;~,TAGS;~
set hidden

highlight ColorColumn ctermbg=235 guibg=#2c2d27

filetype plugin indent on
syntax on

let &rtp .= ',' . expand( '<sfile>:p:h' )
let g:is_posix = 1
let &colorcolumn="81,".join(range(121,999),",")

" ycm
let g:ycm_autoclose_preview_window_after_completion=1
set completeopt=menu,menuone
let g:ycm_add_preview_to_completeopt = 0
let g:ycm_show_diagnostics_ui = 0

" syntastic (statusline 交給 airline 的 syntastic extension 處理)
let g:syntastic_enable_signs = 1
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
let g:syntastic_aggregate_errors = 1

"let g:airline_theme='simple'
let g:airline_theme='murmur'
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#formatter = 'default'

"let g:tex_flavor='latex'
""let g:vimtex_view_method='zathura'
"let g:vimtex_view_method='okular'
"let g:vimtex_quickfix_mode=0
"set conceallevel=1
"let g:tex_conceal='abdmg'

let g:autoformat_autoindent = 0
let g:autoformat_retab = 0
let g:autoformat_remove_trailing_spaces = 0
"let g:formatdef_autopep8 = "'autopep8 - --max-line-length 120 --range '.a:firstline.' '.a:lastline"
"let g:formatters_python = ['autopep8']

"g:vim_markdown_folding_disabled
let mapleader=','
if exists(":Tabularize")
  nmap <Leader>a= :Tabularize /=<CR>
  vmap <Leader>a= :Tabularize /=<CR>
  nmap <Leader>a: :Tabularize /:\zs<CR>
  vmap <Leader>a: :Tabularize /:\zs<CR>
endif

"let g:pencil#wrapModeDefault = 'hard'   " or 'soft'
"augroup pencil
"  autocmd!
"  autocmd FileType markdown,mkd call pencil#init()
"  autocmd FileType textile      call pencil#init()
"  autocmd FileType text         call pencil#init({'wrap': 'hard'})
"augroup END

autocmd FocusGained,BufEnter,CursorHold,CursorHoldI * checktime
autocmd BufRead *.htm,*.html,*.jsx,*.js,*.json,*.vue set ai et sw=2 ts=2 softtabstop=2
autocmd BufRead *.php,*.css,*.scss,*.py set ai et sw=4 ts=4 softtabstop=4
"autocmd BufWrite *.py :Autoformat
autocmd BufRead,BufWrite * if ! &bin | silent! %s/\s\+$//ge | endif " Remove any trailing whitespace that is in the file
autocmd BufWritePost *.go silent! !ctags -R --exclude=.git* --exclude=docs --exclude=.idea --exclude=testdata --exclude=deploy --exclude=*.yaml --exclude=*.md --exclude=Makefile --exclude=go.* --exclude=*.json .
"autocmd BufWritePost *.py silent! !ctags -R --exclude=.git* --exclude=docs --exclude=etc --exclude=nvmedebs --exclude=python-wls --exclude=python-wheels --exclude=rdma-core-install --exclude=*.sh --exclude=*.pyc --exclude=*.yaml --exclude=*.md --exclude=Dockerfile* --exclude=*.ini --exclude=*.json --exclude=*.md --exclude=*.txt --exclude=*.conf .
