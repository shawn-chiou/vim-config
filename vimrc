"automated installation of vimplug if not installed
if empty(glob('~/.vim/autoload/plug.vim'))
    silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall --sync | source ~/.vimrc
endif

call plug#begin('~/.vim/plugged')

Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'scrooloose/nerdTree'
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-fugitive'
Plug 'preservim/tagbar'
Plug 'brookhong/cscope.vim'
Plug 'vim-autoformat/vim-autoformat'
Plug 'ycm-core/YouCompleteMe', { 'do': './install.py --all' }
"Plug 'fatih/vim-go', { 'do': ':GoInstallBinaries' }
"Plug 'prabirshrestha/vim-lsp'
"Plug 'mattn/vim-lsp-settings'

"Plug 'dense-analysis/ale'
"Plug 'junegunn/gv.vim'
"Plug 'rhysd/vim-lsp-ale'
"Plug 'lervag/vimtex'
"Plug 'vim-scripts/vim-pencil'
"Plug 'rbong/vim-flog'
"Plug 'plasticboy/vim-markdown'
"Plug 'xuhdev/vim-latex-live-preview', { 'for': 'tex' }
"Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }, 'for': ['markdown', 'vim-plug']}

call plug#end()

nmap <F3> :NERDTreeToggle<CR>
nmap <F6> :Autoformat<CR>
nmap <F8> :TagbarToggle<CR>
nmap <C-n> :bn<CR>
nmap <C-p> :bp<CR>
"nmap gd :ALEGoToDefinition<CR>
"nmap gr :ALEFindReferences<CR>
"nmap K :ALEHover<CR>
"nmap <silent> <C-k> <Plug>(ale_previous_wrap)
"nmap <silent> <C-j> <Plug>(ale_next_wrap)

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

set ai
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

highlight ColorColumn ctermbg=235 guibg=#2c2d27

filetype on
filetype indent on
filetype plugin on
syntax on

let &rtp .= ',' . expand( '<sfile>:p:h' )
let g:is_posix = 1
let &colorcolumn="81,".join(range(121,999),",")

" ycm
let g:ycm_autoclose_preview_window_after_completion=1
set completeopt=menu,menuone
let g:ycm_add_preview_to_completeopt = 0
let g:ycm_show_diagnostics_ui = 0

"let g:ale_vim_vimls_config = {
"\   'vim': {
"\     'iskeyword': '@,48-57,_,192-255,-#',
"\     'vimruntime': '',
"\     'runtimepath': '',
"\     'diagnostic': {
"\       'enable': v:true
"\     },
"\     'indexes': {
"\       'runtimepath': v:true,
"\       'gap': 100,
"\       'count': 3,
"\       'projectRootPatterns' : ['.git', 'autoload', 'plugin']
"\     },
"\     'suggest': {
"\       'fromVimruntime': v:true,
"\       'fromRuntimepath': v:false
"\     },
"\   }
"\}
"let g:ale_vim_vimls_executable = 'vim-language-server'
"let g:ale_vim_vimls_use_global = 0
"let g:ale_vim_vint_executable = 'vint'
"let g:ale_vim_vint_show_style_issues = 1
"let g:ale_fixers = {
"\   '*': ['remove_trailing_lines', 'trim_whitespace'],
"\   'bash': ['shfmt'],
"\   'python': ['autoimport', 'autoflake', 'autopep8', 'reorder-python-imports', 'yapf', 'ruff'],
"\   'go': ['gopls'],
"\   'javascript': ['prettier', 'eslint'],
"\   'json': ['prettier'],
"\}
"let g:ale_set_balloons=1
"let g:ale_completion_enabled=1
"let g:ale_floating_window_border = ['│', '─', '╭', '╮', '╯', '╰', '│', '─']
"let g:ale_floating_window_border = repeat([''], 8)
"let g:ale_linter_aliases = {'vue': ['vue', 'javascript']}
"let g:ale_linters = {
"\   'bash': ['bashate', 'cspell', 'shell', 'shellcheck'],
"\   'python': ['flake8', 'pylint', 'ruff'],
"\   'go': ['gopls'],
"\   'vue': ['eslint', 'vls'],
"\   'json': ['prettier'],
"\}
"let g:ale_sh_bashate_executable = 'bashate'
"let g:ale_sh_bashate_options = ''
""let g:ale_sh_language_server_executable = 'bash-language-server'
""let g:ale_sh_language_server_use_global = 0
"let g:ale_sh_shell_default_shell = 'bash'
"let g:ale_sh_shellcheck_change_directory = 1
"let g:ale_sh_shellcheck_dialect = 'auto'
"let g:ale_sh_shellcheck_exclusions = ''
"let g:ale_sh_shellcheck_executable = 'shellcheck'
"let g:ale_sh_shellcheck_options = ''

"autocmd User lsp_setup call lsp#register_server({
"    \ 'name': 'pyls-debug',
"    \ 'cmd': ["nc", "localhost", "5007"],
"    \ 'allowlist': ['python'],
"    \ })

"if executable('bash-language-server')
"  au User lsp_setup call lsp#register_server({
"        \ 'name': 'bash-language-server',
"        \ 'cmd': {server_info->[&shell, &shellcmdflag, 'bash-language-server start']},
"        \ 'allowlist': ['sh', 'ash', 'bash'],
"        \ })
"endif
"
"let g:ycm_language_server =
"            \ [
"            \   {
"            \       'name': 'bash',
"            \       'cmdline': [ 'bash-language-server', 'start' ],
"            \       'filetypes': [ 'sh' ],
"            \   }
"            \ ]

"augroup LspGo
"  au!
"  autocmd User lsp_setup call lsp#register_server({
"      \ 'name': 'go-lang',
"      \ 'cmd': {server_info->['gopls']},
"      \ 'whitelist': ['go'],
"      \ })
"  autocmd FileType go setlocal omnifunc=lsp#complete
"  "autocmd FileType go nmap <buffer> gd <plug>(lsp-definition)
"  "autocmd FileType go nmap <buffer> ,n <plug>(lsp-next-error)
"  "autocmd FileType go nmap <buffer> ,p <plug>(lsp-previous-error)
"augroup END

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

autocmd BufRead *.htm,*.html,*.jsx,*.js,*.json,*.vue set ai et sw=2 ts=2 softtabstop=2
autocmd BufRead *.php,*.css,*.scss,*.py set ai et sw=4 ts=4 softtabstop=4
"autocmd BufWrite *.py :Autoformat
autocmd BufRead,BufWrite * if ! &bin | silent! %s/\s\+$//ge | endif " Remove any trailing whitespace that is in the file
autocmd BufWritePost *.go silent! !ctags -R --exclude=.git* --exclude=docs --exclude=.idea --exclude=testdata --exclude=deploy --exclude=*.yaml --exclude=*.md --exclude=Makefile --exclude=go.* --exclude=*.json .
"autocmd BufWritePost *.py silent! !ctags -R --exclude=.git* --exclude=docs --exclude=etc --exclude=nvmedebs --exclude=python-wls --exclude=python-wheels --exclude=rdma-core-install --exclude=*.sh --exclude=*.pyc --exclude=*.yaml --exclude=*.md --exclude=Dockerfile* --exclude=*.ini --exclude=*.json --exclude=*.md --exclude=*.txt --exclude=*.conf .
