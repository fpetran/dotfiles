-- packer-nvim

-- attempt bootstrap if necessary
local ensure_packer = function()
    local fn = vim.fn
    local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
    local packer_git = 'https://github.com/wbthomason/packer.nvim'
    if fn.empty(fn.glob(install_path)) > 0 then
        fn.system({'git', 'clone', '--depth', '1', packer_git, install_path})
        vim.cmd [[packadd packer.nvim]]
        return true
    end
    return false
end

local packer_bootstrap = ensure_packer()

vim.cmd([[
    augroup packer_user_config
        autocmd!
        autocmd BufWritePost plugins.lua source <afile> | PackerCompile
    augroup end
]])

return require('packer').startup(function(use)
    -- packer itself
    use 'wbthomason/packer.nvim'

    use 'tpope/vim-fugitive'
    use 'tpope/vim-surround'
    use 'tpope/vim-repeat'
    use 'tpope/vim-unimpaired'

    -- use 'tpope/vim-commentary'
    use {
        'numToStr/Comment.nvim',
        config = function() require'Comment'.setup() end
    }

    use 'tpope/vim-obsession'
    use {
        'lewis6991/gitsigns.nvim', requires = { 'nvim-lua/plenary.nvim' },
        config = function() require'gitsigns'.setup() end
    }

    -- themes
    use 'arcticicestudio/nord-vim'

    -- status and buffer bars
    use 'hoob3rt/lualine.nvim'
    use 'kyazdani42/nvim-web-devicons'
    -- no color icons:
    -- use 'ryanoasis/vim-devicons'
    use 'akinsho/nvim-bufferline.lua'

    -- tmux
    use 'christoomey/vim-tmux-navigator'
    use 'tmux-plugins/vim-tmux'
    use 'roxma/vim-tmux-clipboard'

    -- misc specific
    use 'elzr/vim-json'
    use 'lervag/vimtex'
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
    use 'rcarriga/nvim-dap-ui'
    use 'stevearc/aerial.nvim'
    use 'SmiteshP/nvim-navic'

    use {
        'williamboman/mason.nvim', run = ':MasonUpdate'
    }
    use 'williamboman/mason-lspconfig.nvim'

    use 'folke/neodev.nvim'
    use 'folke/trouble.nvim'

    -- completion
    use 'hrsh7th/cmp-nvim-lsp'
    use 'hrsh7th/cmp-buffer'
    use 'hrsh7th/cmp-path'
    use 'hrsh7th/cmp-cmdline'
    use 'hrsh7th/cmp-git'
    use 'hrsh7th/nvim-cmp'

    use 'L3MON4D3/LuaSnip'
    use 'saadparwaiz1/cmp_luasnip'
    use 'honza/vim-snippets'

    use 'wellle/tmux-complete.vim'

    use {
        'junegunn/fzf', dir = '~/.fzf', run = './install --all'
    }
    use {
        'nvim-telescope/telescope.nvim', requires = { 'nvim-lua/plenary.nvim' }
    }
    use 'nvim-telescope/telescope-dap.nvim'


    if packer_bootstrap then
        require('packer').sync()
    end
end)
