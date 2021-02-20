syntax enable                           " Enables syntax highlighing
set hidden                              " Required to keep multiple buffers open multiple buffers
set nowrap                              " Display long lines as just one line
set encoding=utf-8                      " The encoding displayed
set pumheight=10                        " Makes popup menu smaller
set fileencoding=utf-8                  " The encoding written to file
set ruler              			            " Show the cursor position all the time
set cmdheight=1                         " More space for displaying messages
set iskeyword+=-                      	" treat dash separated words as a word text object"
set mouse=a                             " Enable your mouse
set splitbelow                          " Horizontal splits will automatically be below
set splitright                          " Vertical splits will automatically be to the right
set t_Co=256                            " Support 256 colors
set tabstop=4                           " Insert 2 spaces for a tab
set shiftwidth=4                        " Change the number of space characters inserted for indentation
set smarttab                            " Makes tabbing smarter will realize you have 2 vs 4
set expandtab                           " Converts tabs to spaces
set smartindent                         " Makes indenting smart
set autoindent                          " Good auto indent
"set laststatus=0                        " Always display the status line
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
filetype plugin on
set foldlevelstart=99
"set columns=80

set autochdir                           " Your working directory will always
"be the same as your working directory
"
"au! BufWritePost $MYVIMRC source %      " auto source when writing to init.vm
"alternatively you can run :source $MYVIMRC
"
"" You can't stop me
cmap w!! w !sudo tee %

let g:SuperTabClosePreviewOnPopupClose = 1
highlight Pmenu ctermbg=darkgrey ctermfg=white gui=bold

"This is Rainbow Plugins 
let g:rainbow_active = 1

"intent guide line THis is for that plugin uh Vim-indent-guides
"let g:intent_guides_enable_on_vim_startup=1
"let g:indent_guides_auto_colors = 0
"hi IndentGuidesOdd  ctermbg=235
"hi IndentGuidesEven ctermbg=237

"This is IndentLine Plugins 
let g:indentLine_char_list = ['|', '¦', '┆', '┊']

set conceallevel=2
"
"This is Simpylfold plugins setting
"
let g:SimpylFold_docstring_preview = 0 
"
"This is LightLine plugins
"
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



"
" This is for VimWiki plugin setting
"


let g:vimwiki_list = [
              \{'path': '/ext_drive/SynologyDrive/vimwiki','syntax':'markdown','ext':'.md'},
                \]

let g:vim_ext2syntax = {'.md': 'markdown', '.markdown':'markdown','.mdown':'markdown'}

"Make vimwiki markdown links as [text](text.md) instead of [text](text)
let g:vimwiki_markdown_link_ext = 1 

let g:taskwiki_markup_syntax = "markdown"
let g:markdown_folding = 1
let g:vim_markdown_conceal = 0
let g:vim_markdown_conceal_code_blocks = 0
"This is Identline plugin but since it is related to vimwiki sooo
let g:indentLine_setConceal = 2
" default ''.
" n for Normal mode
" v for Visual mode
" i for Insert mode
" c for Command line editing, for 'incsearch'
let g:indentLine_concealcursor = "nv" "This allow to show conceal stuff only in Insert mode

au BufRead,BufNewFile *.md set filetype=vimwiki
:autocmd FileType vimwiki map F4 :VimwikiMakeDiaryNote

function! ToggleCalendar()
  execute ":Calendar"
  if exists("g:calendar_open")
    if g:calendar_open == 1
      execute "q"
      unlet g:calendar_open
    else
      g:calendar_open = 1
    end
  else
    let g:calendar_open = 1
  end
endfunction
:autocmd FileType vimwiki map F5 :call ToggleCalendar()
:autocmd FileType vimwiki let g:rainbow_active=0 


"
" This is Column Line and cursor line setting there
"
set cursorline                          " Enable highlighting of the current line
set cursorcolumn                        " Enable highlighting of current column line
"Color of line,column line and line number to know differences
hi CursorLine   cterm=NONE ctermbg=237 ctermfg=NONE guibg=darkred guifg=white
hi CursorColumn cterm=NONE ctermbg=237 ctermfg=NONE guibg=darkred guifg=white
hi CursorLineNr cterm=None ctermbg=237 ctermfg=cyan
"This is Line number that are not current line, current line color is ^
hi LineNr cterm=None ctermbg=237 ctermfg=green
"This is to set column line up so we know where we reached end of famous 80th
let &colorcolumn=80
highlight colorColumn ctermbg=238

function! ToggleGrid(...)
    if exists('b:grid_row_grp') || exists('b:grid_prev_cc')
        call matchdelete(b:grid_row_grp)
        let &colorcolumn = b:grid_prev_cc
        unlet b:grid_row_grp b:grid_prev_cc
        return
    endif

    let [dr, dc] = [a:1, a:2]
    if a:0 < 4
        let [i, nr, nc] = [1, line('$'), 0]
        while i <= nr
            let k = virtcol('$')
            let nc = nc < k ? k : nc
            let i += 1
        endwhile
    else
        let [nr, nc] = [a:3, a:4]
    endif
    let rows = range(dr, nr, dr)
    let cols = range(dc, nc, dc)
    let pat = '\V' . join(map(rows, '"\\%" . v:val . "l"'), '\|')
    let x = string(pat)
    echom x
    let b:grid_row_grp = matchadd('ColorColumn', pat)
    let b:grid_prev_cc = &colorcolumn
    let &colorcolumn = join(cols, ',')
endfunction

