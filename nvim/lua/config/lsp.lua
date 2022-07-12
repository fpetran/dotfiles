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
    navic.attach(client, bufnr)
    aerial.on_attach(client, bufnr)
    set_alternate_commands(bufnr)

    -- mappings
    local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
    local opts = { noremap=true, silent=false }
    -- lsp
    buf_set_keymap('n', '<leader>ld', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
    buf_set_keymap('n', '<leader>li', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
    buf_set_keymap('n', '<leader>lh', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
    buf_set_keymap('n', '<leader>lm', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
    buf_set_keymap('n', '<leader>lr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
    buf_set_keymap('n', '<leader>lt', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)

    -- buf_set_keymap('n', '<leader>lic', '<cmd>lua vim.lsp.buf.incoming_calls()<CR>', opts)
    -- buf_set_keymap('n', '<leader>loc', '<cmd>lua vim.lsp.buf.outgoing_calls()<CR>', opts)

    buf_set_keymap('n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
    buf_set_keymap('n', '<leader>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)

    -- fugitive
    buf_set_keymap('n', '<leader>gb', '<cmd>Git blame<CR>', opts)
    buf_set_keymap('n', '<leader>gg', '<cmd>Git<CR>', opts)
    buf_set_keymap('n', '<leader>gc', '<cmd>Git commit<CR>', opts)
    buf_set_keymap('n', '<leader>gr', '<cmd>Git rebase -i<CR>', opts)

    -- aerial
    buf_set_keymap('n', '<leader>aa', '<cmd>AerialToggle<CR>', opts)
    buf_set_keymap('n', '<leader>ab', '<cmd>AerialToggle!<CR>', opts)
end

local coq = require('coq')

-- lspconfig.clangd.setup
-- called by clangd_extensions below

lspconfig.cmake.setup{}
lspconfig.pyright.setup(coq.lsp_ensure_capabilities({
    on_attach = on_attach_lsp
}))

local clangd_extensions = require('clangd_extensions')

clangd_extensions.setup({
    server = coq.lsp_ensure_capabilities({
        on_attach = on_attach_lsp,
        root_dir = lspconfig.util.root_pattern('compile_commands.json',
        'build/compile_commands.json',
        '.project'),
        cmd = {
            "clangd-12",
            "--background-index",
            "-j=2",
            -- "--inlay-hints",
            "--completion-style=detailed",
            "--header-insertion=never",
            "--clang-tidy"
        }
    }),
    extensions = {
        autoSetHints = true,
        inlay_hints = {
            only_current_line = false,
            only_current_line_autocmd = "CursorHold",
            show_parameter_hints = true,
            parameter_hints_prefix = "<- ",
            other_hints_prefix = "=> ",
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
-- local telescope = require'telescope'
-- telescope.load_extension('fzy_native')
