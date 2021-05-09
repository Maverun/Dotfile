let mapleader = "\\"

"Better nav for omnicomplete
"inoremap <expr> <c-j> ("\<C-n>")
"inoremap <expr> <c-k> ("\<C-p>")
"=============================================================================="
"                                  Navigation                                  "
"=============================================================================="

"Use alt + hjkl to resize windows
nnoremap <M-j>    :resize -2<CR>
nnoremap <M-k>    :resize +2<CR>
nnoremap <M-h>    :vertical resize +2<CR>
nnoremap <M-l>    :vertical resize -2<CR>

" Better window navigation
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

"Buffer next page or prev
"gbn and gbp is nice optional, F12,F11 is just in case
nnoremap <F12> :bn<CR>
nnoremap <F11> :bp<CR>
nnoremap gbn :bn<CR>
nnoremap gbp :bp<CR>

"=============================================================================="
"                                 TAB Functions                                "
"=============================================================================="

"Shift Tab to de-indent
inoremap <S-Tab> <C-d>
" for command mode
nnoremap <S-Tab> <<
" Better tabbing
vnoremap < <gv
vnoremap > >gv
vnoremap <Tab> >gv
vnoremap <S-Tab> <gv

"=============================================================================="
"                                  Essentials                                  "
"=============================================================================="

" Alternate way to save
nnoremap <C-s> :w<CR>
inoremap <C-s> <Esc>:w<CR>i<Right>

" Easy CAPS
inoremap <M-u> <ESC>viwUi
nnoremap <M-u> viwU<Esc>

"Close buffer without closing window
map <leader>q :bp<bar>sp<bar>bn<bar>bd<CR>
"If i understood this... it mean, go to 
"previous buffer | split new one | buffer next | buffer delete it 
"TLDR:
" :bp | :sp | :bn | :bd 
" where | mean then do this (like pipe)

" Map Ctrl-Backspace to delete the previous word in insert mode.
" Cuz I am using new keyboard where i can double tap backspace to give
" C-backspace, so i can use itfor general stuff other than vim.
imap <C-BS> <C-W>
imap <C-f> <ESC>dea

"Shift Enter to enter new line from current line
inoremap <S-CR> <Esc>o
inoremap <M-CR> <Esc>O<Esc>0i 
"inoremap <C-S-j> <Esc>o
"nnoremap <C-S-j> o<Esc>

"Shift line up  or down
vmap <S-Up> :m-2<CR>gv
vmap <S-Down> :m '>+1<CR>gv
vmap <S-k> :m-2<CR>gv
vmap <S-j> :m '>+1<CR>gv

nmap <S-Up> <Esc>:m-2 <CR>
nmap <S-Down> <Esc>:m+1 <CR>
nmap <S-k> <Esc>:m-2 <CR>
nmap <S-j> <Esc>:m+1 <CR>

inoremap <S-Up> <Esc>:m-2 <CR>
inoremap <S-Down> <Esc>:m+1 <CR>

"this is to dupe the line during insert mode
"this sent it to reg d, so we dont lose initial just in case.
"inoremap <c-d> <esc>0y$o<esc>pi
inoremap <c-d> <esc>"dyy"dpi

vnoremap <C-d> "dygvo<esc>"dp

"This is to send selection TO VOID register
vnoremap <leader>d "_d
nnoremap <leader>d "_d
"Tab toggle
nnoremap <C-t> :TagbarToggle<CR>
nnoremap <Leader><Space> :nohlsearch<CR>

nnoremap <F2> :NERDTreeToggle<CR>
nnoremap <F3> :RainbowToggle<CR>
nnoremap <F6> :set relativenumber <CR>
nnoremap <F7> :set nornu <CR>

"Opposite of Ctrl+W, delete forward.
inoremap <C-Del> <Esc>dwi

"Disable curse Middle click paste... just in case
map <MiddleMouse> <Nop>
imap <MiddleMouse> <Nop>
map <2-MiddleMouse> <Nop>
imap <2-MiddleMouse> <Nop>
map <3-MiddleMouse> <Nop>
imap <3-MiddleMouse> <Nop>
map <4-MiddleMouse> <Nop>
imap <4-MiddleMouse> <Nop>

"Startify plugins hotkey
nmap <c-n> :Startify<cr>

"=============================================================================="
"                         Floaterm (Floating Terminal)                         "
"=============================================================================="

let g:floaterm_keymap_new = '<Leader>ft'
let g:floaterm_keymap_toggle = '<Leader>t'
let g:floaterm_keymap_next = '<Leader>fn'
let g:floaterm_keymap_prev= '<Leader>fp'

"=============================================================================="
"                                      FZF                                     "
"=============================================================================="

nnoremap <C-p> :Files<Cr>
nnoremap <Leader>b :Buffers<Cr>
nnoremap <Leader>c :Commands<Cr>
nnoremap <Leader>m :Maps<Cr>
nnoremap <Leader>T :BTags<Cr>
nnoremap <Leader>l :Lines<Cr>
nnoremap <Leader>? :Helptags<Cr>
nnoremap <Leader>mm :Maps<CR>mappings.vim

"=============================================================================="
"                                   Ultisnip                                   "
"=============================================================================="

"let g:UltiSnipsExpandTrigger = "<nop>" "setting this NONE since it ignore COC
let g:UltiSnipsExpandTrigger="<M-e>"
"let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<C-j>"
let g:UltiSnipsJumpBackwardTrigger="<C-k>"

"=============================================================================="
"                                  Easymotion                                  "
"=============================================================================="

"I want short cut to j/k since likely to be used often, so no need \\j etc
map <Leader>j <Plug>(easymotion-j)
map <Leader>k <Plug>(easymotion-k)

nmap s <Plug>(easymotion-s2)


"=============================================================================="
"                                   Vimwiki                                    "
"=============================================================================="

au filetype vimwiki silent! iunmap <buffer> <Tab>
