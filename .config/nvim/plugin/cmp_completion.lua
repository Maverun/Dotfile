vim.o.completeopt = "menuone,noselect"

-- nvim-cmp setup
local cmp = require 'cmp'
cmp.setup {
    -- completion = {autocomplete = true  },
    snippet = {
        expand = function(args)
            require('luasnip').lsp_expand(args.body)
        end,
    },
    mapping = {
        ['<C-s>'] = cmp.mapping.complete(),
        ['<C-p>'] = cmp.mapping.select_prev_item(),
        ['<C-n>'] = cmp.mapping.select_next_item(),
        ['<C-d>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-e>'] = cmp.mapping.close(),
        ['<CR>'] = cmp.mapping.confirm {
            behavior = cmp.ConfirmBehavior.Replace,
            select = true,
        },
        ['<C-Space>'] = cmp.mapping(function(fallback) require'cmp'.completion = {autocomplete = not require'cmp'.completion.autocomplete} end),
        ['<Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_next_item()
                -- vim.fn.feedkeys(vim.api.nvim_replace_termcodes('<C-n>', true, true, true), 'n')
            elseif require'luasnip'.expand_or_jumpable() then
                vim.fn.feedkeys(vim.api.nvim_replace_termcodes('<Plug>luasnip-expand-or-jump', true, true, true), '')
            else
                fallback()
            end
        end,{'i','s'}),

        ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_next_item()
            elseif require'luasnip'.jumpable(-1) then
                vim.fn.feedkeys(vim.api.nvim_replace_termcodes('<Plug>luasnip-jump-prev', true, true, true), '')
            else
                -- fallback()
                vim.fn.feedkeys(vim.api.nvim_replace_termcodes('<esc><<a',true,true,true))
            end
        end, { "i", "s", })},


    sources = {
        { name = 'luasnip', priority = 99 },
        { name = 'nvim_lsp' },
        { name = 'buffer', priority = 90 },
        { name = 'nvim_lua' },
    },
}

