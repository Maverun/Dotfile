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

 function test()
    local lua = require('luasnip')
    print(lua.session.event_node:get_text()[1])
end


local autocmds = {
    luasnip = {
    --{ 'User','LuasnipInsertNodeEnter','lua test()'},
    { 'User','LuasnipInsertNodeLeave','lua print(require("luasnip").session.event_node:get_text()[1])'}
},
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
    --search_nohl = {
    --{'CmdlineEnter', '/,\\?','set hlsearch'};
    --{'CmdlineLeave','/,\\?','set nohlsearch'};
    --}
}

nvim_create_augroups(autocmds)
