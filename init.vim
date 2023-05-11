" vim: fdm=marker foldlevelstart=0
set encoding=utf-8
scriptencoding utf-8
filetype indent plugin on
" {{{ plugins
lua require('config/plugins')
" }}}
" {{{ theme and look
if has('termguicolors')
    set termguicolors
endif
lua require('config/theme')
" }}}
" {{{ misc settings
" leader to space
let mapleader = " "

augroup textwidth
    autocmd!
    autocmd BufRead,BufNewFile *.h,*.cpp setlocal textwidth=120
augroup END
set textwidth=80

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
set nowritebackup
set nowb
set noswapfile

set showcmd
set showmatch
set hlsearch
set incsearch
set smartcase

set maxmempattern=2000000

" set autochdir
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
" {{{ misc keybindings
" nnoremap <silent> <C-p> :Files<CR>
" nnoremap <silent> <C-o> :Buffers<CR>
" nnoremap <silent> <C-i> :Rg<CR>
" insert 80 dashes
nnoremap <leader>-- A<space><Esc>80A-<Esc>d80<bar>
nnoremap <leader>== A<space><Esc>80A=<Esc>d80<bar>

nnoremap <silent> <leader>ws :FixWhitespace<CR>
nnoremap <leader>af :Autoformat<CR>

nnoremap <leader>ff <cmd>lua require('telescope.builtin').find_files()<cr>
nnoremap <leader>fg <cmd>lua require('telescope.builtin').live_grep()<cr>
nnoremap <leader>fb <cmd>lua require('telescope.builtin').buffers()<cr>
nnoremap <leader>fh <cmd>lua require('telescope.builtin').help_tags()<cr>

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

function! DoxygenMode()
    set foldlevelstart=99
    set foldlevel=99
endfunction
nnoremap <F9> :call DoxygenMode()<CR>

if has("folding")
    set foldenable
    augroup cpp_fold
        au!
        autocmd BufRead,BufNewFile *.h set foldmethod=marker
                    \| set foldmarker=/**,*/
                    \| set foldtext=CppDoxyFoldText()
                    \| silent g/\/\*\*/foldc
    augroup END
    augroup json_fold
        au!
        autocmd BufRead,BufNewFile *.json set foldmethod=syntax
    augroup END
end
" }}}
" {{{ completion, snippets
set completeopt=menu,menuone,noselect
" set completeopt=noinsert,menuone,noselect
" let g:coq_settings = { 'auto_start': 'shut-up', 'keymap.jump_to_mark': '<C-n>' }
lua require('config/completion')

" completion-nvim
" <Tab> and <S/Tab> to navigate popup
" inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
" inoremap <expr> <S-Tab> pumvisible() ? "\<C-n>" : "\<S-Tab>"

" set shortmess+=c

" let g:completion_enable_snippet = 'UltiSnips'

" " " inoremap <silent> <expr> <CR> ncm2_ultisnips#expand_or("\<CR>", 'n')
" let g:UltiSnipsExpandTrigger="<tab>"
" let g:UltiSnipsJumpForwardTrigger = "<c-j>"
" let g:UltiSnipsJumpBackwardTrigger = "<c-k>"
" let g:UltiSnipsRemoveSelectModeMappings = 0

" let g:UltiSnipsSnippetDirectories=['customsnips']
" }}}
" {{{ language client

set hidden " required for renaming, etc.
" treesitter/lsp/etc lua setup
lua require('config/lsp')
" }}}
" {{{ tmux related
" 1 - write current buffer if changed, 2 - :wa
let g:tmux_navigator_save_on_switch = 2
let g:tmux_navigator_disable_when_zoomed = 1
" }}}
" {{{ latex
let g:tex_flavor = 'latex'
" }}}
" {{{ c++ specific
" TODO put this in a filetype
if has("autocmd")
    autocmd FileType cmake setlocal commentstring=#\ %s
    augroup cpp_stuff
        autocmd!
        autocmd BufRead,BufNewFile *.h,*.cpp setlocal commentstring=//\ %s " use // for commentary
        autocmd BufRead,BufNewFile *.h,*.cpp set colorcolumn=120          " highlight column
        autocmd BufRead,BufNewFile *.h,*.cpp set matchpairs+=<:>        " use <> for bracket matching (for templates)
        " autocmd BufRead,BufNewFile *.h,*.cpp,*.dox set filetype=cpp.doxygen    " set doxygen subtype
        " autocmd BufRead,BufNewFile *.template.h,*.template.cpp set filetype=jinja.cpp
    augroup END
endif

if has("autocmd")
    augroup json_foldlevel
        autocmd!
        autocmd BufRead,BufNewFile *.json set foldlevelstart=99
    augroup END
endif
" }}}
" vim: set shiftwidth=4 softtabstop=4 expandtab tw=120 foldlevel=0
