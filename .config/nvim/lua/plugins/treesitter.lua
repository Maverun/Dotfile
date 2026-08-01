--┌────────────────────────────────────────────────────────────────────────────┐
--│                                 treesitter                                 │
--└────────────────────────────────────────────────────────────────────────────┘
return {
    {
        'nvim-treesitter/nvim-treesitter',
        branch = "main",
        build = ':TSUpdate',
        lazy = false,
        config = function()
            -- Enable treesitter highlighting and incremental selection per filetype
            vim.api.nvim_create_autocmd('FileType', {
                pattern = { 'python', 'bash', 'sh', 'json', 'lua', 'vim', 'yaml', 'markdown' },
                callback = function()
                    vim.treesitter.start()
                end,
            })

            -- Incremental selection keymaps
            vim.keymap.set('n', '<cr>', function()
                require('nvim-treesitter.incremental_selection').init_selection()
            end, { desc = 'TS: init selection' })
            vim.keymap.set('x', '<cr>', function()
                require('nvim-treesitter.incremental_selection').node_incremental()
            end, { desc = 'TS: node incremental' })
            vim.keymap.set('x', 'gnn', function()
                require('nvim-treesitter.incremental_selection').scope_incremental()
            end, { desc = 'TS: scope incremental' })
            vim.keymap.set('x', '<bs>', function()
                require('nvim-treesitter.incremental_selection').node_decremental()
            end, { desc = 'TS: node decremental' })
        end,
    },
    {
        'nvim-treesitter/nvim-treesitter-textobjects',
        branch = "main",
        dependencies = { 'nvim-treesitter/nvim-treesitter' },
        lazy = false,
        config = function()
            require('nvim-treesitter-textobjects').setup {
                select = {
                    lookahead = true,
                },
            }

            -- Select
            vim.keymap.set({ 'x', 'o' }, 'af', function()
                require('nvim-treesitter-textobjects.select').select_textobject('@function.outer', 'textobjects')
            end)
            vim.keymap.set({ 'x', 'o' }, 'if', function()
                require('nvim-treesitter-textobjects.select').select_textobject('@function.inner', 'textobjects')
            end)
            vim.keymap.set({ 'x', 'o' }, 'ac', function()
                require('nvim-treesitter-textobjects.select').select_textobject('@class.outer', 'textobjects')
            end)
            vim.keymap.set({ 'x', 'o' }, 'ic', function()
                require('nvim-treesitter-textobjects.select').select_textobject('@class.inner', 'textobjects')
            end)

            -- Swap
            vim.keymap.set('n', '<right>', function()
                require('nvim-treesitter-textobjects.swap').swap_next('@parameter.inner')
            end)
            vim.keymap.set('n', '<left>', function()
                require('nvim-treesitter-textobjects.swap').swap_previous('@parameter.inner')
            end)
        end,
    },
}
