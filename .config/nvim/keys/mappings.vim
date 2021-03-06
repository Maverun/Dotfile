let mapleader = "\\"

"Better nav for omnicomplete
inoremap <expr> <c-j> ("\<C-n>")
inoremap <expr> <c-k> ("\<C-p>")

"Use alt + hjkl to resize windows
nnoremap <M-j>    :resize -2<CR>
nnoremap <M-k>    :resize +2<CR>
nnoremap <M-h>    :vertical resize -2<CR>
nnoremap <M-l>    :vertical resize +2<CR>

" I hate escape more than anything else
inoremap jk <Esc>
inoremap kj <Esc>

" Easy CAPS
inoremap <c-u> <ESC>viwUi
nnoremap <c-u> viwU<Esc>


" TAB in general mode will move to text buffer

" SHIFT-TAB will go back
"iunmap <S-Tab>
inoremap <S-Tab> <C-d>
" for command mode
nnoremap <S-Tab> <<
" Alternate way to save
nnoremap <C-s> :w<CR>
inoremap <C-s> <Esc>:w<CR>i<Right>
" Alternate way to quit
nnoremap <C-Q> :wq!<CR>
" Use control-cap instead of escape
nnoremap <C-c> <Esc>
" <TAB>: completion.
"inoremap <expr><TAB> pumvisible() ? "\<C-n>" : "\<TAB>"

" Better tabbing
vnoremap < <gv
vnoremap > >gv
vnoremap <Tab> >
vnoremap <S-Tab> <
" Better window navigation
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l
    
nnoremap <Leader>o o<Esc>^Da
nnoremap <Leader>O O<Esc>^Da

"Auto excute python with F5
nnoremap <F5> <Esc>:w !clear;python 
inoremap <F5> <Esc>:w !clear;python

"Shift Enter to enter new line from current line
inoremap <S-CR> <Esc>o
"inoremap <C-S-j> <Esc>o
"nnoremap <C-S-j> o<Esc>

"Shift line up  or down
vmap <S-Up> :m-2<CR>gv
vmap <S-Down> :m '>+1<CR>gv
nmap <S-Up> <Esc>:m-2 <CR>
nmap <S-Down> <Esc>:m+1 <CR>
inoremap <S-Up> <Esc>:m-2 <CR>
inoremap <S-Down> <Esc>:m+1 <CR>
inoremap <C-k> <Esc>:m-2 <CR>a
inoremap <C-j> <Esc>:m+1 <CR>a

"This is to dupe the line during insert mode
inoremap <C-d> <Esc>0y$o<Esc>pi

"Tab toggle
nnoremap <C-t> :TagbarToggle<CR>
nnoremap <Leader><Space> :nohlsearch<CR>

nnoremap <F2> :NERDTreeToggle<CR>
nnoremap <F3> :RainbowToggle<CR>
nnoremap <F6> :set relativenumber <CR>
nnoremap <F7> :set nornu <CR>

inoremap <C-Del> <esc>dwi

"Startify plugins hotkey
nmap <c-n> :Startify<cr>

"This is floaterm (Floating Terminal)
let g:floaterm_keymap_new = '<Leader>ft'
let g:floaterm_keymap_toggle = '<Leader>t'
let g:floaterm_keymap_next = '<Leader>fn'
let g:floaterm_keymap_prev= '<Leader>fp'

"FZF mapping
nnoremap <C-p> :Files<Cr>

"This is Ultisnip setting 
"let g:UltiSnipsExpandTrigger = "<C-tab>" "setting this NONE since it ignore COC
let g:UltiSnipsExpandTrigger="<C-CR>"
let g:UltiSnipsJumpForwardTrigger="<C-j>"
let g:UltiSnipsJumpBackwardTrigger="<C-k>"


"Disable curse Middle click paste... just in case
map <MiddleMouse> <Nop>
imap <MiddleMouse> <Nop>
map <2-MiddleMouse> <Nop>
imap <2-MiddleMouse> <Nop>
map <3-MiddleMouse> <Nop>
imap <3-MiddleMouse> <Nop>
map <4-MiddleMouse> <Nop>
imap <4-MiddleMouse> <Nop>
