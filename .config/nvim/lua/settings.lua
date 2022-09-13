-- ┌───────────────────────────────────────────────────────────────────────────┐
-- │                                 Settings                                  │
-- └───────────────────────────────────────────────────────────────────────────┘

local cmd = vim.cmd  -- to execute Vim commands e.g. cmd('pwd')
local fn = vim.fn    -- to call Vim functions e.g. fn.bufnr()
local g = vim.g      -- a table to access global variables
local opt = vim.opt


opt.syntax = 'on'               -- Able syntax
opt.hidden = true             -- Enable modified buffers in background
opt.encoding = 'utf-8'        -- Encoding displayed
opt.fileencoding = 'utf-8'    -- Encoding written to files
opt.termguicolors = true      -- True color support
opt.joinspaces = false        -- No double spaces with join after a dot
opt.scrolloff = 5             -- Lines of context
opt.sidescrolloff = 8         -- Columns of context
opt.splitright = true         -- Put new windows right of current
opt.splitbelow = true         -- Put new windows below current
--opt.wildmenu = true
--opt.wildmode ='list:longest' -- Command-line completion mode
opt.list = true               -- Show some invisible characters (tabs...)
opt.number = false             -- Print line number
opt.relativenumber = false     -- Relative line numbers


opt.wrap = false              -- Disable line wrap
opt.ruler = true               -- Cursor ruler
opt.inccommand = "split"       -- Allow to see change when replace via :s/
opt.mouse = "a"                -- Allow to use mouse
opt.showmode = false           -- Dont show default -- Insert --
opt.spell = true                -- well...duh
opt.smartcase = true          -- Don't ignore case with capitals
opt.ignorecase = true         -- Ignore case

opt.backup = false             -- Disable Backup since it is bit annoying to deal when open files
opt.writebackup = false         -- similar as backup setting
opt.swapfile = false         -- similar as backup setting

opt.clipboard = 'unnamedplus'  -- allow to merge with system clipboard
opt.cmdheight = 1              -- set command height 1

opt.updatetime = 300
opt.timeoutlen = 200

cmd 'set iskeyword -=_'              -- allow to ignore _ as one word
opt.autochdir = true            -- Working directory will be always same
-- opt.filetype = 'plugin'
cmd 'set fillchars+=vert:▏'          -- Setting Window Vertical border to thin

opt.conceallevel = 2            -- allow to view markdown ease

opt.completeopt = "menuone,noselect"

opt.listchars = {
    -- tab = '',
    tab = '  ',
    conceal = '┊',
    nbsp = 'ﮊ',
    extends = '>',
    precedes = '<',
    trail = '·',
    eol = '﬋',
}

-- ┌───────────────────────────────────────────────────────────────────────────┐
-- │                                    Tab                                    │
-- └───────────────────────────────────────────────────────────────────────────┘

local indent = 4

-- opt.expandtab = true                           -- Use spaces instead of tabs
-- opt.shiftwidth = indent                        -- Size of an indent
-- opt.smartindent = true                         -- Insert indents automatically
-- opt.tabstop = indent                           -- Number of spaces tabs count for
-- opt.shiftround = true                          -- Round indent

-- ┌───────────────────────────────────────────────────────────────────────────┐
-- │                                   Fold                                    │
-- └───────────────────────────────────────────────────────────────────────────┘

opt.foldmethod = 'manual'

-- ┌───────────────────────────────────────────────────────────────────────────┐
-- │                                  Column                                   │
-- └───────────────────────────────────────────────────────────────────────────┘

-- opt.cursorline = true
-- opt.cursorcolumn = true

-- opt.colorcolumn = '80'

-- ┌───────────────────────────────────────────────────────────────────────────┐
-- │                                  VimStay                                  │
-- └───────────────────────────────────────────────────────────────────────────┘

g.viewoptions='cursor,folds,slash,unix'
cmd 'set viewoptions-=options'

-- ┌───────────────────────────────────────────────────────────────────────────┐
-- │                                IndentLine                                 │
-- └───────────────────────────────────────────────────────────────────────────┘

-- g.indent_blankline_char_highlight_list = {'Error', 'Function'}
-- g.indent_blankline_char_highlight_list = {'comment', 'conceal'}
-- g.indent_blankline_space_char_highlight_list = {'comment', 'Function'}
--g.indent_blankline_strict_tabs = true
-- Custom Highlight group
--g.indent_blankline_char_highlight_list = {'aqua_ind' , 'grey_ind', 'yellow_ind','algea_ind'}
-- g.indent_blankline_use_treesitter = true
-- g.indent_blankline_char = '│'
-- g.indent_blankline_show_trailing_blankline_indent = false
-- g.indent_blankline_show_first_indent_level = false
-- g.indent_blankline_filetype_exclude = {'markdown','md','help','','dashboard'}

require("indent_blankline").setup {
    space_char_blankline = " ",
    show_current_context = true,
    -- show_current_context_start = true,
    char = '│',
    show_trailing_blankline_indent = false,
    show_first_indent_level = false,
    filetype_exclude = {'markdown','md','help','','dashboard'},
}

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

require'autolist'.setup({})
require'mind'.setup({
    persistence = {
	state_path = '/ext_drive/SynologyDrive/NotesTaking/mind.json',
	data_dir = '/ext_drive/SynologyDrive/NotesTaking/',
    },
    edit = {
	data_header = "---\nTitle:\t %s\nAuthor:\t Maverun\nDate:\t "..os.date("%A, %m %B %Y").."\n---\n\n"
	-- data_header = "---Title: %s"
    },
    tree = {
	automatic_data_creation = false
    },
})
