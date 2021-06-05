-- ┌───────────────────────────────────────────────────────────────────────────┐
-- │                                 Settings                                  │
-- └───────────────────────────────────────────────────────────────────────────┘

local cmd = vim.cmd  -- to execute Vim commands e.g. cmd('pwd')
local fn = vim.fn    -- to call Vim functions e.g. fn.bufnr()
local g = vim.g      -- a table to access global variables


local scopes = {o = vim.o, b = vim.bo, w = vim.wo}

local function opt(scope, key, value)
  scopes[scope][key] = value
  if scope ~= 'o' then scopes['o'][key] = value end
end

--Show that we copy
cmd 'au TextYankPost * silent! lua vim.highlight.on_yank{higroup="IncSearch", timeout=700}'

opt('o','syntax','on')               -- Able syntax
opt('o', 'hidden', true)             -- Enable modified buffers in background
opt('o', 'encoding', 'utf-8')        -- Encoding displayed
opt('o', 'fileencoding', 'utf-8')    -- Encoding written to files
opt('o', 'termguicolors', true)      -- True color support
opt('o', 'joinspaces', false)        -- No double spaces with join after a dot
opt('o', 'scrolloff', 5 )            -- Lines of context
opt('o', 'sidescrolloff', 8 )        -- Columns of context
opt('o', 'splitright', true)         -- Put new windows right of current
opt('o', 'splitbelow', true)         -- Put new windows below current
opt('o', 'wildmode', 'list:longest') -- Command-line completion mode
opt('w', 'list', true)               -- Show some invisible characters (tabs...)
opt('w', 'number', true)             -- Print line number
opt('w', 'relativenumber', true)     -- Relative line numbers
opt('w', 'wrap', false)              -- Disable line wrap
opt('o', 'ruler',true)               -- Cursor ruler
opt('o', 'inccommand',"split")       -- Allow to see change when replace via :s/
opt('o', 'mouse',"a")                -- Allow to use mouse
opt('o', 'showmode',false)           -- Dont show default -- Insert --
opt('w','spell',true)                -- well...duh
opt('o', 'smartcase', true)          -- Don't ignore case with capitals
opt('o', 'ignorecase', true)         -- Ignore case

opt('o', 'backup',false)             -- Disable Backup since it is bit annoying to deal when open files
opt('o','writebackup',false)         -- similar as backup setting

opt('o', 'clipboard','unnamedplus')  -- allow to merge with system clipboard
opt('o', 'cmdheight',1)              -- set command height 1

opt('o', 'updatetime',300)
opt('o', 'timeoutlen',500)

cmd 'set iskeyword -=-'              -- allow to ignore - as one word
opt('o','autochdir',true)            -- Working directory will be always same
-- opt('b','filetype','plugin')
cmd 'set fillchars+=vert:▏'          -- Setting Window Vertical border to thin

opt('w','conceallevel',2)            -- allow to view markdown ease

cmd 'autocmd BufNewFile,BufRead * setlocal formatoptions-=cro'

-- ┌───────────────────────────────────────────────────────────────────────────┐
-- │                                    Tab                                    │
-- └───────────────────────────────────────────────────────────────────────────┘

local indent = 4

opt('b', 'expandtab', true)                           -- Use spaces instead of tabs
opt('b', 'shiftwidth', indent)                        -- Size of an indent
opt('b', 'smartindent', true)                         -- Insert indents automatically
opt('b', 'tabstop', indent)                           -- Number of spaces tabs count for
opt('o', 'shiftround', true)                          -- Round indent

-- ┌───────────────────────────────────────────────────────────────────────────┐
-- │                                   Fold                                    │
-- └───────────────────────────────────────────────────────────────────────────┘

opt('w','foldmethod','manual')

-- ┌───────────────────────────────────────────────────────────────────────────┐
-- │                                  Column                                   │
-- └───────────────────────────────────────────────────────────────────────────┘

opt('w','cursorline',true)
opt('w','cursorcolumn',true)

-- Color of line,column line and line number to know differences
-- hi CursorLine   cterm=NONE ctermbg=237 ctermfg=NONE guibg=darkred guifg=white
-- hi CursorColumn cterm=NONE ctermbg=237 ctermfg=NONE guibg=darkred guifg=white
-- hi CursorLineNr cterm=None ctermbg=237 ctermfg=50
-- This is Line number that are not current line, current line color is ^
-- hi LineNr cterm=None ctermbg=237 ctermfg=70
-- This is to set column line up so we know where we reached end of famous 80th
opt('w','colorcolumn',"80")
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


--FZF Notation FZF for notes
g.nv_search_paths = {
    "/ext_drive/SynologyDrive/NotesTaking/Dev",
    "/ext_drive/SynologyDrive/NotesTaking/Home",
}

g.vim_markdown_conceal = 2



-- ┌───────────────────────────────────────────────────────────────────────────┐
-- │                               Plugins Setup                               │
-- └───────────────────────────────────────────────────────────────────────────┘

--Any plugins that will take over 20+ lines will be individual files 

require('nvim-treesitter.configs').setup{
  ensure_installed = 'maintained',
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = true -- <= THIS LINE is the magic! for spelling
  },
  indent = {enable = true},
  autotag = {enable = true},
  incremental_selection = {enable = true}
}



require('high-str').setup({
	verbosity = 0,
	highlight_colors = {
		-- color_id = {"bg_hex_code",<"fg_hex_code"/"smart">}
		color_0 = {"#000000", "smart"},	-- Chartreuse yellow
		color_1 = {"#e5c07b", "smart"},	-- Pastel yellow
		color_2 = {"#7FFFD4", "smart"},	-- Aqua menthe
		color_3 = {"#8A2BE2", "smart"},	-- Proton purple
		color_4 = {"#FF4500", "smart"},	-- Orange red
		color_5 = {"#008000", "smart"},	-- Office green
		color_6 = {"#0000FF", "smart"},	-- Just blue
		color_7 = {"#FFC0CB", "smart"},	-- Blush pink
		color_8 = {"#FFF9E3", "smart"},	-- Cosmic latte
		color_9 = {"#7d5c34", "smart"},	-- Fallow brown
	}
})

require('no-clc').setup({
	load_at_startup = true,
	cursorline = true,
	cursorcolumn = true
})


require'surround'.setup{}
--require'navigator'.setup()
require'lsp_signature'.on_attach()
require'colorizer'.setup{}
require'trouble'.setup{}
require'FTerm'.setup{}
require'lspsaga'.init_lsp_saga()
--require'which-key'.setup{}
