" vim: fdm=marker foldlevelstart=0
" TODO:
" - stdpath is not available in normal vim
" - plugged autoinstall
set encoding=utf-8
scriptencoding utf-8
filetype indent plugin on

" {{{ attempt plugged autoinstall
" TODO doesn't work
" if empty(glob('~/.vim/autoload/plug.vim))
" silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
"  \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim autocmd
" VimEnter * PlugInstall --sync | source $MYVIMRC
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
Plug 'nvim-lua/plenary.nvim' | Plug 'lewis6991/gitsigns.nvim'


Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'

" themes
Plug 'marko-cerovac/material.nvim'
Plug 'Th3Whit3Wolf/space-nvim'
Plug 'ishan9299/nvim-solarized-lua'
Plug 'tanvirtin/monokai.nvim'
Plug 'Iron-E/nvim-highlite'
Plug 'rafamadriz/neon'
Plug 'sainnhe/everforest'

" airline
Plug 'hoob3rt/lualine.nvim'
Plug 'kyazdani42/nvim-web-devicons'
" icons without colors
" Plug 'ryanoasis/vim-devicons'
Plug 'akinsho/nvim-bufferline.lua'

" tmux
Plug 'christoomey/vim-tmux-navigator'
Plug 'tmux-plugins/vim-tmux-focus-events'
Plug 'tmux-plugins/vim-tmux'
Plug 'roxma/vim-tmux-clipboard'

" misc specific
Plug 'elzr/vim-json', { 'for': 'json' }
Plug 'lervag/vimtex'
Plug 'evedovelli/rst-robotframework-syntax-vim'
Plug 'Glench/Vim-Jinja2-Syntax'
Plug 'inkarkat/vim-ingo-library' | Plug 'inkarkat/vim-SyntaxRange'
Plug 'folke/which-key.nvim'
Plug 'famiu/bufdelete.nvim'

" linting and formatting
Plug 'Chiel92/vim-autoformat'
Plug 'bronson/vim-trailing-whitespace'
Plug 'Yggdroot/indentLine'

Plug 'LucHermitte/lh-vim-lib' | Plug 'LucHermitte/alternate-lite'

Plug 'sakhnik/nvim-gdb'

" LSP and related stuff
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'neovim/nvim-lsp'
Plug 'neovim/nvim-lspconfig'
Plug 'nvim-lua/lsp-status.nvim'

Plug 'nvim-lua/completion-nvim'

Plug 'RishabhRD/popfix' | Plug 'RishabhRD/nvim-lsputils'
Plug 'folke/trouble.nvim'

" Plug 'autozimu/LanguageClient-neovim', {
"             \ 'branch' : 'next',
"             \ 'do': 'bash install.sh',
"             \ }

" completion/snips
" Plug 'Shougo/deoplete.nvim'
" let g:deoplete#enable_at_startup = 1
" " Plug 'Shougo/deoplete-lsp'
" Plug 'deoplete-plugins/deoplete-jedi'
" Plug 'Shougo/neco-vim'

" Plug 'roxma/nvim-yarp'
" Plug 'ncm2/ncm2'
" " ncm2 sources
" Plug 'ncm2/ncm2-bufword'
" Plug 'ncm2/ncm2-path'
" Plug 'ncm2/ncm2-ultisnips'
Plug 'SirVer/ultisnips'
" Plug 'ncm2/ncm2-pyclang'
" Plug 'ncm2/ncm2-jedi'

Plug 'wellle/tmux-complete.vim'

" for ranger file manager
" Plug 'rbgrouleff/bclose.vim' | Plug 'francoiscabrol/ranger.vim'
" tag related
" Plug 'ludovicchabant/vim-gutentags' | Plug 'skywind3000/gutentags_plus'

call plug#end()
" }}}
" {{{ theme and look
if has('termguicolors')
    set termguicolors
endif
" set background=dark
" colorscheme space-nvim
" colorscheme material
" colorscheme neon
" let g:material_style = 'palenight'
" let g:neon_style = 'light'
"
set background=light
lua << EOF
-- colorscheme
vim.g.everforest_background = 'hard'
vim.cmd[[colorscheme everforest]]

-- gitsigns
require('gitsigns').setup {
signs = {
    add          = {hl = 'GitSignsAdd'   , text = '│', numhl='GitSignsAddNr'   , linehl='GitSignsAddLn'},
    change       = {hl = 'GitSignsChange', text = '│', numhl='GitSignsChangeNr', linehl='GitSignsChangeLn'},
    delete       = {hl = 'GitSignsDelete', text = '_', numhl='GitSignsDeleteNr', linehl='GitSignsDeleteLn'},
    topdelete    = {hl = 'GitSignsDelete', text = '‾', numhl='GitSignsDeleteNr', linehl='GitSignsDeleteLn'},
    changedelete = {hl = 'GitSignsChange', text = '~', numhl='GitSignsChangeNr', linehl='GitSignsChangeLn'},
  }
}
-- lualine
require('lualine').setup {
options = {
    theme = 'everforest'
}
}
-- bufferline
require('bufferline').setup {
options = {
    buffer_close_icon = " ",
    always_show_bufferline = false
}
}
EOF
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
nnoremap <silent> <C-p> :Files<CR>
nnoremap <silent> <C-o> :Buffers<CR>
nnoremap <silent> <C-i> :Rg<CR>
" insert 80 dashes
nnoremap <leader>-- A<space><Esc>80A-<Esc>d80<bar>
nnoremap <leader>== A<space><Esc>80A=<Esc>d80<bar>

nnoremap <silent> <leader>ws :FixWhitespace<CR>
nnoremap <leader>af :Autoformat<CR>
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
" {{{ language client

set hidden " required for renaming, etc.
" nvim 0.5.0 specific TODO alternatives for legacy?
" treesitter/lsp/etc lua setup
lua <<EOF
-- treesitter
local treesitter = require'nvim-treesitter.configs'
treesitter.setup {
    -- indent = { enable = true },
    highlight = { enable = true }
}

-- language server configuration
-- lsp status won't work idk why
-- local lsp_status = require'lsp-status'
-- lsp_status.register_progress()
local lspconfig = require'lspconfig'

local on_attach = function(client, bufnr)
    local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
    local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

    -- lsp_status.on_attach(client)

    -- completion triggered by <c-x><c-o>
    buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

    -- mappings
    local opts = { noremap=true, silent=true }

    buf_set_keymap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
    buf_set_keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
    buf_set_keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
    buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
end

lspconfig.ccls.setup {
    on_attach = on_attach,
    root_dir = lspconfig.util.root_pattern('compile_commands.json', 'build/compile_commands.json', '.project'),
    init_options = {
        cacheDirectory = "~/.ccls-cache";
    }
}
lspconfig.pyright.setup {
    on_attach = on_attach
}


-- lsputil bindings
-- vim.lsp.handlers['textDocument/codeAction'] = require'lsputil.codeAction'.code_action_handler
-- vim.lsp.handlers['textDocument/references'] = require'lsputil.locations'.references_handler
-- vim.lsp.handlers['textDocument/definition'] = require'lsputil.locations'.definition_handler
-- vim.lsp.handlers['textDocument/declaration'] = require'lsputil.locations'.declaration_handler
-- vim.lsp.handlers['textDocument/typeDefinition'] = require'lsputil.locations'.typeDefinition_handler
-- vim.lsp.handlers['textDocument/implementation'] = require'lsputil.locations'.implementation_handler
-- vim.lsp.handlers['textDocument/documentSymbol'] = require'lsputil.symbols'.document_handler
-- vim.lsp.handlers['workspace/symbol'] = require'lsputil.symbols'.workspace_handler

-- trouble.nvim
-- require("trouble").setup {
    -- bla
-- }
EOF

" }}}
" {{{ completion, snippets
set completeopt=noinsert,menuone,noselect

" completion-nvim
" <Tab> and <S/Tab> to navigate popup
inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-n>" : "\<S-Tab>"

set shortmess+=c

let g:completion_enable_snippet = 'UltiSnips'

" ncm2
" autocmd BufEnter * call ncm2#enable_for_buffer()

" inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"

" " ncm2-pyclang
" let g:ncm2_pyclang#library_path = '/usr/lib/llvm-10/lib'
" let g:ncm2_pyclang#database_path = [
"             \ 'compile_commands.json',
"             \ '../compile_commands.json',
"             \ 'build/compile_commands.json',
"             \ '../build/compile_commands.json'
"             \ ]
" " ncm2-ultisnips
" inoremap <silent> <expr> <CR> ncm2_ultisnips#expand_or("\<CR>", 'n')
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger = "<c-j>"
let g:UltiSnipsJumpBackwardTrigger = "<c-k>"
let g:UltiSnipsRemoveSelectModeMappings = 0

let g:UltiSnipsSnippetDirectories=['customsnips']
" call deoplete#custom#var('omni', 'input_patterns', {
"             \ 'cpp': g:cpp#re#deoplete
"             \})

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

" alternate-lite for configured files (*.cpp.in)
call lh#alternate#register_extension('g', 'h.in', ['cpp.in'])
call lh#alternate#register_extension('g', 'cpp.in', ['h.in'])
let g:alternates.fts.cpp += ['cpp.in', 'h.in']

" structure:
"  <libname>
"     +-- src/ -> source files
"     +-- include/<libname>/ -> header files
if has("autocmd")
    augroup alternate-searchpath
        autocmd!
        autocmd BufRead,BufNewFile *.h let g:alternates.searchpath = 'reg:|include/.\+$|src|'
        autocmd BufRead,BufNewFile *.cpp let g:alternates.searchpath = 'reg:|\([^/]\+\)/src|\1/include/\1||'
    augroup END
endif
" }}}
" vim: set shiftwidth=4 softtabstop=4 expandtab tw=120 foldlevel=0
