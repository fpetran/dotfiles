local cmp = require'cmp'
cmp.setup({
    snippet = {
        expand = function(args)
            -- vim.fn["UltiSnips#Anon"](args.body)
            require('luasnip').lsp_expand(args.body)
        end,
    },
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
        -- { name = 'ultisnips' },
        { name = 'luasnip' },
        { name = 'buffer' }
    })
})
-- what's this supposed to do --v?
-- cmp.setup.filetype('gitcommit', {
--     sources = cmp.config.sources({
--         { { name = 'cmp_git' } },
--         { { name = 'buffer' } }
--     })
-- })

require('luasnip.loaders.from_snipmate').lazy_load()

-- local vim.g.coq_settings = {
--     'auto_start': 'shut-up',
--     'keymap.jump_to_mark': '<C-n>'
-- }
-- local coq = require('coq')