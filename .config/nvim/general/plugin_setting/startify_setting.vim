let g:startify_bookmarks = [
  \ { 'b': '~/.bashrc' },
  \ { 'v': '~/.config/nvim/init.vim' },
  \ { 'g': '~/.config/nvim/general/settings.vim' },
  \ { 'm': '~/.config/nvim/general/mappings.vim' },
  \ { 'p': '~/.config/nvim/general/plugins.vim' },
  \ { 'w': '/ext_drive/SynologyDrive/vimwiki/index.md' },
  \ ]

let g:startify_commands = [
  \ {'h':["help startify","h startify"]}
  \ ]

let g:startify_lists = [
      \ { 'header': ['   Bookmarks'],       'type': 'bookmarks' },
      \ { 'header': ['   Recently'],            'type': 'files' },
      \ { 'header': ['   Current Directory '. getcwd()], 'type': 'dir' },
      \ { 'header': ['   Sessions '], 'type': 'sessions' },
      \ { 'header': ['   Commands '], 'type': 'commands' },
      \ ]

let g:startify_fortune_use_unicode = 1
let g:startify_session_dir = '~/.config/nvim/session'


let g:startify_custom_header = [
      \ '.__   __.  _______   ______   ____    ____  __  .___  ___.', 
      \ '|  \ |  | |   ____| /  __  \  \   \  /   / |  | |   \/   |', 
      \ '|   \|  | |  |__   |  |  |  |  \   \/   /  |  | |  \  /  |', 
      \ '|  . `  | |   __|  |  |  |  |   \      /   |  | |  |\/|  |', 
      \ '|  |\   | |  |____ |  `--`  |    \    /    |  | |  |  |  |', 
      \ '|__| \__| |_______| \______/      \__/     |__| |__|  |__|', 
      \ '                                                          ', 
  \ ]

hi StartifyHeader  ctermfg=114 guifg=#87d787
