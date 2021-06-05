
local fn = vim.fn
local o = vim.o
local cmd = vim.cmd

local function highlight(group, fg, bg)
    cmd("highlight " .. group .. " guifg=" .. fg .. " guibg=" .. bg)
end


vim.g.tokyodark_transparent_background = false
vim.g.tokyodark_enable_italic_comment = true
vim.g.tokyodark_enable_italic = true
vim.g.tokyodark_color_gamma = "1.1"


cmd("colorscheme tokyodark")
--cmd 'hi Visual ctermfg=120'
cmd 'hi Visual cterm=reverse ctermbg=NONE'
--cmd("highlight! StatusLineNC cterm=underline term=underline gui=underline guifg=#383c44")
--cmd 'set fillchars+=vert:▏'
--cmd('set listchars=tab:>\\ ,trail:-')
--highlight('Visual','#FFFFFF','#FFFFFF')

--highlight('VisualNOS','#FFFFFF','#FFFFFF')
highlight('TSComment','#0087ff','None')

cmd 'hi WindowLine guifg=#4C4D5A guibg=#151623'
cmd' set winhighlight=VertSplit:WindowLine'
