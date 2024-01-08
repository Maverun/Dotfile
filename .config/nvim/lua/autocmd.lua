local vim = vim
local api = vim.api
local augroup = vim.api.nvim_create_augroup
local aucmd = vim.api.nvim_create_autocmd

augroup('set_formatoptions',{clear = true})
aucmd({'BufNewFile','BufEnter'},{
    group = 'set_formatoptions',
    pattern = '*',
    command = 'setlocal formatoptions-=cro',
    desc = "screw those format, even continue comment next line.",
})

augroup('terminal_job',{clear = true})
aucmd('Termopen',{
    group = 'terminal_job',
    pattern = '*',
    command = 'setlocal listchars= nonumber norelativenumber',
    desc = "Setting terminal minimal, we dont want any unnecessary ",
})
aucmd('VimLeave',{
    group = 'terminal_job',
    pattern = '*',
    command = 'set guicursor=a:block-blinkon0',
    desc = "Fix Cursor issues?",
})

augroup('resize_windows_proportionally',{clear = true})
aucmd('VimResized',{
    group = 'resize_windows_proportionally',
    pattern = '*',
    command = 'tabdo wincmd =]',
    desc = "Setting window proprtionally",
})

augroup('toggle_colorcolumn',{clear = true})
aucmd({'VimResized','WinEnter','BufWinEnter'},{
    group = 'toggle_colorcolumn',
    pattern = '*',
    callback = require'utils'.toggle_cursor_column,
    desc = "Disable previous buffer and show only cursor line/column on current buffer",
})

augroup('toggle_search_highlighting',{clear = true})
aucmd('InsertEnter',{
    group = 'toggle_search_highlighting',
    pattern = '*',
    command = 'nohl | redraw',
    desc = "Disable Search when enter insert mode.",
})

augroup('yankHighlight',{clear = true})
aucmd('TextYankPost',{
    group = 'yankHighlight',
    pattern = '*',
    callback = function() vim.highlight.on_yank{higroup='IncSearch',timeout=2000} end,
    desc = "Show what you yank.",
})

augroup('quickscope',{clear = true})
aucmd('ColorScheme',{
    group = 'quickscope',
    pattern = '*',
    command = 'highlight QuickScopePrimary guifg=#afff5f gui=underline ctermfg=50 cterm=underline',
    desc = "Change quickscope primary color to easier one to see",
})

aucmd('ColorScheme',{
    group = 'quickscope',
    pattern = '*',
    command = 'highlight QuickScopeSecondary guifg=#5fffff gui=underline ctermfg=50 cterm=underline',
    desc = "change quickscope secondary color to see easier",
})

augroup('map_K_DOC',{clear = true})
aucmd('FileType',{
    group = 'map_K_DOC',
    pattern = {'man','help'},
    callback = function() api.nvim_buf_set_keymap(0,'n','K',[[:lua vim.api.nvim_feedkeys('K','n',true)<CR>]],{noremap=true,silent=true}) end,
    desc = "Usually K  is blank to avoid annoying since auto shift is enable, so when enter the docs/help, this help",
})

augroup('wrapText',{clear = true})
aucmd('FileType',{
    group = 'wrapText',
    pattern = {'md','tex','text','org'},
    callback = function()
	vim.opt.wrap = true
	api.nvim_buf_set_keymap(0,'n','j','gj',{noremap = true, silent = true})
	api.nvim_buf_set_keymap(0,'n','k','gk',{noremap = true, silent = true})
    end,
    desc = "setting wrap since it is only for text so reading paragraph will be annoying",
})

augroup('hop',{clear = true})
aucmd('ColorScheme',{
    group = 'hop',
    pattern = '*',
    command = 'highlight HopNextKey2 guifg=#0a94ac',
    desc = "Setting hop 2nd char easier to see, since original/default is harder to see",
})


local userWinbar = augroup('userWinbar', { clear = true })
local winbar = require('winbar')
winbar.setup()
aucmd({ 'BufEnter', 'BufWinEnter' }, {
    group = userWinbar,
    desc = 'Adds winbar based on ft',
    callback = function()
	winbar.eval()
    end
})

-- Run the program with @g so that we can see output, on split window
vim.cmd [[
	augroup run_file
		autocmd BufEnter *.java let @g=":w\<CR>:vsp | terminal java %\<CR>i"
		autocmd BufEnter *.py let @g=":w\<CR>:vsp |terminal python %\<CR>i"
		autocmd BufEnter *.asm let @g=":w\<CR> :!nasm -f elf64 -o out.o % && ld out.o -o a.out \<CR> | :vsp |terminal ./a.out\<CR>i"
		autocmd BufEnter *.cpp let @g=":w\<CR> :!g++ %\<CR> | :vsp |terminal ./a.out\<CR>i"
		autocmd BufEnter *.c let @g=":w\<CR> :!gcc %\<CR> | :vsp |terminal ./a.out\<CR>i"
		autocmd BufEnter *.go let @g=":w\<CR> :vsp | terminal go run % \<CR>i"
		autocmd BufEnter *.js let @g=":w\<CR> :vsp | terminal node % \<CR>i"
		autocmd BufEnter *.html let @g=":w\<CR> :silent !firefox % \<CR>"
	augroup end
]]

