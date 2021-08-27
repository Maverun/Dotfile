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
opt.number = true             -- Print line number
opt.relativenumber = true     -- Relative line numbers
opt.list = true
opt.mouse = 'a'
opt.spell = true
opt.showmode = false
opt.smartcase = true
opt.ignorecase = true


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
opt.timeoutlen = 500

cmd 'set iskeyword -=-'              -- allow to ignore - as one word
opt.autochdir = true            -- Working directory will be always same
-- opt.filetype = 'plugin'
cmd 'set fillchars+=vert:▏'          -- Setting Window Vertical border to thin

opt.conceallevel = 2            -- allow to view markdown ease

opt.completeopt = "menuone,noselect"

opt.listchars = {
    tab = '',
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

opt.expandtab = true                           -- Use spaces instead of tabs
opt.shiftwidth = indent                        -- Size of an indent
opt.smartindent = true                         -- Insert indents automatically
opt.tabstop = indent                           -- Number of spaces tabs count for
opt.shiftround = true                          -- Round indent

-- ┌───────────────────────────────────────────────────────────────────────────┐
-- │                                   Fold                                    │
-- └───────────────────────────────────────────────────────────────────────────┘

opt.foldmethod = 'manual'

-- ┌───────────────────────────────────────────────────────────────────────────┐
-- │                                  Column                                   │
-- └───────────────────────────────────────────────────────────────────────────┘

opt.cursorline = true
opt.cursorcolumn = true

-- Color of line,column line and line number to know differences
-- hi CursorLine   cterm=NONE ctermbg=237 ctermfg=NONE guibg=darkred guifg=white
-- hi CursorColumn cterm=NONE ctermbg=237 ctermfg=NONE guibg=darkred guifg=white
-- hi CursorLineNr cterm=None ctermbg=237 ctermfg=50
-- This is Line number that are not current line, current line color is ^
-- hi LineNr cterm=None ctermbg=237 ctermfg=70
-- This is to set column line up so we know where we reached end of famous 80th
--opt('w','colorcolumn',"80")
opt.colorcolumn = '80'
--vim.g.colorcolumn = "80"
-- highlight colorColumn ctermbg=238

-- ┌───────────────────────────────────────────────────────────────────────────┐
-- │                                  VimStay                                  │
-- └───────────────────────────────────────────────────────────────────────────┘

g.viewoptions='cursor,folds,slash,unix'
cmd 'set viewoptions-=options'

-- ┌───────────────────────────────────────────────────────────────────────────┐
-- │                                IndentLine                                 │
-- └───────────────────────────────────────────────────────────────────────────┘

g.indent_blankline_char = '│'
g.indent_blankline_char_highlight_list = {'Error', 'Function'}
g.indent_blankline_space_char_highlight_list = {'Error', 'Function'}
--g.indent_blankline_strict_tabs = true
-- Custom Highlight group
--g.indent_blankline_char_highlight_list = {'aqua_ind' , 'grey_ind', 'yellow_ind','algea_ind'}
g.indent_blankline_use_treesitter = true
g.indent_blankline_show_trailing_blankline_indent = false
g.indent_blankline_show_first_indent_level = false
g.indent_blankline_filetype_exclude = {'markdown','md','help',''}

--FZF Notation FZF for notes
g.nv_search_paths = {
    "/ext_drive/SynologyDrive/NotesTaking/Dev",
    "/ext_drive/SynologyDrive/NotesTaking/Home",
}

g.vim_markdown_conceal = 2



-- ┌───────────────────────────────────────────────────────────────────────────┐
-- │                               Plugins Setup                               │
-- └───────────────────────────────────────────────────────────────────────────┘



require'surround'.setup{prefix=','}
--require'nvim-autopairs'.setup{}
--require'navigator'.setup()
--require'lsp_signature'.on_attach()
require'colorizer'.setup{"*"}
--require'trouble'.setup{}
--require'lspsaga'.init_lsp_saga()
require'FTerm'.setup{}
--require'which-key'.setup{}


--require"telescope".load_extension("frecency")



--miniguide = vim.api.nvim_create_namespace 'miniguide'
--function on_win(_, winid, bufnr, row)
  --if bufnr ~= vim.api.nvim_get_current_buf() then
    --return false -- FAIL
  --end
--end

--function on_line(_, winid, bufnr, row)
  --local indent = vim.fn.indent(row+1)
  --for i = 1, indent-1, 2 do
    --vim.api.nvim_buf_set_extmark(bufnr, miniguide, row, i-1, {
      --virt_text={{"│", "Selection"}}, virt_text_pos="overlay", ephemeral=true})
    --if tata then
      --ree = re
    --end
  --end
--end
--vim.api.nvim_set_decoration_provider(miniguide, {on_win=on_win, on_line=on_line})



