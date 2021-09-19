local fn = vim.fn
local o = vim.o
local cmd = vim.cmd


vim.g.startify_bookmarks = {
   { b = '~/.bashrc' },
   { v = '~/.config/nvim/init.lua' },
   { g = '~/.config/nvim/lua/settings.lua' },
   { m = '~/.config/nvim/lua/mappings.lua' },
   { p = '~/.config/nvim/lua/plugins.lua' },
   { w = '/ext_drive/SynologyDrive/vimwiki/index.md' },
   }


--vim.g.startify_lists = {{
       --{ header = {'   Bookmarks'},       type = 'bookmarks' },
       --{ header = {'   Recently'},            type = 'files' },
       --{ header = {'   Current Directory '.. fn.getcwd()}, type = 'dir' },
       --{ header = {'   Sessions '}, type = 'sessions' },
       --{ header = {'   Commands '}, type = 'commands' },
--}}
vim.g.startify_lists = {{
        type = 'bookmarks',
        header = {'   Bookmarks'}
    }, {
        type = 'files',
        header = {'   Recently'}
    }, {
        type = 'dir',
        header = {'   Files ' .. fn.getcwd()}
    }, {
        type = 'sessions',
        header = {'   Sessions'}
    }, {
        type = 'commands',
        header = {'   Commands'}
    }}

vim.g.startify_fortune_use_unicode = 1
vim.g.startify_session_dir = '~/.config/nvim/session'


vim.g.startify_custom_header = {
       '.__   __.  _______   ______   ____    ____  __  .___  ___.',
       '|  \\ |  | |   ____| /  __  \\  \\   \\  /   / |  | |   \\/   |',
       '|   \\|  | |  |__   |  |  |  |  \\   \\/   /  |  | |  \\  /  |',
       '|  . `  | |   __|  |  |  |  |   \\      /   |  | |  |\\/|  |',
       '|  |\\   | |  |____ |  `--`  |    \\    /    |  | |  |  |  |',
       '|__| \\__| |_______| \\______/      \\__/     |__| |__|  |__|',
       '                                                          ',
}

cmd 'hi StartifyHeader  ctermfg=114 guifg=#87d787'
