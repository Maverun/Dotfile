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
    { "BufEnter", "*", "setlocal formatoptions-=o" };
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
    { "VimResized,WinEnter,BufWinEnter", "*", [[lua require'utils'.toggle_colorcolumn()]]};
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
}

nvim_create_augroups(autocmds)
