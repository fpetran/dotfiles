-- packer-nvim

-- attempt bootstrap if necessary
local fn = vim.fn
local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
    packer_bootstrap = fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer/nvim', install_path})
end

vim.cmd [[packadd packer.nvim]]

vim.cmd([[
    augroup packer_user_config
        autocmd!
        autocmd BufWritePost plugins.lua source <afile> | PackerCompile
    augroup end
]])

return require('packer').startup(function()
    -- packer itself
    use 'wbthomason/packer.nvim'

    use 'tpope/vim-fugitive'
    use 'tpope/vim-surround'
    use 'tpope/vim-repeat'
    use 'tpope/vim-unimpaired'
    use 'tpope/vim-commentary'
    use {
        'lewis6991/gitsigns.nvim', requires = { 'nvim-lua/plenary.nvim' },
        config = function() require'gitsigns'.setup() end
    }

    -- use {
    --     'junegunn/fzf', run = './install --all'
    -- }
    use {
        'nvim-telescope/telescope.nvim', requires = { 'nvim-lua/plenary.nvim' }
    }

    -- themes
    use 'marko-cerovac/material.nvim'
    use 'Th3Whit3Wolf/space-nvim'
    use 'tanvirtin/monokai.nvim'
    use 'Iron-E/nvim-highlite'
    use 'rafamadriz/neon'
    use 'Th3Whit3Wolf/onebuddy'
    use 'sainnhe/everforest'
    use 'sainnhe/edge'

    -- status and buffer bars
    use 'hoob3rt/lualine.nvim'
    use 'kyazdani42/nvim-web-devicons'
    -- no color icons:
    -- use 'ryanoasis/vim-devicons'
    use 'akinsho/nvim-bufferline.lua'

    -- tmux
    use 'christoomey/vim-tmux-navigator'
    use 'tmux-plugins/vim-tmux-focus-events'
    use 'tmux-plugins/vim-tmux'
    use 'roxma/vim-tmux-clipboard'

    -- misc specific
    use 'elzr/vim-json'
    use 'lervag/vimtex'
    use 'Glench/Vim-Jinja2-Syntax'
    use {
        'inkarkat/vim-SyntaxRange', requires = { 'inkarkat/vim-ingo-library' }
    }
    use 'folke/which-key.nvim'
    use 'famiu/bufdelete.nvim'

    -- formatting
    use 'Chiel92/vim-autoformat'
    use 'bronson/vim-trailing-whitespace'
    use 'Yggdroot/indentLine'

    -- LSP and related
    use {
        'nvim-treesitter/nvim-treesitter', run = ':TSUpdate'
    }
    use 'neovim/nvim-lsp'
    use 'neovim/nvim-lspconfig'
    use 'nvim-lua/lsp-status.nvim'
    use 'p00f/clangd_extensions.nvim'

    use 'mfussenegger/nvim-dap'
    use 'stevearc/aerial.nvim'
    use 'SmiteshP/nvim-navic'
    use 'folke/trouble.nvim'

    -- completion

    use {
        'ms-jpq/coq_nvim', branch = 'coq'
    }
    -- use {
    --     'ms-jpq/coq.artifacts', branch = 'coq'
    -- }
    use {
        'ms-jpq/coq.thirdparty', branch = '3p'
    }
    use 'SirVer/ultisnips'

    use 'wellle/tmux-complete.vim'

    if packer_bootstrap then
        require'packer'.sync()
    end
end)
