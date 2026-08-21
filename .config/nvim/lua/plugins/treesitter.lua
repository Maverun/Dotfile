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
            -- Enable treesitter highlighting per filetype, skip virtual scheme buffers
            vim.api.nvim_create_autocmd('FileType', {
                pattern = { 'python', 'bash', 'sh', 'json', 'lua', 'vim', 'yaml', 'markdown' },
                callback = function(ev)
                    local bufname = vim.api.nvim_buf_get_name(ev.buf)
                    if bufname:match('^%a+://') then return end
                    local ok, err = pcall(vim.treesitter.start, ev.buf)
                    if not ok then
                        vim.notify('[treesitter] ' .. err, vim.log.levels.WARN)
                    end
                end,
            })

            -- Incremental selection via built-in vim.treesitter.select (nvim 0.12+)
            vim.keymap.set('n', '<cr>', function()
                vim.treesitter.select('parent')
            end, { desc = 'TS: init/expand selection' })
            vim.keymap.set('x', '<cr>', function()
                vim.treesitter.select('parent')
            end, { desc = 'TS: expand selection' })
            vim.keymap.set('x', '<bs>', function()
                vim.treesitter.select("child")
            end, { desc = 'TS: shrink selection' })
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
