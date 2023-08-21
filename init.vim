" vim: fdm=marker foldlevelstart=0
" {{{ misc settings
set encoding=utf-8
scriptencoding utf-8
filetype indent plugin on
let mapleader = " "
if has('termguicolors')
    set termguicolors
endif
set shiftwidth=4
set autoindent
set smartindent
set softtabstop=4
set expandtab
set mouse=n
set relativenumber
set number
set cursorline
set list listchars=tab:>-,trail:.,extends:>,nbsp:_
set wildignore+=*.o,*~,*.lo,*.exe,*.com,*.pdf,*.ps,*.dvi,*.pyc
set suffixes+=.in,.a
set nobackup
set nowritebackup
set nowb
set noswapfile
set showcmd
set showmatch
set hlsearch
set smartcase
set maxmempattern=2000000
set noerrorbells
set visualbell t_vb=
set showfulltag
set lazyredraw
set whichwrap+=<,>,[,]
set splitbelow
set splitright

augroup textwidth
    autocmd!
    autocmd BufRead,BufNewFile *.h,*.cpp setlocal textwidth=120
augroup END
set textwidth=80

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

" }}}
" {{{ plugins
lua require('config/lazy')
" }}}
" {{{ misc keybindings
" insert 80 dashes
nnoremap <leader>-- A<space><Esc>80A-<Esc>d80<bar>
nnoremap <leader>== A<space><Esc>80A=<Esc>d80<bar>
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
        autocmd BufRead,BufNewFile *.h,*.hxx set foldmethod=marker
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
" {{{ language client
set hidden " required for renaming, etc.
" treesitter/lsp/etc lua setup
lua require('config/lsp')
" }}}
" {{{ c++ specific
" TODO put this in a filetype
if has("autocmd")
    augroup cpp_stuff
        autocmd!
        autocmd BufRead,BufNewFile *.h,*.hxx,*.cpp,*.cxx set colorcolumn=100          " highlight column
        autocmd BufRead,BufNewFile *.h,*.hxx,*.cpp,*.cxx set matchpairs+=<:>        " use <> for bracket matching (for templates)
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
