local fn = vim.fn
local o = vim.o
local cmd = vim.cmd

local function highlight(group, fg, bg)
    cmd("highlight " .. group .. " guifg=" .. fg .. " guibg=" .. bg)
end


cmd("colorscheme tokyonight")
--highlight('TSComment','#0087ff','None')

--cmd 'hi WindowLine guifg=#4C4D5A guibg=#151623'
--cmd' set winhighlight=VertSplit:WindowLine'


