local cmd = vim.cmd

vim.g.vimwiki_list = {
             {path = '/ext_drive/SynologyDrive/vimwiki',syntax = 'markdown',ext = '.md'},
             {path = '/ext_drive/SynologyDrive/vimwiki/Dev',syntax='markdown',ext='.md'},
             {path = '/ext_drive/SynologyDrive/vimwiki/Personal',syntax='markdown',ext='.md'},
}

vim.g.vim_ext2syntax = {[".md"] = 'markdown', [".markdown"] = 'markdown',[".mdown"] ='markdown'}

--Make vimwiki markdown links as [text](text.md) instead of [text](text)
vim.g.vimwiki_markdown_link_ext = 1

vim.g.taskwiki_markup_syntax = "markdown"
vim.g.markdown_folding = 1
--let g:vim_markdown_conceal = 0
--let g:vim_markdown_conceal_code_blocks = 0

cmd 'au BufRead,BufNewFile *.md set filetype=vimwiki'
cmd 'au BufRead,BufNewFile *.md set syntax=markdown'
cmd ':autocmd FileType vimwiki map F4 :VimwikiMakeDiaryNote'
cmd 'autocmd FileType mdvimwiki UltiSnipsAddFiletypes vimwiki'


-- Allow Ultisnips to work in Markdown Files (that Vimwiki controls)
vim.g.vimwiki_table_mappings = 0
vim.g.vimwiki_key_mappings = { table_mappings = 0, }
