-- lsp related plugin configs
-- somewhat order dependent on the following

require'neodev'.setup{}
local lsp_status = require'lsp-status'
lsp_status.register_progress()

local lspconfig = require'lspconfig'
local navic = require'nvim-navic'

-- switch to header with splits
local function switch_alternate(client, bufnr, splitcmd)
    bufnr = lspconfig.util.validate_bufnr(bufnr)
    local params = {uri = vim.uri_from_bufnr(bufnr)}
    if not client then
        vim.notify('No viable client determined', vim.log.levels.WARN)
        return
    end
    client.request("textDocument/switchSourceHeader", params, function(err, result)
        if err then
            vim.notify(tostring(err), vim.log.levels.ERROR)
        end
        if not result then
            vim.notify("Unable to determine alternate file", vim.log.levels.ERROR)
            return
        end
        vim.api.nvim_command(splitcmd .. " " .. vim.uri_to_fname(result))
    end, bufnr)
end

-- set commands for alternate
local function set_alternate_commands(client, bufnr)
    vim.api.nvim_buf_create_user_command(bufnr, 'A', function() switch_alternate(client, bufnr, "edit") end, {})
    vim.api.nvim_buf_create_user_command(bufnr, 'AV', function() switch_alternate(client, bufnr, "vsplit") end, {})
    vim.api.nvim_buf_create_user_command(bufnr, 'AS', function() switch_alternate(client, bufnr, "split") end, {})
end

-- set lsp keymaps
local function set_lsp_keybinds(bufnr)
    local opts = { noremap=true, silent=false }
    local function buf_set_keymap(key, map) vim.api.nvim_buf_set_keymap(bufnr, 'n', key, map, opts) end
    -- lsp
    buf_set_keymap('<leader>ld', '<cmd>lua vim.lsp.buf.declaration()<CR>')
    buf_set_keymap('<leader>li', '<cmd>lua vim.lsp.buf.definition()<CR>')
    buf_set_keymap('<leader>lh', '<cmd>lua vim.lsp.buf.hover()<CR>')
    buf_set_keymap('<leader>lm', '<cmd>lua vim.lsp.buf.implementation()<CR>')
    buf_set_keymap('<leader>lr', '<cmd>lua vim.lsp.buf.references()<CR>')
    buf_set_keymap('<leader>lt', '<cmd>lua vim.lsp.buf.type_definition()<CR>')

    buf_set_keymap('<leader>lic', '<cmd>lua vim.lsp.buf.incoming_calls()<CR>')
    buf_set_keymap('<leader>loc', '<cmd>lua vim.lsp.buf.outgoing_calls()<CR>')

    buf_set_keymap('<leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>')
    buf_set_keymap('<leader>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>')
end

-- debug adapter (nvim-dap)
local dap, dapui = require'dap', require'dapui'
dapui.setup()
dap.adapters.lldb = {
    type = 'executable',
    command = '/usr/bin/lldb-vscode',
    name = 'lldb'
}
dap.adapters.cppdbg = {
    id = "cppdbg",
    type = "executable",
    command = vim.fn.stdpath("data") .. "/mason/packages/cpptools/extension/debugAdapters/bin/OpenDebugAD7"
}
-- dap.listeners.after.event_initialized["dapui_config"] = function()
--     dapui.open()
-- end
-- dap.listeners.before.event_terminated["dapui_config"] = function()
--     dapui.close()
-- end
-- dap.listeners.before.event_exited["dapui_config"] = function()
--     dapui.close()
-- end

dap.configurations.cpp = {
    {
        name = "Launch file",
        type = "cppdbg",
        request = "launch",
        program = function()
            require'telescope.builtin'.find_files()
        end,
        cwd = '${workspaceFolder}',
        stopAtEntry = true,
    },
    {
        name = "Attach to gdbserver :1234",
        type = "cppdbg",
        request = "launch",
        MIMode = "gdb",
        miDebguggerServerAddress = "localhost:1234",
        miDebuggerPath = "/usr/bin/gdb",
        cwd = "${workspaceFolder}",
        program = function()
        end,
    }
    -- {
    --     name = 'Launch lldb',
    --     type = 'lldb',
    --     request = 'launch',
    --     program = function()
    --         -- return vim.fn.input({'Path to executable: ', vim.fn.getcwd() .. '/', 'file'})
    --         -- local dir = vim.fn.getcwd()
    --         return vim.ui.input({
    --             prompt = "Path to executable: ",
    --             default = vim.fn.getcwd(),
    --             telescope = 
    --         }, function(input) end)
    --         -- return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
    --     end,
    --     cwd = '${workspaceFolder}',
    --     stopOnEntry = false,
    --     args = {}
    -- }
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

-- on_attach for all lsp
local on_attach_lsp = function(client, bufnr)
    -- mappings
    set_lsp_keybinds(bufnr)
end
-- on attach for cpp
local on_attach_lsp_cpp = function(client, bufnr)
    navic.attach(client, bufnr)
    set_alternate_commands(client, bufnr)
    on_attach_lsp(client, bufnr)
end

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

local clangd_extensions_config = {
    handlers = lsp_status.extensions.clangd.setup(),
    extensions = {
        autoSetHints = true,
        inlay_hints = {
            inline = false,
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
}
clangd_extensions.setup(clangd_extensions_config)

lspconfig.clangd.setup{
    capabilities = capabilities,
    on_attach = function(client, bufnr)
        on_attach_lsp_cpp(client, bufnr)
        clangd_extensions.inlay_hints.setup_autocmd()
        clangd_extensions.inlay_hints.set_inlay_hints()
    end,
    root_dir = lspconfig.util.root_pattern('compile_commands.json',
    'build/compile_commands.json',
    '.clangd'),
    cmd = {
        "clangd",
        "--background-index",
        "-j=8",
        "--clang-tidy=false",
        "--completion-style=detailed",
        "--header-insertion=iwyu"
    }
}

