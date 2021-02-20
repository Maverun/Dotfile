call plug#begin('~/.config/nvim/autoload/plugged')

    " Better Syntax Support
    Plug 'sheerun/vim-polyglot'
    " File Explorer
    Plug 'scrooloose/NERDTree'
    " Auto pairs for '(' '[' '{'
    Plug 'jiangmiao/auto-pairs'
    "Plug 'valloric/youcompleteme',{'do':'./install.py --tern-completer'} "compete what you want to type
    Plug 'majutsushi/tagbar' "display tags
    Plug 'scrooloose/nerdcommenter' "Commenter!
    "Plug 'ervandew/supertab' "Super tab
    Plug 'luochen1990/rainbow' "Rainbow parenthesis etc
    "Plug 'nathanaelkane/vim-indent-guides' "Add highlight of column to show intent.
    Plug 'tpope/vim-surround'
    Plug 'easymotion/vim-easymotion' 
    Plug 'tmhedberg/simpylfold' "for Python fold...
    Plug 'neoclide/coc.nvim', {'branch': 'release'} "Better version of YouCompleteme? Work with NVIM
    Plug 'itchyny/lightline.vim' "Status bar at bottom
    Plug 'ap/vim-css-color' "to show what color look like
    Plug 'vimwiki/vimwiki' " Personal Wiki for VIM (as in your own wiki
    Plug 'wakatime/vim-wakatime' "Waka time
    Plug 'yggdroot/indentline' "to display indent line, better than intent guide?
    Plug 'blindFS/vim-taskwarrior'
    Plug 'tbabej/taskwiki' "Taskwarrior on VIMWIKI
    Plug 'mattn/calendar-vim' "Calendar for vimwiki and general use
    Plug 'powerman/vim-plugin-AnsiEsc' "Heard this useful for TaskWarrior
    Plug 'kshenoy/vim-signature' "To display where MARK is at (ma, mb ) etc
    Plug 'tpope/vim-repeat' "Repeat command previous..
    Plug 'mattn/emmet-vim' "HTML dealing stuff
    Plug 'mhinz/vim-startify' "Home page of VIM/NEOVIM
    Plug 'junegunn/fzf', { 'do': { -> fzf#install() } } "Allowing Fuzzle Finder Search!
    Plug 'junegunn/fzf.vim'
    Plug 'voldikss/vim-floaterm'
    Plug 'plasticboy/vim-markdown'
call plug#end()
