scriptencoding utf-8
" my custom vimrc - should work for all systems
" TODO
"
" console vim sometimes behaves weird - duplicates lines and stuff
" - how can that be changed? try to reproduce!
"
" line folding - auto line break pisses me off - should be changed
"
" vim-latex fixes for error output and stuff from the ML
" - should be conditionally included
"
" ctags integration
" - i'm sure there's scripting for that
"
" nohls doesn't work for whatever reason
" - has to be manually entered
"
" font for Mac OSX

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

if osys=="Linux"
    set runtimepath+=/usr/share/vim/addons
endif

" terminal

if (&term =~ "xterm") && (&termencoding == "")
    set termencoding=utf-8
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

set winminheight=1

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
    if has("gui_kde")
        set guifont=Terminus/12/-1/5/50/0/0/0/0/0
    elseif has("gui_gtk")
        set guifont=DejaVu\ Sans\ Mono\ 12
    elseif has("gui_running")
        set guifont=-xos4-terminus-medium-r-normal--12-140-72-72-c-80-iso8859-1
    endif
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
        "call LoadColorScheme("elflord")
        call LoadColorScheme("inkpot:night:rainbow_night:darkblue:elflord")
    else
        if has("autocmd")
            " code
            autocmd VimEnter *
                        \ if &t_Co == 88 || &t_Co == 256 |
                        \   call LoadColorScheme("inkpot:darkblue:elflord") |
                        "\   call LoadColorScheme("elflord") |
                        \ else |
                        \   call LoadColorScheme("darkblue:elflord") |
                        "\   call LoadColorScheme("elflord") |
                        \ endif
            " freitext
            " call LoadColorScheme("morning")
        else
            if &t_Co == 88 || &t_Co == 256
                call LoadColorScheme("inkpot:darkblue:elflord")
                "call LoadColorScheme("elflord")
            else
                call LoadColorScheme("darkblue:elflord")
                "call LoadColorScheme("elflord")
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

" tagbar.vim
" TODO add conditional
nmap <F8> :TagbarToggle<CR>

"----------------------------------------
" status bar stuff
" DEPRECATED: I use vim-airline now
"----------------------------------------
"set laststatus=2
"set statusline=
" buffer number
"set statusline+=%2*%-3.3n%0*\ 
"" file name
"set statusline+=%f\ 
"" scm ...
"" flags
"set statusline+=%h%1*%m%r%w%0*
"" filetype
"set statusline+=\[%{strlen(&ft)?&ft:'none'}\ 
"" encoding
"set statusline+=%{&encoding}\ 
"" file format
"set statusline+=%{&fileformat}]
"" right align
"set statusline+=%=
"" current char
"set statusline+=%2*0x%-8B\ 
"" offset
"set statusline+=%-14.(%l,%c%V%)\ %<%P

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
    let &cdpath=",".expand("$HOME").','.expand("$HOME").'/work'
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


" no tab highlighting for vim outliner files
if has("autocmd")
    autocmd BufEnter *
                \ if &filetype == "vo_base" |
                \   set nolist |
                \ endif
endif

" winmanager.vim settings
if filereadable(expand("$VIM/vimfiles/plugin/winmanager.vim"))
    let g:winManagerWindowLayout = 'FileExplorer,TagsExplorer'
endif

" vim-latex settings
if filereadable(expand("$VIM/vimfiles/ftplugin/tex_latexSuite.vim")) || filereadable(expand("$VIM/addons/ftplugin/tex_latexSuite.vim"))
    let g:Tex_DefaultTargetFormat = 'pdf'
    " auto reload logfiles for vim-latex
    if has("autocmd")
        autocmd BufRead *.log set ar
    endif
    " mapping for beamer frames in vim-latex
    if has("autocmd")
        autocmd BufNewFile,BufRead *.tex call IMAP('BFA', "\\begin{frame}{<++>}\<CR><++>\<CR>\\end{frame}", 'tex')
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
" show buffers in airline
let g:airline#extensions#tabline#enabled = 1


" completion
set dictionary=/usr/share/dict/words

" turn off existing hlsearch
if has("autocmd")
    autocmd VimEnter * nohls
endif

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" this stuff is unix specific, atm
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" docx converter
if has("autocmd")
    if filereadable("/usr/local/bin/docx2txt.pl")
        autocmd BufReadPre *.docx set ro
        autocmd BufReadPost *.docx %!docx2txt.pl
    endif
endif

" use C++11 syntax for .cpp files
"if has("autocmd")
    "autocmd BufNewFile,BufRead *.cpp set syntax=cpp11
"endif

" assume out of source build if CMakeLists.txt is
" present in the current directory
if has("autocmd")
    autocmd BufNewFile,BufRead *
                \ if filereadable("./CMakeLists.txt") |
                \   set makeprg=make\ -C\ ../build    |
                \ endif
endif

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

" auto cd into the directory of the file
set autochdir

"-----------------------------------------------------------------------
" vim: set shiftwidth=4 softtabstop=4 expandtab tw=120                 :
