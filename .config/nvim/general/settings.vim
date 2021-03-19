"Other Than VIM setting, if there is any plugin setting need to config
" If they are less than 15-20 lines, its fine here else new files in plugin.

""General Setting
syntax enable                           " Enables syntax highlighing
filetype plugin on
set hidden                              " Required to keep multiple buffers open multiple buffers
set nowrap                              " Display long lines as just one line
set encoding=utf-8                      " The encoding displayed
set fileencoding=utf-8                  " The encoding written to file
"set pumheight=10                       " Makes popup menu smaller
set ruler       	                " Show the cursor position all the time
set cmdheight=1                         " More space for displaying messages
set iskeyword+=-                      	" treat dash separated words as a word text object
set mouse=a                             " Enable your mouse
set splitright                          " Vertical splits will automatically be to the right
set splitbelow                          " Horizontal splits will automatically be below
set t_Co=256                            " Support 256 colors
set termguicolors                       "Adding support of colors
"set laststatus=0                       " Always display the status line
set number                              " Line numbers
set relativenumber                      " Show relative number to current line. Easier for navations
set background=dark                     " tell vim what the background color looks like
set showtabline=2                       " Always show tabs
set noshowmode                          " We don't need to see things like -- INSERT -- anymore
set nobackup                            " This is recommended by coc
set nowritebackup                       " This is recommended by coc
set updatetime=300                      " Faster completion
set timeoutlen=500                      " By default timeoutlen is 1000 ms
set formatoptions-=cro                  " Stop newline continution of comments
set clipboard=unnamedplus               " Copy paste between vim and everything else
"set spelllang=en_us
"set spell
set nocompatible

set backspace=eol,start,indent
set autochdir                           " Your working directory will always
"be the same as your working directory
"=============================================================================="
"                                      Tab                                     "
"=============================================================================="

set tabstop=8                           " Insert 4 spaces for a tab
set softtabstop=4
set shiftwidth=4                        " Change the number of space characters inserted for indentation
set smarttab                            " Makes tabbing smarter will realize you have 2 vs 4
set expandtab                           " Converts tabs to spaces
set smartindent                         " Makes indenting smart
set autoindent                          " Good auto indent

"=============================================================================="
"                                     Fold                                     "
"=============================================================================="

set foldmethod=manual
"set nofoldenable "Dont fold auto when open files

"Or maybe should i set 8 for nice grey instead of black (0) ?
highlight Folded guibg=grey guifg=blue ctermfg=50 ctermbg=0 
highlight FoldColumn guibg=darkgrey guifg=white

"this is hold for future in case i wanna go back to manual...
" Save and restore manual folds when we exit a file
"augroup SaveManualFolds
    "autocmd!
    "au BufWinLeave, BufLeave ?* silent! mkview
    "au BufWinEnter           ?* silent! loadview
"augroup END

"=============================================================================="
"                                    Column                                    "
"=============================================================================="

set cursorline                     " Enable highlighting of the current line
set cursorcolumn                   " Enable highlighting of current column line
"Color of line,column line and line number to know differences
hi CursorLine   cterm=NONE ctermbg=237 ctermfg=NONE guibg=darkred guifg=white
hi CursorColumn cterm=NONE ctermbg=237 ctermfg=NONE guibg=darkred guifg=white
hi CursorLineNr cterm=None ctermbg=237 ctermfg=50
"This is Line number that are not current line, current line color is ^
hi LineNr cterm=None ctermbg=237 ctermfg=70
"This is to set column line up so we know where we reached end of famous 80th
let &colorcolumn=80
highlight colorColumn ctermbg=238

"=============================================================================="
"                                Cursor Setting                                "
"=============================================================================="
set guicursor=n-v-c-sm:block-Cursor,i-ci-ve:hor100-iCursor,r-cr-o:hor20


"=============================================================================="
"                              Popup Menu (PMENU)                              "
"=============================================================================="
"Popup menu thingy looks
highlight Pmenu ctermbg=238 ctermfg=white gui=bold
highlight PmenuSel ctermfg=50
"highlight Pmenu ctermbg=darkgrey ctermfg=white gui=bold

"=============================================================================="
"                           Highlight Selection Color                          "
"=============================================================================="

highlight Search ctermbg=20 ctermfg=red

"au! BufWritePost $MYVIMRC source %      " auto source when writing to init.vm
"alternatively you can run :source $MYVIMRC
"
"" You can't stop me
cmap w!! w !sudo tee %


"UltiSnips Setting
let g:UltiSnipsEditSplit="vertical"

"This is Simpylfold plugins setting
let g:SimpylFold_docstring_preview = 1

"
"This is VIM-Polyglot 
"
let g:python_highlight_space_errors = 0


"=============================================================================="
"                                   LightLine                                  "
"=============================================================================="


set laststatus=2
" delays and poor user experience.
let g:lightline = {
	\ 'colorscheme': 'wombat',
	\ 'active': {
	\   'left': [ [ 'mode', 'paste' ],
	\             [ 'cocstatus', 'readonly', 'filename', 'modified' ] ]
	\ },
	\ 'component_function': {
	\   'cocstatus': 'coc#status'
	\ },
	\ }



"=============================================================================="
"                                  IndentLine                                  "
"=============================================================================="

"This is IndentLine Plugins
let g:indentLine_char_list = ['|', '¦', '┆', '┊']

set conceallevel=2

"This is Identline plugin but related to VIMWIKI
let g:indentLine_setConceal = 2
" default ''.
" n for Normal mode
" v for Visual mode
" i for Insert mode
" c for Command line editing, for 'incsearch'
let g:indentLine_concealcursor = "nv" "This allow to show conceal stuff only in Insert mode

"=============================================================================="
"                                    VimStay                                    "
"=============================================================================="

set viewoptions=cursor,folds,slash,unix
set viewoptions-=options
"^ appear this is a reason why cmd Set give permanment...

"=============================================================================="
"                             NeoR-Rstudio Version                             "
"=============================================================================="
"This is temp plugin for my school work

" press -- to have Nvim-R insert the assignment operator: <-
let R_assign_map = "--"

" set a minimum source editor width
let R_min_editor_width = 80

" make sure the console is at the bottom by making it really wide
let R_rconsole_width = 1000

" show arguments for functions during omnicompletion
"let R_show_args = 1

" Don't expand a dataframe to show columns by default
let R_objbr_opendf = 1
let r_objbr_openlist = 1

" Press the space bar to send lines and selection to R console
vmap <Space> <Plug>RDSendSelection
nmap <Space> <Plug>RDSendLine


"=============================================================================="
"                                  Quick-Scope                                  "
"=============================================================================="
highlight QuickScopePrimary guifg='#afff5f' gui=underline ctermfg=50 cterm=underline
highlight QuickScopeSecondary guifg='#5fffff' gui=underline ctermfg=81 cterm=underline

augroup qs_colors
  autocmd!
  autocmd ColorScheme * highlight QuickScopePrimary guifg='#afff5f' gui=underline ctermfg=50 cterm=underline
  autocmd ColorScheme * highlight QuickScopeSecondary guifg='#5fffff' gui=underline ctermfg=81 cterm=underline
augroup END


colorscheme truedark_modify_mave
