call plug#begin('~/.config/nvim/autoload/plugged')

"=============================================================================="
"                                  Apperiances                                 "
"=============================================================================="

    "Plug 'itchyny/lightline.vim' "Status bar at bottom
    Plug 'yggdroot/indentline' "to display indent line, better than intent guide?
    Plug 'tmhedberg/simpylfold' "for Python fold...
    Plug 'ap/vim-css-color' "to show what color look like
    Plug 'sheerun/vim-polyglot' "Better Syntax Support
    Plug 'kshenoy/vim-signature' "To display where MARK is at (ma, mb ) etc
    Plug 'mhinz/vim-startify' "Home page of VIM/NEOVIM
    Plug 'chrisbra/csv.vim'

"=============================================================================="
"                                     Auto                                     "
"=============================================================================="

    Plug 'jiangmiao/auto-pairs' " Auto pairs for ( [ {
    Plug 'neoclide/coc.nvim', {'branch': 'release'} "Better version of YouCompleteme? Work with NVIM
    Plug 'luochen1990/rainbow' "Rainbow parenthesis etc
    Plug 'wakatime/vim-wakatime' "Waka time
    Plug 'zhimsel/vim-stay' "Remember fold, cursor etc
    Plug 'unblevable/quick-scope' "Show highlight key for f,F,t,T, best thing.

"=============================================================================="
"                                  Navagation                                  "
"=============================================================================="
    
    Plug 'easymotion/vim-easymotion' "Motion, rumor say less stoke get you everywhere
    Plug 'scrooloose/NERDTree' "File Explorer
    Plug 'majutsushi/tagbar' "display tags
  
"=============================================================================="
"                                    VIMWIKI                                   "
"=============================================================================="

    Plug 'vimwiki/vimwiki' " Personal Wiki for VIM (as in your own wiki
    Plug 'plasticboy/vim-markdown' "vim markdown for vimwiki
    Plug 'mattn/calendar-vim' "Calendar for vimwiki and general use
    Plug 'blindFS/vim-taskwarrior' "TaskWarrior API
    Plug 'tbabej/taskwiki' "Taskwarrior on VIMWIKI
    Plug 'powerman/vim-plugin-AnsiEsc' "Heard this useful for TaskWarrior
   
"=============================================================================="
"                                    Useful                                    "
"=============================================================================="

    Plug 'scrooloose/nerdcommenter' "Commenter!
    Plug 'tpope/vim-surround' "Adding Symbol around it () <> [] {} etc
    Plug 'voldikss/vim-floaterm' "Floating Terminal
    Plug 'tpope/vim-repeat' "Repeat command previous..
    Plug 'mattn/emmet-vim' "HTML dealing stuff
    Plug 'junegunn/fzf',{ 'do': { -> fzf#install() } } "Allowing Fuzzle Finder Search!
    Plug 'junegunn/fzf.vim' "FZF well u know fuzzy finder thingy
    Plug 'SirVer/ultisnips' "Snips
    "Plug 'honza/vim-snippets' "snips #Dont think i want to more...custom is gd
    Plug  'jalvesaq/Nvim-R' "In replace of Rstudio
    Plug 'tjdevries/train.nvim' "To be Gitgud, Rumor say master UP AND DOWN SON!

call plug#end()
