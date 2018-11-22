" vim: fdm=marker foldlevelstart=-1
" TODO:
" - stdpath is not available in normal vim
" - plugged autoinstall
"
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
" {{{ attempt plugged autoinstall
" if empty(glob('~/.vim/autoload/plug.vim))
    " silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
        " \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    " autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
" endif
" }}}
" {{{ plugged
call plug#begin(stdpath('config')."/plugged")

Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-vinegar'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-commentary'

Plug 'mhinz/vim-signify'

Plug 'rhysd/vim-clang-format'
Plug 'bronson/vim-trailing-whitespace'
Plug 'vim-scripts/a.vim', { 'for': 'cpp' }
Plug 'romainl/flattened'

Plug 'scrooloose/syntastic'
Plug 'myint/syntastic-extras'

Plug 'bling/vim-airline'
Plug 'edkolev/tmuxline.vim'
Plug 'christoomey/vim-tmux-navigator'

" Plug 'ajh17/VimCompletesMe'
Plug 'valloric/YouCompleteMe', { 'do' : 'python3 install.py --clang-completer', 'for' : 'cpp' }
Plug 'rdnetto/YCM-Generator', { 'branch' : 'stable' }

Plug 'ludovicchabant/vim-gutentags'
Plug 'skywind3000/gutentags_plus'
Plug 'majutsushi/tagbar'

" Plug 'fotanus/fold_license'
" Plug 'SirVer/ultisnips'

if osys != "Windows"
    if has("nvim")
       " Plug 'sakhnik/nvim-gdb', { 'do' : './install.sh' }
    endif
endif

call plug#end()
" }}}
" {{{ misc settings
" leader to space
let mapleader = " "

set textwidth=120

" tab/indentation
set shiftwidth=4
set autoindent
set smartindent
set softtabstop=4
set expandtab

" jump to last edited position
if has("autocmd")
    autocmd BufReadPost *
                \ if line("'\"") > 0 && line("'\"") <= line("$") |
                \    exe "normal g'\"" |
                \    exe "normal zz" |
                \ endif
" except for gitcommit
    autocmd FileType gitcommit exe "normal gg"
endif

" use mouse wheel for scrolling in normal mode
set mouse=n

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

set scrolloff=5

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
set nowb
set noswapfile

set showcmd
set showmatch
set hlsearch
set incsearch
set smartcase

set maxmempattern=2000000

set autochdir

set autoread

set noerrorbells
set visualbell t_vb=

set showfulltag
set lazyredraw
set whichwrap+=<,>,[,]

" flattened
colorscheme flattened_light

if has("syntax")
    syntax on
endif
" }}}
" {{{ splits
" easier navigation between splits
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

set splitbelow
set splitright
" }}}
" {{{ folding
if has("folding")
    set foldlevelstart=5
    set foldenable
    set foldmethod=indent
end
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

" Per default, netrw leaves unmodified buffers open. This autocommand
" deletes netrw's buffer once it's hidden (using ':q', for example)
autocmd FileType netrw setl bufhidden=delete

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
" TODO check if clang-tidy is there
let g:syntastic_cpp_checkers = [ 'check' ]

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

function! SyntasticCheckHook(errors)
    if !empty(a:errors)
        let g:syntastic_loc_list_height = min([len(a:errors), 10])
    endif
endfunction
" call SyntasticToggleMode

" }}}
" {{{ tags
" look til root for tags files
set tags=./tags;/

let g:gutentags_modules = [ 'ctags', 'gtags_cscope' ]
let g:gutentags_cache_dir = expand('~/.cache/tags')
let g:gutentags_auto_add_gtags_cscope = 0

" remap of jump to tag for german keyboard
nnoremap ü <C-]>

" map for tagbar
nmap <F8> :TagbarToggle<CR>
" }}}
" {{{ completion
" let g:ycm_global_ycm_extra_conf = '~/.ycm_extra_conf.py'
let g:ycm_confirm_extra_conf = 0
" }}}
" {{{ tmux related
" 1 - write current buffer if changed, 2 - :wa
let g:tmux_navigator_save_on_switch = 2
let g:tmux_navigator_disable_when_zoomed = 1
" }}}
" {{{ c++ specific
if has("autocmd")
    autocmd BufRead,BufNewFile *.h,*.cpp setlocal commentstring=//\ %s " use // for commentary
    autocmd BufRead,BufNewFile *.h,*.cpp set colorcolumn=80          " highlight col 80
    autocmd BufRead,BufNewFile *.h,*.cpp set filetype=cpp.doxygen    " set doxygen subtype
endif
    au BufNewFile,BufRead *.cpp,*.h syn region myCComment start="/\*" end="\*/" fold keepend transparent
" }}}
" vim: set shiftwidth=4 softtabstop=4 expandtab tw=120 foldlevel=0
