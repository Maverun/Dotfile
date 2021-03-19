"=============================================================================="
"                                    VIMWIKI                                   "
"=============================================================================="


let g:vimwiki_list = [
              \{'path': '/ext_drive/SynologyDrive/vimwiki','syntax':'markdown','ext':'.md'},
              \{'path': '/ext_drive/SynologyDrive/vimwiki/Dev','syntax':'markdown','ext':'.md'},
              \{'path': '/ext_drive/SynologyDrive/vimwiki/Personal','syntax':'markdown','ext':'.md'},
                \]

let g:vim_ext2syntax = {'.md': 'markdown', '.markdown':'markdown','.mdown':'markdown'}

"Make vimwiki markdown links as [text](text.md) instead of [text](text)
let g:vimwiki_markdown_link_ext = 1

let g:taskwiki_markup_syntax = "markdown"
let g:markdown_folding = 1
let g:vim_markdown_conceal = 0
let g:vim_markdown_conceal_code_blocks = 0

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
:autocmd FileType vimwiki :RainbowToggleOff 
