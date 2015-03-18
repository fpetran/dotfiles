" my custom vimrc - should work for all systems

" vundle
set nocompatible
filetype off
set rtp+=~/.vim/bundle/vundle
call vundle#rc()
Plugin 'gmarik/vundle'

" vundle packages
Plugin 'tpope/vim-fugitive'
Plugin 'tpope/vim-surround'
Plugin 'tpope/vim-dispatch'
Plugin 'tpope/vim-speeddating'
Plugin 'szw/vim-g'
Bundle 'Valloric/YouCompleteMe'
Bundle 'bling/vim-airline'
Bundle 'scrooloose/nerdtree'
Plugin 'Mizuchi/STL-Syntax'
Bundle 'josephcc/vim-lfg-highlight'
Bundle 'a.vim'
Bundle 'taglist.vim'
Bundle 'majutsushi/tagbar'
Bundle 'altercation/vim-colors-solarized'
Bundle 'chrisbra/csv.vim'
Plugin 'bronson/vim-trailing-whitespace'
Plugin 'airblade/vim-gitgutter'
Plugin 'SirVer/ultisnips'
Plugin 'honza/vim-snippets'
Plugin 'ggreer/the_silver_searcher'

filetype plugin indent on

if has("win32") || has("win16")
    let osys="mswin"
    behave mswin
elseif has("unix")
    let osys="Linux"
elseif has("macunix")
    let osys="Darwin"
else
    " for unknown reasons uname -s appends a newline at the end of the
    " string. therefore, the two previous cases are necessary
    let osys=system('uname -s')
endif

" terminal
if (&term =~ "xterm") && (&termencoding == "")
    set termencoding=utf-8
endif

" jump to last edited position
" see :help last-position-jump
if has("autocmd")
    au BufReadPost *
                \ if line("'\"") > 0 && line("'\"") <= line("$") |
                \   exe "normal g'\"" |
                \   exe "normal zz" |
                \ endif
endif

if &term =~ "xterm"
    " xterm titles
    if has('title')
        set title
    endif

    if exists('&t_SI')
        let &t_SI = "\<Esc>]12;lightgoldenrod\x7"
        let &t_SI = "\<Esc>]12;grey80\x7"
    endif
endif

" settings
set nocompatible
set viminfo='1000,f1,:1000,/1000
set history=500
set backspace=indent,eol,start
set nobackup
set showcmd
set showmatch
set hlsearch
set incsearch

set maxmempattern=2000000

" case sensitivity for cpp files
if has("autocmd")
    autocmd BufEnter *
                \ if &filetype == "cpp" |
                \   set noignorecase noinfercase |
                \ else |
                \   set ignorecase infercase |
                \ endif
else
    set ignorecase
    set infercase
endif

" highlight column 80 for cpp files
" set file subtype to doxygen
if has("autocmd")
    autocmd BufRead,BufNewFile *.h,*.cpp set colorcolumn=80
    autocmd BufRead,BufNewFile *.h,*.cpp set filetype=cpp.doxygen
    autocmd BufRead,BufNewFile *.h,*.cpp nnoremap <F5> :make<CR>
endif

" show full tags for auto completion
set showfulltag
set lazyredraw

" no error noises
set noerrorbells
set visualbell t_vb=
if has("autocmd")
    autocmd GUIEnter * set visualbell t_vb=
endif

" scrolling
set scrolloff=3
set sidescrolloff=2

set whichwrap+=<,>,[,]

" tab completion
set wildmenu
" ignore these for completion
set wildignore+=*.o,*~,*.lo,*.exe,*.com,*.pdf,*.ps,*.dvi
set suffixes+=.in,.a

if has("syntax")
    syntax on
endif

set virtualedit=block,onemore

" fonts
if has("win32")
    " set guifont=Lucida\ Console
    set guifont=Anonymous_Pro:h11
    "set guifont=Monaco:h10
else
    set guifont=Source\ Code\ Pro\ for\ Powerline\ Medium\ 12
    "set guifont=DejaVu\ Sans\ Mono\ 12
endif

" Toolbar & scrollbars off
if has('gui')
    set guioptions-=T
    set guioptions-=r
    set guioptions-=R
endif


" colorscheme
if has("eval")
    fun! LoadColorScheme(schemes)
        let l:schemes = a:schemes . ":"
        while l:schemes != ""
            let l:scheme = strpart(l:schemes, 0, stridx(l:schemes, ":"))
            let l:schemes = strpart(l:schemes, stridx(l:schemes, ":") + 1)
            try
                exec "colorscheme" l:scheme
                break
            catch
            endtry
        endwhile
    endfun

    if has('gui')
        call LoadColorScheme("solarized:inkpot:night:rainbow_night:darkblue:elflord")
    else
        if has("autocmd")
            autocmd VimEnter *
                        \ if &t_Co == 88 || &t_Co == 256 |
                        \   call LoadColorScheme("inkpot:darkblue:elflord") |
                        \ else |
                        \   call LoadColorScheme("darkblue:elflord") |
                        \ endif
        else
            if &t_Co == 88 || &t_Co == 256
                call LoadColorScheme("inkpot:darkblue:elflord")
            else
                call LoadColorScheme("darkblue:elflord")
            endif
        endif
    endif
endif

" indenting
set shiftwidth=4
set autoindent
set smartindent

" tab to ws conversion
set softtabstop=4
set expandtab
set tw=120

" folds
if has("folding")
    set foldenable
    set foldmethod=indent
    set foldlevelstart=99
endif

set popt+=syntax:y

" filetype
if has("eval")
    filetype on
    filetype plugin on
    filetype indent on
endif

" secure modelines
if filereadable(expand("$VIM/vimfiles/plugin/securemodelines.vim"))
    set nomodeline
    let g:secure_modelines_verbose = 0
    let g:secure_modelines_modelines = 15
endif

" ultisnips ===========================================================
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<c-b>"
let g:UltiSnipsJumpBackwardTrigger="<c-z>"
let g:UltiSnipsEditSplit="vertical"

" tagbar.vim
" TODO add conditional
nmap <F8> :TagbarToggle<CR>

" title bar ===========================================================
if has('title') && (has('gui_running') || &title)
    set titlestring=
    " file name
    set titlestring+=%f
    " flags
    set titlestring+=%h%m%r%w
    " program name
    set titlestring+=\ -\ %{v:progname}
    " working dir
    set titlestring+=\ -\ %{substitute(getcwd(),\ $HOME,\ '~',\ '')}
endif

if v:version >= 700
    try
        setlocal numberwidth=3
    catch
    endtry
endif

if has("gui_running") && v:version >= 700
    set cursorline
end

" include $HOME in cdpath
if has("file_in_path")
    let &cdpath=",".expand("$HOME").','.expand("$HOME").'/src'
endif

" for include paths
set path+=src/
let &inc.=' ["<]'

" show tabs and trailing whitespace
if (&termencoding == "utf-8") || has("gui_running")
    if v:version >= 700
        if has("gui_running")
            set list listchars=tab:»·,trail:·,extends:¿,nbsp:¿
        else
            " xterm + terminus hates these
            set list listchars=tab:»·,trail:·,extends:>,nbsp:_
        endif
    else
        set list listchars=tab:»·,trail:·,extends:¿
    endif
else
    if v:version >= 700
        set list listchars=tab:>-,trail:.,extends:>,nbsp:_
    else
        set list listchars=tab:>-,trail:.,extends:>
    endif
endif

set fillchars=fold:-

" winmanager.vim settings
if filereadable(expand("$VIM/vimfiles/plugin/winmanager.vim"))
    let g:winManagerWindowLayout = 'FileExplorer,TagsExplorer'
endif

""""""""""""""""""""""""""""""""""""""""""""
" spelling for latex files
"
""""""""""""""""""""""""""""""""""""""""""""
if has("autocmd")
    autocmd BufEnter *
                \ if &filetype == "latex" |
                \   set spell |
                \ else |
                \   set nospell |
                \ endif
endif
" vim-latex settings ==============================================================
if filereadable(expand("$VIM/vimfiles/ftplugin/tex_latexSuite.vim")) || filereadable(expand("$VIM/addons/ftplugin/tex_latexSuite.vim"))
    let g:Tex_DefaultTargetFormat = 'pdf'
    " auto reload logfiles for vim-latex
    if has("autocmd")
        autocmd BufRead *.log set ar
    endif
    " various IMAPS for vim-latex
    if has("autocmd")
        " beamer frame
        autocmd BufNewFile,BufRead *.tex call IMAP('BFA', "\\begin{frame}{<++>}\<CR><++>\<CR>\\end{frame}<++>", 'tex')
        " beamer frame with automatic stops, idk if this works
        autocmd BufNewFile,BufRead *.tex call IMAP('BFS', "\\begin{frame}[<+->]{<++>}\<CR><++>\<CR>\\end{frame}<++>", 'tex')
        " block
        autocmd BufNewFile,BufRead *.tex call IMAP('BBA', "\\begin{block}{<++>}\<CR><++>\<CR>\\end{block}<++>", 'tex')
        " covington example
        autocmd BufNewFile,BufRead *.tex call IMAP('EXE', "\\begin{example}\<CR><++>\<CR>\\end{example}<++>", 'tex')
        " covington examples
        autocmd BufNewFile,BufRead *.tex call IMAP('EXS', "\\begin{examples}\<CR>\\item <++>\<CR>\\end{examples}<++>", 'tex')
    endif
    " don't check spelling in comments
    let g:tex_comment_nospell = 1

    if osys == "Darwin"
        let g:Tex_ViewRule_ps = 'Preview'
        let g:Tex_ViewRule_pdf = 'Skim'
        let g:Tex_ViewRule_dvi = 'TeXniscope'

        " g:Tex_TreatMacViewerAsUNIX
        " let g:Tex_CompileRule_pdf = 'vimlatex.sh pdflatex -interaction=nonstopmode $*'
        " let g:Tex_CompileRule_ps = 'vimlatex.sh dvips -Ppdf -o $*.ps $*.dvi'
        " let g:Tex_CompileRule_dvi = 'vimlatex.sh latex -interaction=nonstopmode $*'
    elseif osys == "Linux"
        " this is needed to prevent vim from setting the filetype to plaintex
        let g:tex_flavor='latex'
        if filereadable("/usr/bin/okular")
        " if has("gui_kde")
            let g:Tex_ViewRule_ps = 'okular'
            let g:Tex_ViewRule_pdf = 'okular'
            let g:Tex_ViewRule_dvi = 'okular'
        " elseif has("gui_gtk")
        elseif filereadable("/usr/bin/evince")
            let g:Tex_ViewRule_ps = 'evince'
            let g:Tex_ViewRule_pdf = 'evince'
        endif
        set grepprg=grep\ -nH\ $*
    elseif osys == "mswin"
        " sumatraPDF does auto reload while acroread just locks
        " the file so it cannot be changed
        let g:Tex_ViewRule_pdf = 'SumatraPDF'
        " TODO ps/dvi?
        set shellslash
        " TODO
    endif
endif

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" vim-airline
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" always show status bar
set laststatus=2
" show buffers in airline
let g:airline#extensions#tabline#enabled = 1
" powerline fonts
let g:airline_powerline_fonts = 1
" powerline symbols
if !exists('g:airline_symbols')
    let g:airline_symbols = {}
endif
let g:airline_symbols.space = "\ua0"
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" completion
set dictionary=/usr/share/dict/words

" turn off existing hlsearch
if has("autocmd")
    autocmd BufEnter * nohls
endif

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" this stuff is unix specific, atm
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" docx converter
" TODO doesn't work
if has("autocmd")
    if filereadable("/usr/local/bin/docx2txt.pl")
        autocmd BufReadPre *.docx set ro
        autocmd BufReadPost *.docx %!docx2txt.pl
    endif
endif

" assume out of source build if CMakeLists.txt is
" present in the current directory
" TODO needs to descend farther than just one directory
if has("autocmd")
    autocmd BufNewFile,BufRead *
                \ if filereadable("./CMakeLists.txt")   |
                \   let builddir=findfile('build', ';') |
                \   let buildcmd='make -C ' . builddir  |
                \   let &makeprg=buildcmd               |
                \ endif
endif

fun! g:BuildOOS()
    let toplevelpath = FindTopLevelProjectDir()
    let builddir = toplevelpath . "build/"
    :execute 'make -C ' . builddir
endfun

fun! FindTopLevelProjectDir()
    let isittopdir = finddir('.git')
    if isittopdir ==? ".git"
        return getcwd()
    endif
    let gitdir = finddir('.git', ';')
    let gitdirsplit = split(gitdir, '/')
    let toplevelpath = '/' . join(gitdirsplit[:-2], '/')
    return toplevelpath
endfun
nnoremap <F4> :call g:BuildOOS()

" ctags related stuff
if has("ctags")
    " look up til root for tags files
    set tags=./tags;/
    " open definition in new tab
    map <C-\> :tab split<CR>:exec("tag ".expand("<cword>"))<CR>
    " open definition in vert split
    map <C-]> :vsp <CR>:exec("tag ".expand("<cword>"))<CR>
endif
if has("cscope")
    set csto=0
    set cst
    set nocsverb
    if filereadable("cscope.out")
        cs add cscope.out
    elseif $CSCOPE_DB != ""
        cs add $CSCOPE_DB
    endif
endif

" buffer mappings because it annoys me to have to type <ESC>:bp<CR>
" \l            list buffers
" \b \f \g      back/forward/last
" \1 \2 \3      buffer 1/2/3
" TODO \b takes way more time than \f, idk why
nnoremap <Leader>l :ls<CR>
nnoremap <Leader>b :bp<CR>
nnoremap <Leader>f :bn<CR>
nnoremap <Leader>g :e#<CR>
nnoremap <Leader>1 :1b<CR>
nnoremap <Leader>2 :2b<CR>
nnoremap <Leader>3 :3b<CR>
nnoremap <Leader>4 :4b<CR>
nnoremap <Leader>5 :5b<CR>
nnoremap <Leader>6 :6b<CR>
nnoremap <Leader>7 :7b<CR>
nnoremap <Leader>8 :8b<CR>
nnoremap <Leader>9 :9b<CR>
nnoremap <Leader>0 :10b<CR>

" auto cd into the directory of the file
set autochdir

"-----------------------------------------------------------------------
" vim: set shiftwidth=4 softtabstop=4 expandtab tw=120                 :
