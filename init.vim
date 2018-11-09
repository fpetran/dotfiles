" vim: fdm=marker
" {{{ os detection
if has("win64") || has("win32") || has("win16")
    let osys="Windows"
    behave mswin
elseif has("unix")
    let osys="Linux"
elseif has("macunix")
    let osys="Darwin"
endif
" }}}
" {{{ plugged
call plug#begin(stdpath('config')."/plugged")

Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-vinegar'
Plug 'tpope/vim-surround'
Plug 'mhinz/vim-signify'
Plug 'vim-scripts/a.vim', { 'for': 'cpp' }
Plug 'romainl/flattened'
Plug 'scrooloose/syntastic'
Plug 'bling/vim-airline'
Plug 'ajh17/VimCompletesMe'
Plug 'bronson/vim-trailing-whitespace'
Plug 'ludovicchabant/vim-gutentags'
Plug 'majutsushi/tagbar'

call plug#end()
" }}}
" {{{ misc settings

" tab/indentation
set shiftwidth=4
set autoindent
set smartindent
set softtabstop=4
set expandtab

" jump to last edited position
if has("autocmd")
    au BufReadPost *
                \ if line("'\"") > 0 && line("'\"") <= line("$") |
                \    exe "normal g'\"" |
                \    exe "normal zz" |
                \ endif
endif

" hybrid line numbering
if v:version >= 704
    set relativenumber
    set number
endif
" cursor line
if v:version >= 700
    " && has("gui_running")
    set cursorline
endif

" show tabs/trailing WS
" TODO termencodings, gui/not gui, nbsp for version >= 700
set list listchars=tab:>-,trail:.,extends:>,nbsp:_

" wildmenu
set wildmenu
set wildignore+=*.o,*~,*.lo,*.exe,*.com,*.pdf,*.ps,*.dvi,*.pyc
set suffixes+=.in,.a

" misc
set nocompatible
set history=500
set backspace=indent,eol,start
set nobackup
set showcmd
set showmatch
set hlsearch
set incsearch
set maxmempattern=2000000
set autochdir
set noerrorbells
set visualbell t_vb=
set showfulltag
set lazyredraw
set whichwrap+=<,>,[,]

if has("syntax")
    syntax on
endif
" }}}
" {{{ color and stuff
colorscheme flattened_light
" }}}
" {{{ window title
if has("title")
    set title
    set titlestring=
    set titlestring+=%f
    set titlestring+=%h%m%r%w
    set titlestring+=\ -\ %{v:progname}
    set titlestring+=\ -\ %{substitute(getcwd(),\ $HOME,\ '~',\ '')}
endif
" }}}
" {{{ netrw (file browser)
let g:netrw_banner = 0        " reactivate with I
let g:netrw_winsize = 25      " 25%
let g:netrw_liststyle = 3     " tree view
let g:netrw_browse_split = 4  " open in previous window
let g:netrw_altv = 1

" function to make netrw toggleable
let g:NetrwIsOpen=0
function! ToggleNetrw()
    if g:NetrwIsOpen
        let i = bufnr("$")
        while (i >= 1)
            if (getbufvar(i, "&filetype") == "netrw")
                silent exe "bwipeout " . i 
            endif
            let i-=1
        endwhile
        let g:NetrwIsOpen=0
    else
        let g:NetrwIsOpen=1
        silent Lexplore
    endif
endfunction
noremap <silent> <F9> :call ToggleNetrw()<CR>
" }}}
" {{{ airline
set laststatus=2
let g:airline#extensions#tabline#enabled = 1
let g:airline_powerline_fonts = 1
if !exists('g:airline_symbols')
    let g:airline_symbols = {}
endif
let g:airline_symbols.space = "\ua0"
" }}}
" {{{ syntastic
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
function! SyntasticCheckHook(errors)
    if !empty(a:errors)
        let g:syntastic_loc_list_height = min([len(a:errors), 10])
    endif
endfunction
" }}}
" {{{ tags
" remap of jump to tag for german keyboard
nnoremap ü <C-]>
" map for tagbar
nmap <F8> :TagbarToggle<CR>
" }}}
" {{{ c++ specific
if has("autocmd")
    autocmd BufRead,BufNewFile *.h,*.cpp set colorcolumn=80
    autocmd BufRead,BufNewFile *.h,*.cpp set filetype=cpp.doxygen
endif
" }}}
" vim: set shiftwidth=4 softtabstop=4 expandtab tw=120
