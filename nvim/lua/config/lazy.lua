-- vim: fdm=marker
-- lazy plugin config
-- {{{ attempt lazy install
local lazybase = vim.fn.stdpath("data") .. "/lazy"
local lazypath = lazybase .. "/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable",
        lazypath
    })
end
vim.opt.rtp:prepend(lazypath)
-- }}}
vim.g.mapleader = " "

-- find projBase: first dir from left that contains a .git/
FindBaseDir = function(startDir)
    local path = vim.fn.split(startDir, "/")
    local projBase = ""
    local scan = require("plenary.scandir")
    for _, pathPart in ipairs(path) do
        projBase = projBase .. "/" .. pathPart
        local content = scan.scan_dir(projBase, { hidden = true, only_dirs = true, depth = 1 })
        for _, entry in ipairs(content) do
            if entry:match(".git$") then
                return projBase
            end
        end
    end
    -- default to cwd
    return projBase
end

local plugins = {
    {
        "ellisonleao/gruvbox.nvim",
        lazy = false,
        priority = 1000,
        config = function()
            vim.o.background = "light"
            vim.cmd([[colorscheme gruvbox]])
        end
    },
    {
        "gentoo/gentoo-syntax",
        build = "make PREFIX=" .. lazybase .. " install"
    },
    {
        "MTDL9/vim-log-highlighting"
    },
    -- {{{ statusline, bufferline
    {
        "hoob3rt/lualine.nvim", lazy = false,
        dependencies = {
            "SmiteshP/nvim-navic",
            "nvim-lua/lsp-status.nvim",
        },
        opts = {
            options = {
                theme = "gruvbox"
            },
            sections = {
                lualine_a = {'mode'},
                lualine_b = {
                    "branch",
                    "diff",
                    "require'lsp-status'.status()",
                    -- 'diagnostics'
                },
                lualine_c = {
                    "filename",
                    "require'nvim-navic'.get_location()"
                },
                lualine_x = {"encoding", "fileformat", "filetype"},
                lualine_y = {"progress"},
                lualine_z = {"location"}
            }
        }
    },
    { "kyazdani42/nvim-web-devicons", lazy = true },
    {
        "akinsho/nvim-bufferline.lua",
        dependencies = {
            "kyazdani42/nvim-web-devicons"
        },
        opts = {
            options = {
                buffer_close_icon = " ",
                always_show_bufferline = false
            }
        }
    },
    -- }}}
    -- {{{ tpope stuff/replacements
    { "tpope/vim-sensible" },
    {
        "kylechui/nvim-surround",
        version = "*",
        event = "VeryLazy",
        config = function() require'nvim-surround'.setup() end
    },
    {
        "tummetott/unimpaired.nvim",
        config = function() require'unimpaired'.setup() end
    },
    { "tpope/vim-repeat" },
    {
        "numToStr/Comment.nvim",
        config = function() require'Comment'.setup() end
    },
    -- }}}
    -- {{{ git integration
    {
        "tpope/vim-fugitive", lazy = true,
        keys = {
            { "<leader>gb", "<cmd>Git blame<CR>" },
            { "<leader>gg", "<cmd>Git<CR>" },
            { "<leader>gc", "<cmd>Git commit<CR>" },
            { "<leader>gr", "<cmd>Git rebase -i<CR>" },
            { "<leader>gd", "<cmd>Git diff %<CR>" },
        }
    },
    {
        "lewis6991/gitsigns.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim"
        },
    },
    -- }}}
    { "stevearc/dressing.nvim", event = "VeryLazy" },
    {
        "rcarriga/nvim-notify", event = "VeryLazy",
        init = function() vim.notify = require("notify") end
    },
    -- {{{ tmux related
    {
        "christoomey/vim-tmux-navigator", lazy = false,
        init = function()
            vim.g.tmux_navigator_disable_when_zoomed = 1
            -- 1 -> :w, 2 -> :wa
            vim.g.tmux_navigator_save_on_switch = 2
        end
    },
    -- TODO replace with this --v
    -- { "alexghergh/nvim-tmux-navigation" },
    { "tmux-plugins/vim-tmux", lazy = true, ft = "tmux" },
    { "roxma/vim-tmux-clipboard" },
    -- }}}

    -- misc specific
    { "elzr/vim-json", lazy = true, ft = "json" },
    {
        "lervag/vimtex", lazy = true, ft = "tex",
        init = function() vim.g.tex_flavor = "latex" end
    },

    { "folke/which-key.nvim", lazy = true },
    { "famiu/bufdelete.nvim" },

    -- {{{ formatting
    {
        "Chiel92/vim-autoformat", lazy = true,
        keys = {
            { "<leader>af", ":Autoformat<CR>" }
        }
    },
    -- { "lukas-reineke/indent-blankline.nvim" },
    -- }}}
    -- {{{ treesitter
    {
        "nvim-treesitter/nvim-treesitter",
        lazy = false,
        build = ":TSUpdate",
        init = function()
            require'nvim-treesitter.configs'.setup {
                ensure_installed = { "c", "cpp", "cmake", "lua", "vim", "vimdoc", "query", "python", "bash", "xml" },
                auto_install = true,
                highlight = { enable = true }
            }
            vim.treesitter.language.register('xml', { 'svg', 'xslt' })
        end,
        dependencies = {
            "nvim-treesitter/nvim-treesitter-textobjects",
            "nvim-treesitter/nvim-treesitter-context"
        }
    },
    { "nvim-treesitter/nvim-treesitter-textobjects", lazy = true },
    {
        "nvim-treesitter/nvim-treesitter-context",
        lazy = true,
        config = function()
            require'treesitter-context'.setup{
                multiline_threshold = 20
            }
        end
    },
    -- }}}
    -- {{{ lsp/dap/related
    { "neovim/nvim-lspconfig" },
    { "p00f/clangd_extensions.nvim" },
    { "nvim-lua/lsp-status.nvim" },

    {
        "folke/todo-comments.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim"
        },
        config = function() require'todo-comments'.setup() end
    },

    { "mfussenegger/nvim-dap" },
    { "rcarriga/nvim-dap-ui", dependencies = { "nvim-neotest/nvim-nio" } },

    {
        "stevearc/aerial.nvim", lazy = true,
        config = function() require'aerial'.setup() end,
        keys = {
            { "<leader>aa", "<cmd>AerialToggle<CR>" },
            { "<leader>ab", "<cmd>AerialToggle!<CR>" }
        }
    },
    { "SmiteshP/nvim-navic", lazy = true },
    -- }}}
    {
        "williamboman/mason.nvim", build = ":MasonUpdate",
        dependencies = {
            "williamboman/mason-lspconfig.nvim",
        },
        config = function()
            require'mason'.setup{}
            require'mason-lspconfig'.setup{}
        end
    },

    { "folke/neodev.nvim" },
    {
        "folke/trouble.nvim", lazy = true,
        keys = {
            { "<leader>xx", "<cmd>TroubleToggle<cr>" }
        }
    },

    -- {{{ completion
    {
        "hrsh7th/nvim-cmp", lazy = true,
        event = "InsertEnter",
        dependencies = {
            "neovim/nvim-lspconfig",
            -- "L3MON4D3/LuaSnip",
            -- "saadparwaiz1/cmp_luasnip",
        },
        config = function()
            local cmp = require'cmp'
            cmp.setup({
                snippet = function(args)
                    require'luasnip'.lsp_expand(args.body)
                end,
                window = {
                    completion = cmp.config.window.bordered(),
                    documentation = cmp.config.window.bordered()
                },
                mapping = cmp.mapping.preset.insert({
                    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
                    ['<C-f>'] = cmp.mapping.scroll_docs(-4),
                    ['<C-Space>'] = cmp.mapping.complete(),
                    ['<C-e>'] = cmp.mapping.abort(),
                    ['<Tab>'] = cmp.mapping.confirm({ select = true })
                }),
                sources = cmp.config.sources({
                    { name = 'nvim_lsp' },
                    { name = 'luasnip' },
                    -- { name = 'buffer' }
                })
            })
        end
    },

    { "hrsh7th/cmp-nvim-lsp" },
    { "hrsh7th/cmp-buffer" },
    { "hrsh7th/cmp-path" },
    { "hrsh7th/cmp-cmdline" },
    { "hrsh7th/cmp-git" },
    -- {
    --     "L3MON4D3/LuaSnip",
    --     config = function() require'luasnip.loaders.from_snipmate'.lazy_load() end
    -- },
    -- { "saadparwaiz1/cmp_luasnip" },

    { "wellle/tmux-complete.vim" },
    -- }}}

    -- {{{ telescope
    {
        "nvim-telescope/telescope.nvim", lazy = true,
        config = function()
            local telescope = require'telescope'
            telescope.setup({
                pickers = {
                    find_files = {
                        theme = "dropdown"
                    }
                },
                extensions = {
                    fzf = {
                        fuzzy = true,
                        override_generic_sorter = true,
                        override_file_sorter = true,
                        case_mode = "smart_case"
                    },
                    media_files = {
                        find_cmd = "fdfind"
                    }
                }
            })
            -- telescope.load_extension('media_files')
            -- telescope.load_extension('fzf')
        end,
        keys = {
            { "<leader>ff", "<cmd>lua require('telescope.builtin').find_files()<cr>" },
            { "<leader>fg", "<cmd>lua require('telescope.builtin').live_grep()<cr>" },
            { "<leader>fb", "<cmd>lua require('telescope.builtin').buffers()<cr>" },
            { "<leader>fh", "<cmd>lua require('telescope.builtin').help_tags()<cr>" },
        },
        dependencies = {
            "nvim-lua/plenary.nvim",
            -- "nvim-telescope/telescope-dap.nvim",
            -- "nvim-telescope/telescope-fzf-native.nvim",
            -- "nvim-telescope/telescope-media-files.nvim"
        }
    },
    {
        "nvim-telescope/telescope-fzf-native.nvim", lazy = true,
        build = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build",
    },
    -- {
    --     "nvim-telescope/telescope-media-files.nvim", lazy = true
    -- },
    -- }}}
    {
        "Ostralyan/scribe.nvim", lazy = true,
        opts = {
            directory = '~/notes/',
            file_ext = 'md',
            default_file = 'scribe'
        },
        dependencies = { "nvim-telescope/telescope.nvim" },
        keys = {
            -- create/open default file
            { "<leader>ss", "<cmd>ScribeOpen<cr>" },
            -- create a file (name required)
            { "<leader>so", function()
                vim.ui.input({ prompt="Note" }, function(name)
                                                        require("scribe").open(name)
                                                end)
            end },
            -- open telescope finder
            { "<leader>sf", "<cmd>ScribeFind<cr>" }
        }
    },
    {
        "https://codeberg.org/esensar/nvim-dev-container",
        dependencies = {
            "nvim-treesitter/nvim-treesitter",
            "nvim-lua/plenary.nvim" -- for custom config search
        },
        opts = {
            config_search_start = function()
                local projBase = FindBaseDir(vim.loop.cwd())
                if vim.g.devcontainer_selected_config == nil or vim.g.devcontainer_selected_config == "" then
                    local candidates = vim.split(
                        vim.fn.glob(projBase .. "/.devcontainer/**/devcontainer.json"),
                        "\n",
                        { trimempty = true }
                    )
                    if #candidates < 2 then
                        vim.g.devcontainer_selected_config = projBase
                    else
                        local choices = { "Select devcontainer config file to use:" }
                        for idx, candidate in ipairs(candidates) do
                            table.insert(choices, idx .. ". - " .. candidate)
                        end
                        local choice_idx = vim.fn.inputlist(choices)
                        if choice_idx > #candidates then
                            choice_idx = 1
                        end
                        vim.g.devcontainer_selected_config = string.gsub(candidates[choice_idx], "/devcontainer.json", "")
                    end
                end
                return vim.g.devcontainer_selected_config
            end,
            workspace_folder_provider = function()
                return FindBaseDir(vim.loop.cwd())
            end,
            attach_mounts = {
                neovim_config = {
                    enabled = true,
                    options = { "readonly" }
                },
                neovim_data = {
                    enabled = false
                },
                neovim_state = {
                    enabled = false
                }
            },
            autocommands = {
                init = false,
                clean = true,
                update = true
            },
            log_level = "info"
        }
    }
}
require'lazy'.setup(plugins)
