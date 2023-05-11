require'mason'.setup{}
require'mason-lspconfig'.setup{}
local lspconfig = require'lspconfig'
local treesitter = require'nvim-treesitter.configs'
local aerial = require'aerial'
aerial.setup({})
local navic = require'nvim-navic'

-- switch to header with splits
local function switch_alternate(bufnr, splitcmd)
    bufnr = lspconfig.util.validate_bufnr(bufnr)
    local clangd_client = lspconfig.util.get_active_client_by_name(bufnr, 'clangd')
    local params = {uri = vim.uri_from_bufnr(bufnr)}
    if clangd_client then
        clangd_client.request("textDocument/switchSourceHeader", params, function(err, result)
            if err then
                error(tostring(err))
            end
            if not result then
                print("Unable to determine alternate file")
                return
            end
            vim.api.nvim_command(splitcmd .. " " .. vim.uri_to_fname(result))
        end, bufnr)
    else
        print 'textDocument/switchSourceHeader not supported by this clangd server'
    end
end

-- commands replacing alternate
local set_alternate_commands = function(bufnr)
    vim.api.nvim_buf_create_user_command(bufnr, 'A', function() switch_alternate(bufnr, "edit") end, {} )
    vim.api.nvim_buf_create_user_command(bufnr, 'AV', function() switch_alternate(bufnr, "vsplit") end, {} )
    vim.api.nvim_buf_create_user_command(bufnr, 'AS', function() switch_alternate(bufnr, "split") end, {} )
end

-- on_attach to be called for cpp LS, so cpp init stuff goes here
local on_attach_lsp = function(client, bufnr)
    -- mappings
    local opts = { noremap=true, silent=false }
    local function buf_set_keymap(mode, key, map) vim.api.nvim_buf_set_keymap(bufnr, mode, key, map, opts) end
    -- lsp
    buf_set_keymap('n', '<leader>ld', '<cmd>lua vim.lsp.buf.declaration()<CR>')
    buf_set_keymap('n', '<leader>li', '<cmd>lua vim.lsp.buf.definition()<CR>')
    buf_set_keymap('n', '<leader>lh', '<cmd>lua vim.lsp.buf.hover()<CR>')
    buf_set_keymap('n', '<leader>lm', '<cmd>lua vim.lsp.buf.implementation()<CR>')
    buf_set_keymap('n', '<leader>lr', '<cmd>lua vim.lsp.buf.references()<CR>')
    buf_set_keymap('n', '<leader>lt', '<cmd>lua vim.lsp.buf.type_definition()<CR>')

    -- buf_set_keymap('n', '<leader>lic', '<cmd>lua vim.lsp.buf.incoming_calls()<CR>')
    -- buf_set_keymap('n', '<leader>loc', '<cmd>lua vim.lsp.buf.outgoing_calls()<CR>')

    buf_set_keymap('n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>')
    buf_set_keymap('n', '<leader>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>')

    -- fugitive
    buf_set_keymap('n', '<leader>gb', '<cmd>Git blame<CR>')
    buf_set_keymap('n', '<leader>gg', '<cmd>Git<CR>')
    buf_set_keymap('n', '<leader>gc', '<cmd>Git commit<CR>')
    buf_set_keymap('n', '<leader>gr', '<cmd>Git rebase -i<CR>')

    -- aerial
    buf_set_keymap('n', '<leader>aa', '<cmd>AerialToggle<CR>')
    buf_set_keymap('n', '<leader>ab', '<cmd>AerialToggle!<CR>')

    -- dap ui
    buf_set_keymap('n', '<leader>duo', '<cmd>lua require"dapui".open()<CR>')
    buf_set_keymap('n', '<leader>duc', '<cmd>lua require"dapui".close()<CR>')

    -- dap
    buf_set_keymap('n', '<leader>db', '<cmd>lua require"dap".toggle_breakpoint()<CR>')
    buf_set_keymap('n', '<leader>dc', '<cmd>lua require"dap".continue()<CR>')
    buf_set_keymap('n', '<leader>dn', '<cmd>lua require"dap".step_over()<CR>')
    buf_set_keymap('n', '<leader>ds', '<cmd>lua require"dap".step_into()<CR>')
end

local on_attach_lsp_cpp = function(client, bufnr)
    navic.attach(client, bufnr)
    set_alternate_commands(bufnr)

    on_attach_lsp(client, bufnr)
end

require'neodev'.setup{}
lspconfig.lua_ls.setup({
    library = { plugins = { "nvim-dap-ui" }, types = true },
    settings = {
        Lua = {
            completion = {
                callSnippet = "Replace"
            }
        }
    }
})

lspconfig.cmake.setup{
    on_attach = on_attach_lsp
}

lspconfig.bashls.setup{
    on_attach = on_attach_lsp
}

lspconfig.ruby_ls.setup{}

local util = require("lspconfig/util")
lspconfig.pyright.setup{
    on_attach = on_attach_lsp,
    root_dir = function(fname)
        return util.root_pattern( ".git")(fname) or util.path.dirname(fname)
    end
}

local clangd_extensions = require('clangd_extensions')
local cmp_lsp = require('cmp_nvim_lsp')
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = cmp_lsp.default_capabilities(capabilities)

clangd_extensions.setup({
    server = ({
        capabilities = capabilities,
        on_attach = on_attach_lsp_cpp,
        root_dir = lspconfig.util.root_pattern('compile_commands.json',
        'build/compile_commands.json',
        '.clangd'),
        cmd = {
            "clangd",
            "--background-index",
            "-j=8",
            "--completion-style=detailed",
            "--header-insertion=never"
        }
    }),
    extensions = {
        autoSetHints = true,
        inlay_hints = {
            only_current_line = false,
            only_current_line_autocmd = "CursorHold",
            show_parameter_hints = true,
            parameter_hints_prefix = " ",
            -- other_hints_prefix = "󰞘 ",
            other_hints_prefix = "󰧂 ",
            max_len_alight = false,
            max_len_align_padding = 1,
            right_alight = false,
            right_align_padding = 7,
            highlight = "Comment",
            priority = 100
        },
        ast = {
            highlights = {
                detail = "Comment",
            },
            memory_usage = {
                border = "none",
            },
            symbol_info = {
                border = "none",
            }
        }
    }
})

treesitter.setup {
    highlight = { enable = true }
}

-- debug adapter (nvim-dap)
local dap = require'dap'
dap.adapters.lldb = {
    type = 'executable',
    command = '/usr/bin/lldb-vscode-10',
    name = 'lldb'
}
dap.configurations.cpp = {
    {
        name = 'Launch',
        type = 'lldb',
        request = 'launch',
        program = function()
            return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
        end,
        cwd = '${workspaceFolder}',
        stopOnEntry = false,
        args = {}
    }
}
-- set breakpoint:
-- :lua require'dap'.toggle_breakpoint()
-- launch debug session/resume execution
-- :lua require'dap'.continue()
-- step through code
-- :lua require'dap'.step_over()
-- :lua require'dap'.step_into()
-- open repl to inspect state
-- :lua require'dap'.repl.open()

-- telescope
local telescope = require'telescope'
telescope.setup {
    extensions = {
        fzf = {
            fuzzy = true,
            override_generic_sorter = true,
            override_file_sorter = true,
            case_mode = "smart_case"
        }
    }
}
-- telescope.load_extension('fzf_native')
