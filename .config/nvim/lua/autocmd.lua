local vim = vim
local api = vim.api

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



local autocmds = {
    set_formatoptions = {
        { "BufNewFile,BufEnter", "*", "setlocal formatoptions-=cro" };
    };
    terminal_job = {
        -- conflicts with neoterm
        --{ "TermOpen", "*", "startinsert" };
        { "TermOpen", "*", "setlocal listchars= nonumber norelativenumber" };
    };
    resize_windows_proportionally = {
        { "VimResized", "*", [[tabdo wincmd =]]};
    };
    toggle_colorcolumn = {
        { "VimResized,WinEnter,BufWinEnter", "*", [[lua require'utils'.toggle_cursor_column()]]};
    },
    toggle_search_highlighting = {
        { "InsertEnter", "*", ":nohl | redraw" };
    };
    lua_highlight = {
        { "TextYankPost", "*", "silent! lua vim.highlight.on_yank{higroup='IncSearch', timeout=2000}" };
    };
    quickscope = {
        { 'ColorScheme', '*', 'highlight QuickScopePrimary guifg=#afff5f gui=underline ctermfg=50 cterm=underline'};
        { 'ColorScheme', '*', 'highlight QuickScopeSecondary guifg=#5fffff gui=underline ctermfg=50 cterm=underline'};

    };
    packer = {
        {'BufWritePost','plugins.lua','PackerCompile'}
    };
    map_K = {
        {'FileType','man', [[:lua vim.api.nvim_buf_set_keymap(0,"n","K",":lua vim.api.nvim_feedkeys('K','n',true)<CR>",{noremap=true,silent=true})]]},
        {'FileType','help',[[:lua vim.api.nvim_buf_set_keymap(0,"n","K",":lua vim.api.nvim_feedkeys('K','n',true)<CR>",{noremap=true,silent=true})]]},
    },
    quit = {
        {'FileType','dashboard', [[:lua vim.api.nvim_buf_set_keymap(0,"n","q","<esc>:q<cr>",{noremap=true,silent=true})]]},
    },
    --search_nohl = {
    --{'CmdlineEnter', '/,\\?','set hlsearch'};
    --{'CmdlineLeave','/,\\?','set nohlsearch'};
    --}
    -- show_signature = {
    --     {'CursorHoldI','*',[[lua require'utils'.Show_func_help()]]}
    -- },
    color_floating_window = {
        -- {'ColorScheme','*','highlight NormalFloat guibg=#005500'},
        {'ColorScheme','*','highlight FloatBorder guifg=#005500'},
    },
    dap = {

        {'FileType', 'dap-repl', 'nnoremap<buffer> n', [[<cmd>lua require('dap').step_over()<CR> ]]},
        {'FileType', 'dap-repl', 'nnoremap<buffer> s', [[<cmd>lua require('dap').step_into()<CR>]]},
        {'FileType', 'dap-repl', 'nnoremap<buffer> c', [[<cmd>lua require('dap').continue()<CR>]]}
    },
    latex = {
		{'FileType','tex','set wrap'},
		{'FileType','tex','nnoremap<buffer>j gj'},
		{'FileType','tex','nnoremap<buffer>k gk'},
	}
}

nvim_create_augroups(autocmds)
