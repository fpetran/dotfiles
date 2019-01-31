" vim: fdm=marker foldlevelstart=0
" TODO:
" - stdpath is not available in normal vim
" - plugged autoinstall
set encoding=utf-8
scriptencoding utf-8
filetype indent plugin on

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
" {{{ plugins
call plug#begin(stdpath('config')."/plugged")

Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-commentary'
if !has('nvim')
    Plug 'tpope/vim-sensible'
endif
Plug 'mhinz/vim-signify'
Plug 'bronson/vim-trailing-whitespace'

Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'

Plug 'NLKNguyen/papercolor-theme'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'edkolev/tmuxline.vim'
Plug 'christoomey/vim-tmux-navigator'
Plug 'tmux-plugins/vim-tmux-focus-events'

Plug 'elzr/vim-json', { 'for': 'json' }

Plug 'rhysd/vim-clang-format'
Plug 'LucHermitte/lh-vim-lib' | Plug 'LucHermitte/alternate-lite'

Plug 'autozimu/LanguageClient-neovim', { 'branch' : 'next', 'do' : 'bash install.sh' }
if has ('nvim')
    Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
else
    Plug 'Shougo/deoplete.nvim'
    Plug 'roxma/nvim.yarp'
    Plug 'roxma/vim-hug-neovim-rpc'
endif

Plug 'Shougo/neosnippet.vim' | Plug 'Shougo/neosnippet-snippets'
Plug 'w0rp/ale'
" Plug 'valloric/YouCompleteMe', { 'on': [], 'do' : 'python3 install.py --clang-completer' }
" Plug 'SirVer/ultisnips', { 'on': [] } | Plug 'honza/vim-snippets'
" Plug 'ervandew/supertab'

Plug 'ludovicchabant/vim-gutentags' | Plug 'skywind3000/gutentags_plus'
Plug 'majutsushi/tagbar'

call plug#end()

" defer loading ycm, ultisnips on first InsertEnter
augroup load_us_ycm
    autocmd!
    autocmd InsertEnter * call plug#load('ultisnips', 'YouCompleteMe')
                \| autocmd! load_us_ycm
augroup END
" }}}
" {{{ colorscheme
if has('termguicolors')
    set termguicolors
endif
set background=light
colorscheme PaperColor
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

augroup jump_to_last_edited
    autocmd!
    autocmd BufReadPost *
                \ if line("'\"") > 0 && line("'\"") <= line("$") |
                \    exe "normal g'\"" |
                \    exe "normal zz" |
                \ endif
    " except for gitcommit
    autocmd BufReadPost COMMIT_EDITMSG
                \ exe "normal! gg"
augroup END

" use mouse wheel for scrolling in normal mode
set mouse=n
" hybrid line numbering
if v:version >= 704
    set relativenumber
    set number
endif
" cursor line
if v:version >= 700
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

" TODO add @param, @returns?
" fold text for doxygen comments
function! CppDoxyFoldText()
    let line = substitute(getline(v:foldstart), '/\*\*', '', 'g')
    let stripped_line = substitute(line, '^\s*\(.\{-}\)\s*$', '\1', '')
    if strlen(stripped_line) == 0
        let line = substitute(getline(v:foldstart + 1), '\*', '', 'g')
        let stripped_line = substitute(line, '^\s*\(.\{-}\)\s*$', '\1', '')
    endif
    let padding = substitute(getline(v:foldstart), '/\*\*.*$', '', '')
    return padding . stripped_line
endfunction

if has("folding")
    set foldlevelstart=3
    set foldenable
    augroup cpp_fold
        autocmd FileType cpp.doxygen set foldmethod=marker
                                  \| set foldmarker=/**,*/
                                  \| set foldtext=CppDoxyFoldText()
                                  \| g/\/\*\*/foldc
    augroup END
end
" }}}
" {{{ airline
set laststatus=2
let g:airline#extensions#tabline#enabled = 1
let g:airline_powerline_fonts = 1
if !exists('g:airline_symbols')
    let g:airline_symbols = {}
endif
let g:airline_symbols.space = "\ua0"
let g:airline_theme = 'papercolor'
let g:airline#extensions#tabline#formatter = 'unique_tail'
" }}}
" {{{ language client/deoplete
" deoplete
let g:deoplete#enable_at_startup = 1
call deoplete#custom#source('LanguageClient',
            \ 'min_pattern_length',
            \ 2)

set hidden " required for renaming, etc.
let g:LanguageClient_serverCommands = {
            \ 'cpp' : [ 'ccls' ],
            \ 'cpp.doxygen' : [ 'ccls' ],
            \ 'c' : [ 'ccls' ]
            \ }
let g:LanguageClient_autoStart = 1
let g:LanguageClient_loadSettings = 1
let g:LanguageClient_settingsPath = expand("~/.config/nvim/settings.json")
let g:LanguageClient_rootMarkers = {
            \ 'cpp': ['compile_commands.json', '.project'],
            \ 'cpp.doxygen': ['compile_commands.json', '.project']
            \}
let g:LanguageClient_hasSnippetSupport = 0

function! LCMappings()
    set completefunc=LanguageClient#complete
    set formatexpr=LanguageClient_textDocument_rangeFormatting()
    nnoremap <F5> :call LanguageClient_contextMenu()<CR>
    nnoremap <silent> gh :call LanguageClient#textDocument_hover()<CR>
    nnoremap <silent> gd :call LanguageClient#textDocument_definition()<CR>
    nnoremap <silent> gr :call LanguageClient#textDocument_references({'includeDeclaration': v:false})<CR>
    nnoremap <silent> gs :call LanguageClient#textDocument_documentSymbol()<CR>
    nnoremap <silent> <F2> :call LanguageClient#textDocument_rename()<CR>
endfunction

augroup LanguageClient_config
    au!
    au BufEnter * let b:Plugin_LanguageClient_started = 0
    au User LanguageClientStarted setl signcolumn=yes
    au User LanguageClientStarted let b:Plugin_LanguageClient_started = 1
    au User LanguageClientStopped setl signcolumn=auto
    au User LanguageClientStopped let b:Plugin_LanguageClient_started = 0
    au CursorMoved * if b:Plugin_LanguageClient_started | sil call LanguageClient#textDocument_documentHighlight() | endif
    au FileType cpp,cpp.doxygen :call LCMappings()
augroup END
" }}}
" {{{ IDE functionality (lint, snippets, tags)
" language client
" ALE config
let g:ale_linters = {'cpp': [], 'c': [] } " using languageclient for cpp and c
let g:ale_cache_executable_check_failures = 1
let g:airline#extensions#ale#enabled = 1

" make ycm work with ultisnips using supertab
let g:ycm_key_list_select_completion = [ '<C-n>', '<Down>' ]
let g:ycm_key_list_previous_completion = [ '<C-p>', '<Up>' ]
let g:SuperTabDefaultCompletionType = '<C-n>'
let g:UltiSnipsExpandTrigger = "<tab>"
let g:UltiSnipsJumpForwardTrigger = "<tab>"
let g:UltiSnipsJumpBackwardTrigger = "<s-tab>"

" custom snippets
let g:UltiSnipsSnippetDirectories = [ expand("~/.config/nvim/customsnips") ]
" let g:neosnippet#snippets_directory = [ expand("~/.config/nvim/customsnips") ]

" gutentags
set tags=./tags;/
let g:gutentags_modules = [ 'ctags', 'gtags_cscope' ]
let g:gutentags_cache_dir = expand('~/.cache/tags')
" line below is important so keobuilder deps get tagged as well
let g:gutentags_project_root = [ '.project' ]
let g:gutentags_auto_add_gtags_cscope = 0
function! GutentagsStatus(...)
    let w:airline_section_a = '%{gutentags#statusline()}'
endfunction

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
    autocmd FileType cmake setlocal commentstring=#\ %s
    augroup cpp_stuff
        autocmd!
        autocmd BufRead,BufNewFile *.h,*.cpp setlocal commentstring=//\ %s " use // for commentary
        autocmd BufRead,BufNewFile *.h,*.cpp set colorcolumn=120          " highlight column
        autocmd BufRead,BufNewFile *.h,*.cpp set filetype=cpp.doxygen    " set doxygen subtype
    augroup END
endif

" au BufNewFile,BufRead *.cpp,*.h syn region myCComment start="/\*" end="\*/" fold keepend transparent
" }}}
" vim: set shiftwidth=4 softtabstop=4 expandtab tw=120 foldlevel=0
