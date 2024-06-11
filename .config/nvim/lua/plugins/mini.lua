-- ┌───────────────────────────────────────────────────────────────────────────┐
-- │                                   Mini                                    │
-- └───────────────────────────────────────────────────────────────────────────┘

vim.api.nvim_create_augroup('mini_trailspace', { clear = true })
vim.api.nvim_create_autocmd('FileType', {
    group = 'mini_trailspace',
    pattern = 'lazy',
    callback = function()
        vim.b.minitrailspace_disable = true
    end,
    desc = "Disable trailspace in certain filetype.",
})

return {
    {
        'echasnovski/mini.nvim',
        version = '*',
        event = "VeryLazy",
        config = function()
            require 'mini.surround'.setup({
                mappings = {
                    add = ',sa', -- Add surrounding
                    delete = ',sd', -- Delete surrounding
                    find = ',sf', -- Find surrounding (to the right)
                    find_left = ',sF', -- Find surrounding (to the left)
                    highlight = ',sh', -- Highlight surrounding
                    replace = ',sr', -- Replace surrounding
                    update_n_lines = ',sn' -- Update `n_lines`
                }
            })
            require 'mini.cursorword'.setup()
            require 'mini.align'.setup()
            require 'mini.trailspace'.setup()
            -- require'mini.pairs'.setup({modes = {insert = true,command = true}})
            require 'mini.ai'.setup()
            require 'mini.misc'.setup()
            require 'mini.indentscope'.setup({
                draw = {
                    animation = require('mini.indentscope').gen_animation.none()
                }
            })
            _G.MiniMisc.setup_auto_root()

        end,
        keys = {
            { '<leader>mt', ':lua MiniTrailspace.trim()<cr>', desc = "Trim trailing whitespace" }
        }
    },
}
