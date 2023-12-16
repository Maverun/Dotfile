local g = vim.g

-- require("ibl").setup {
--     space_char_blankline = " ",
--     show_current_context = true,
--     -- show_current_context_start = true,
--     char = '│',
--     -- show_trailing_blankline_indent = false,
--     show_first_indent_level = false,
--     filetype_exclude = {'markdown','md','help','','dashboard'},
-- }

    -- fg = "#c0caf5",
    -- fg_dark = "#a9b1d6",
vim.cmd[[
    highlight IndentBlanklineContextChar guifg=#a9b1d6 gui=nocombine
    highlight IndentBlanklineContextStart guisp=#a9b1d6 gui=underline
]]

--FZF Notation FZF for notes
g.nv_search_paths = {
    "/ext_drive/SynologyDrive/NotesTaking/Dev",
    "/ext_drive/SynologyDrive/NotesTaking/Home",
}

g.vim_markdown_conceal = 2



-- ┌───────────────────────────────────────────────────────────────────────────┐
-- │                               Plugins Setup                               │
-- └───────────────────────────────────────────────────────────────────────────┘



-- require'surround'.setup{prefix=','}
require'colorizer'.setup{"*"}
require'FTerm'.setup{}
--there is plugins for this suda.nvim, but doesn't feel like a worth it  since I wont be editing in permission often.
vim.cmd[[
" Temporary workaround for: https://github.com/neovim/neovim/issues/1716
if has("nvim")
  command! W w !sudo -n tee % > /dev/null || echo "Press <leader>w to authenticate and try again"
  map <leader>w :new<cr>:term sudo true<cr>
else
  command! W w !sudo tee % > /dev/null
end
]]

-- require'autolist'.setup({})
require("symbols-outline").setup()

--
-- require('colorful-winsep').setup(
-- {
--   -- direction = {
--   --   down = "j",
--   --   left = "h",
--   --   right = "l",
--   --   up = "k"
--   -- },
--   highlight = {
--     guibg = "bg",
--     -- guifg = "#957CC6"
--     guifg = '#565f89'
--
--   },
--   interval = 50,
--   no_exec_files = { "packer", "TelescopePrompt", "mason", "CompetiTest" },
--   -- symbols = { "━", "┃", "┏", "┓", "┗", "┛" },
--   symbols = { "─", "│", "┌", "┐", "└", "┘" },
--   win_opts = {
--     relative = "editor",
--     style = "minimal"
--   }
-- })
--

-- vim.cmd[[
-- highlight WinSeparatorA guibg='bg' guifg='#957CC6'
-- au VimEnter,WinEnter * setl winhl=WinSeparator:WinSeparatorA
-- au WinLeave * setl winhl=WinSeparator:WinSeparator
-- ]]

