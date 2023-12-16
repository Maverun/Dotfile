-- ┌───────────────────────────────────────────────────────────────────────────┐
-- │                                   Mini                                    │
-- └───────────────────────────────────────────────────────────────────────────┘

require'mini.surround'.setup({
    mappings = {
    add = ',sa', -- Add surrounding
    delete = ',sd', -- Delete surrounding
    find = ',sf', -- Find surrounding (to the right)
    find_left = ',sF', -- Find surrounding (to the left)
    highlight = ',sh', -- Highlight surrounding
    replace = ',sr', -- Replace surrounding
    update_n_lines = ',sn', -- Update `n_lines`
    }
})


require'mini.cursorword'.setup()
require'mini.align'.setup()
-- require'mini.pairs'.setup()
-- require'mini.indentscope'.setup(
-- {
--     draw = {
-- 	animation = require'mini.indentscope'.gen_animation('none')
--     },
--
--     options = {
-- 	try_as_border = true
--     },
--     symbol = '│'
-- }
-- )
--
--
--
