local vim = vim
local api = vim.api
local augroup = vim.api.nvim_create_augroup
local aucmd = vim.api.nvim_create_autocmd

-- Taken from https://github.com/norcalli/nvim_utils
local function nvim_create_augroups(definitions)
  for group_name, definition in pairs(definitions) do
    api.nvim_command('augroup '..group_name)
    api.nvim_command('autocmd!')
    for _, def in ipairs(definition) do
      local command = table.concat(vim.tbl_flatten{'autocmd', def}, ' ')
      api.nvim_command(command)
    end
    api.nvim_command('augroup END')
  end
end


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

augroup('packer',{clear = true})
aucmd('BufWritePost',{
    group = 'packer',
    pattern = '*',
    command = 'PackerCompile',
    desc = "Auto compile when you save packer files so quicker loader",
})

augroup('map_K_DOC',{clear = true})
aucmd('FileType',{
    group = 'map_K_DOC',
    pattern = {'man','help'},
    callback = function() api.nvim_buf_set_keymap(0,'n','K',[[:lua vim.api.nvim_feedkeys('K','n',true)<CR>]],{noremap=true,silent=true}) end,
    desc = "Usually K  is blank to avoid annoying since auto shift is enable, so when enter the docs/help, this help",
})

augroup('dashboard_custom',{clear = true})
aucmd('FileType',{
    group = 'dashboard_custom',
    pattern = 'dashboard',
    callback = function()
	api.nvim_buf_set_keymap(0,'n','q','<esc>:q<cr>',{noremap = true, silent = true})
	api.nvim_buf_set_keymap(0,'n','f',':enew<cr>:set laststatus=2<cr>',{noremap = true, silent = true})
    end,
    desc = "Able to quit at dashboard",
})

-- aucmd('FileType',{
--     group = 'dashboard_custom',
--     pattern = 'dashboard',
--     callback = function() api.nvim_buf_set_keymap(0,'n','f',':enew<cr>:set laststatus=2<cr>',{noremap = true, silent = true}) end,
--     desc = "Able to create new files at dashboard",
-- })

augroup('dapCustom',{clear = true})
aucmd('FileType',{
    group = 'dapCustom',
    pattern = 'dap-repl',
    callback = function()
        api.nvim_buf_set_keymap(0,'n','n',":lua require('dap').step_over()<CR>",{noremap = true, silent = true})
        api.nvim_buf_set_keymap(0,'n','s',":lua require('dap').step_into()<CR>",{noremap = true, silent = true})
        api.nvim_buf_set_keymap(0,'n','c',":lua require('dap').continue()<CR>",{noremap = true, silent = true})
    end,
    desc = "During Dap repl mode, we can just press key to do instead of command",
})
-- aucmd('FileType',{
--     group = 'dap',
--     pattern = 'dap-repl',
--     callback = function() api.nvim_buf_set_keymap(0,'n','n',":lua require.('dap').step_over()",{noremap = true, silent = true}) end,
--     desc = "During Dap repl mode, we can just press key to do instead of command",
-- })
--
-- aucmd('FileType',{
--     group = 'dap',
--     pattern = 'dap-repl',
--     callback = function() api.nvim_buf_set_keymap(0,'n','s',":lua require.('dap').step_into()",{noremap = true, silent = true}) end,
--     desc = "During Dap repl mode, we can just press key to do instead of command",
-- })
--
--
-- aucmd('FileType',{
--     group = 'dap',
--     pattern = 'dap-repl',
--     callback = function() api.nvim_buf_set_keymap(0,'n','c',":lua require.('dap').continue()",{noremap = true, silent = true}) end,
--     desc = "During Dap repl mode, we can just press key to do instead of command",
-- })

augroup('wrapText',{clear = true})
aucmd('FileType',{
    group = 'wrapText',
    pattern = {'tex','text','orgmode'},
    callback = function()
	vim.opt.wrap = true
	api.nvim_buf_set_keymap(0,'n','j','gj',{noremap = true, silent = true})
	api.nvim_buf_set_keymap(0,'n','k','gk',{noremap = true, silent = true})
    end,
    desc = "setting wrap since it is only for text so reading paragraph will be annoying",
})

-- aucmd('FileType',{
--     group = 'wrapText',
--     pattern = {'tex','text'},
--     callback = function()  end,
--     desc = "Since there is wrap, this allow to go through each line instead of skip to newline due to wrap",
-- })
--
-- aucmd('FileType',{
--     group = 'wrapText',
--     pattern = {'tex','text'},
--     callback = function() api.nvim_buf_set_keymap(0,'n','k','gk',{noremap = true, silent = true}) end,
--     desc = "Since there is wrap, this allow to go through each line instead of skip to newline due to wrap",
-- })

augroup('hop',{clear = true})
aucmd('ColorScheme',{
    group = 'hop',
    pattern = '*',
    command = 'highlight HopNextKey2 guifg=#0a94ac',
    desc = "Setting hop 2nd char easier to see, since original/default is harder to see",
})

-- local autocmds = {
    -- set_formatoptions = {
    --     { "BufNewFile,BufEnter", "*", "setlocal formatoptions-=cro" };
    -- };
    -- terminal_job = {
    --     -- conflicts with neoterm
    --     --{ "TermOpen", "*", "startinsert" };
    --     { "TermOpen", "*", "setlocal listchars= nonumber norelativenumber" };
    -- };
    -- resize_windows_proportionally = {
    --     { "VimResized", "*", [[tabdo wincmd =]]};
    -- };
    -- toggle_colorcolumn = {
    --     { "VimResized,WinEnter,BufWinEnter", "*", [[lua require'utils'.toggle_cursor_column()]]};
    -- },
    -- toggle_search_highlighting = {
    --     { "InsertEnter", "*", ":nohl | redraw" };
    -- };
    -- lua_highlight = {
    --     { "TextYankPost", "*", "silent! lua vim.highlight.on_yank{higroup='IncSearch', timeout=2000}" };
    -- };
    -- quickscope = {
    --     { 'ColorScheme', '*', 'highlight QuickScopePrimary guifg=#afff5f gui=underline ctermfg=50 cterm=underline'};
    --     { 'ColorScheme', '*', 'highlight QuickScopeSecondary guifg=#5fffff gui=underline ctermfg=50 cterm=underline'};
    --
    -- };
    -- packer = {
    --     {'BufWritePost','plugins.lua','PackerCompile'}
    -- };
    -- map_K = {
    --     {'FileType','man', [[:lua vim.api.nvim_buf_set_keymap(0,"n","K",":lua vim.api.nvim_feedkeys('K','n',true)<CR>",{noremap=true,silent=true})]]},
    --     {'FileType','help',[[:lua vim.api.nvim_buf_set_keymap(0,"n","K",":lua vim.api.nvim_feedkeys('K','n',true)<CR>",{noremap=true,silent=true})]]},
    -- },
    -- quit = {
    --     {'FileType','dashboard', [[:lua vim.api.nvim_buf_set_keymap(0,"n","q","<esc>:q<cr>",{noremap=true,silent=true})]]},
    -- },
    --search_nohl = {
    --{'CmdlineEnter', '/,\\?','set hlsearch'};
    --{'CmdlineLeave','/,\\?','set nohlsearch'};
    --}
    -- show_signature = {
    --     {'CursorHoldI','*',[[lua require'utils'.Show_func_help()]]}
    -- },
    -- color_floating_window = {
    --     -- {'ColorScheme','*','highlight NormalFloat guibg=#005500'},
    --     {'ColorScheme','*','highlight FloatBorder guifg=#005500'},
    -- },
--     dap = {
--
--         {'FileType', 'dap-repl', 'nnoremap<buffer> n', [[<cmd>lua require('dap').step_over()<CR> ]]},
--         {'FileType', 'dap-repl', 'nnoremap<buffer> s', [[<cmd>lua require('dap').step_into()<CR>]]},
--         {'FileType', 'dap-repl', 'nnoremap<buffer> c', [[<cmd>lua require('dap').continue()<CR>]]}
--     },
--     latex = {
--         {'FileType','tex','set wrap'},
--         {'FileType','tex','nnoremap<buffer>j gj'},
--         {'FileType','tex','nnoremap<buffer>k gk'},
-- 	},
--     hop = {
--         { 'ColorScheme', '*', 'highlight HopNextKey2 guifg=#0a94ac'};
--     },
-- }

-- nvim_create_augroups(autocmds)

-- Run the program wIth @g so that we can see output, on split window
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
