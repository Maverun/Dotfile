vim.g.mapleader=' ' -- setting space as a leader
local n = 'n'
local i = 'i'
local v = 'v'
local t = 't'
local o = 'o'

local function map(mode, lhs, rhs, opts)
    -- if there is more than one mode, this allow to do them all, making editing easier
    if type(mode) == 'table' then for i,v in ipairs(mode) do map(v,lhs,rhs,options) end return end
    local options = {noremap = true}
    if opts then options = vim.tbl_extend('force', options, opts) end
    vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

local termcodes = function(str)
    return vim.api.nvim_replace_termcodes(str, true, true, true)
end

-- ┌───────────────────────────────────────────────────────────────────────────┐
-- │                                Essentials                                 │
-- └───────────────────────────────────────────────────────────────────────────┘

map(n,'<leader>/',':%s/<c-r><c-w>')

map(n,"<M-s>",":source %<cr>") -- source either vim/lua for future
map({n,v},';',':') -- save time pressing shift or rely on autoshift

map(n,'<leader>gq',':q<cr>') -- quit

map(n,'\\k','d$o<esc>p0')
map(n,'\\j','J')
map(n,'<S-k>','k')
map(n,'<S-j>','j')

map(i,'<C-s>',[[<esc>:lua require'utils'.show_func_help()<cr>]])

-- map(n,'<S-q>','@@') --screwed ex mode

-- Save
map({n,i},"<C-s>","<cmd>update<CR>")

-- Easy Caps
map(i,'<M-u>','<Esc>viwUi')
map(n,'<M-u>','viwU')

map(n,'\\q',':bp<bar>sp<bar>bn<bar>bd<CR>')
-- Close buffer without closing window
-- If i understood this.. it mean, go to
-- previous buffer | split new one | buffer next | buffer delete it
-- TLDR
-- :bp | :sp | :bn | :bd
-- where | mean then do this (like a pipe)

-- Map Ctrl-Backspace to delete previous word in insert mode
-- Cuz as I am using new keyboard where double press backspace give C-Backspace
-- So i can use it for general stuff other tha vim
map(i,'<C-BS>','<C-W>')
map(i,'<C-F>','<Esc>dea')

map(i,'<S-CR>','<Esc>o')
map(i,'<M-CR>','<Esc>O<Esc>0i')

--shift Line up or down
--shifting left and right (onlys params) are done in treesitter configs with left and right arrow key

map(v,'<Up>',':m-2<CR>gv')
map(v,'<Down>',":m '>+1<CR>gv")
--map(v,'<S-Up>',':m-2<CR>gv')
--map(v,'<S-Down>',":m '>+1<CR>gv")
--map(v,'<S-k>',':m-2<CR>gv')
--map(v,'<S-j>',":m '>+1<CR>gv")

map(n,'<Up>','<Esc>:m-2<CR>')
map(n,'<Down>',"<Esc>:m+1<CR>")
--map(n,'<S-Up>','<Esc>:m-2<CR>')
--map(n,'<S-Down>',"<Esc>:m+1<CR>")
--map(n,'<S-k>','<Esc>:m-2<CR>')
--map(n,'<S-j>',"<Esc>:m+1<CR>")

map(i,'<S-Up>','<Esc>:m-2<CR>')
map(i,'<S-Down>',"<Esc>:m+1<CR>")


--Dupe the line during insert mode, same with visual mode
--This is sent to register d, so we dont lose initial just in case
map(i,'<M-d>','<Esc>"dyy"dpi')
map(v,'<M-d>','"dygvo<esc>"dp')
map(n,'<M-d>','"dyy"dp')

--Send them to VOID register
map(v,'dv','"_d')
map(n,'dv','"_d')

--
map(n,'<leader><space>',':nohlsearch<CR>')

map(n,'<C-t>',':SymbolsOutline<CR>')
map(n,'<F2>',':NvimTreeToggle<CR>')

--Startify Plugins Hotkeys

map(n,'<M-m>',':Startify<CR>')

-- Mouse Middle Click Disable
map({v,n,i},'<MiddleMouse>','<LeftMouse>')
map({v,n,i},'<2-MiddleMouse>','<LeftMouse>')
map({v,n,i},'<3-MiddleMouse>','<LeftMouse>')
map({v,n,i},'<4-MiddleMouse>','<LeftMouse>')

--CheatSheet
map(n,'<leader>?',":Cheatsheet<CR>")

--ISwap params
map(n,'\\s',':ISwap<CR>')

--Images Paste (Useful for notes/markdown)
map(n,'<F1>',':PasteImg')

function escape()
    -- this is since we got telescope prompt that will set buftype that which we are unable to save
    if vim.bo.buftype == 'prompt' then
        return termcodes'<esc>'
    end
    return termcodes':update<CR>'
end
map(i,'<esc>','<esc>:lua escape()<cr>', {silent=true})
map('t','<esc>','<C-\\><C-n>') -- escape terminal trap!

-- adding where it doesnt swap with old into reg, we will just use same one. so it make sense that way
map(v,'p','"_dP')
-- map(v,'P','"_dP')

function ruler_toggle()
    vim.opt.ruler = not vim.opt.ruler._value
    vim.opt.relativenumber = not vim.opt.relativenumber._value
end

function cursor_toggle()
    vim.g.cursor_toggle_mave = not vim.g.cursor_toggle_mave
    vim.opt.cursorcolumn = vim.g.cursor_toggle_mave
    vim.opt.cursorline = vim.g.cursor_toggle_mave
    if vim.g.cursor_toggle_mave  then
        vim.opt.colorcolumn = '80'
    else
        vim.opt.colorcolumn = ''
    end
end
map(n,'<F5>',':lua ruler_toggle()<CR>')
map(n,'<F6>',':lua cursor_toggle()<CR>')

map(n,'<Esc><Esc>',':call firenvim#focus_page()<CR>')

-- ┌───────────────────────────────────────────────────────────────────────────┐
-- │                                Navigation                                 │
-- └───────────────────────────────────────────────────────────────────────────┘

-- unmap lightspeed fFtT, its annoying, only good is s only
-- map(n,'f','f')
-- map(n,'F','F')
-- map(n,'t','t')
-- map(n,'T','T')
-- hop.nvim, replaced with lightspeed to see how it goes.
map({n,v,o},'s','<cmd>HopWordAC<CR>')
map({n,v,o},'S','<cmd>HopWordBC<CR>')

--we are marking where we are before we begin search so that way we can return to original spot
map(n,"/","ms/")
map(n,"?","ms?")

-- instead of moving cursor to top and bottom, we can move left and right fast instead reaching manual way
-- this also mean I dont have to do I<esc> or A<esc>
map({n,v,o},'<S-h>','^')
map({n,v,o},'<S-l>','$')

-- center the screen... since we are moving, we can expect it will be at center so it is easier to know where.
map({n,v},'{','{zz')
map({n,v},'}','}zz')
map({n,v},'n','nzz')
map({n,v},'N','Nzz')
map({n,v},'[s','[snzz')
map({n,v},']s',']szz')
map({n,v},'N','Nzz')
map({n,v},'N','Nzz')

--┌────────────────────────────────────────────────────────────────────────────┐
--│                                   Window                                   │
--└────────────────────────────────────────────────────────────────────────────┘--map(n,'<S-k>',':lua function_K()<CR>')


--Using alt + hjkl for resize windows
map(n,'<M-h>',":lua require'utils'.resize(true,-2)<CR>", {silent = true})
map(n,'<M-j>',":lua require'utils'.resize(false,2)<CR>", {silent = true})
map(n,'<M-k>',":lua require'utils'.resize(false,-2)<CR>", {silent = true})
map(n,'<M-l>',":lua require'utils'.resize(true,2)<CR>", {silent = true})

-- better window navigation
map({t,n},'<C-h>','<C-w>h')
map({t,n},'<C-j>','<C-w>j')
map({t,n},'<C-k>','<C-w>k')
map({t,n},'<C-l>','<C-w>l')

--Buffer next page or previously
-- gbn is nice optional, F12,F11 is just in case

map(n,"gbn",":bn<CR>")
map(n,"gbp",":bp<CR>")

-- ┌───────────────────────────────────────────────────────────────────────────┐
-- │                               Tab Functions                               │
-- └───────────────────────────────────────────────────────────────────────────┘

-- for command mode
map(n,'<S-Tab>','<<')
--better tabbing in visual
map(v,'<','<gv')
map(v,'>','>gv')
map(v,'<Tab>','>gv')
map(v,'<S-Tab>','<gv')

-- ┌───────────────────────────────────────────────────────────────────────────┐
-- │                                 Telescope                                 │
-- └───────────────────────────────────────────────────────────────────────────┘

map(n,'<leader>ff',':Telescope find_files<cr>')
map(n,'<leader>fo',':Telescope oldfiles<cr>')
map(n,'<leader>fg',':Telescope live_grep<cr>')
map(n,'<leader>fb',':Telescope buffers<cr>')
map(n,'<leader>fh',':Telescope help_tags<cr>')
map(n,'<leader>fk',':Telescope keymaps<cr>')
map(n,'<leader>fm',':Telescope marks<cr>')
map(n,'<leader>fr','<Cmd>lua require("telescope").extensions.frecency.frecency()<CR>')

-- ┌───────────────────────────────────────────────────────────────────────────┐
-- │                                    FZF                                    │
-- └───────────────────────────────────────────────────────────────────────────┘

--map(n, "<C-p>",":Files<Cr>")
--map(n, "<Leader>b", ':Buffers<Cr>')
--map(n, "<Leader>c", ':Commands<Cr>')
--map(n, "<Leader>m", ':Maps<Cr>')
--map(n, "<Leader>T", ':BTags<Cr>')
--map(n, "<Leader>l", ':Lines<Cr>')
----map(n, "<Leader>?", ':Helptags<Cr>')
--map(n, "<Leader>mm",':Maps<CR>mappings.vim')


-- ┌───────────────────────────────────────────────────────────────────────────┐
-- │                               Trouble LSPS                                │
-- └───────────────────────────────────────────────────────────────────────────┘

--map(n, "<leader>xx", "<cmd>LspTroubleToggle<cr>")
--map(n, "<leader>xw", "<cmd>LspTroubleToggle lsp_workspace_diagnostics<cr>")
--map(n, "<leader>xd", "<cmd>LspTroubleToggle lsp_document_diagnostics<cr>")
--map(n, "<leader>xl", "<cmd>LspTroubleToggle loclist<cr>")
--map(n, "<leader>xq", "<cmd>LspTroubleToggle quickfix<cr>")
--map(n, "gR", "<cmd>LspTrouble lsp_references<cr>")

-- ┌───────────────────────────────────────────────────────────────────────────┐
-- │                               FloatTerminal                               │
-- └───────────────────────────────────────────────────────────────────────────┘

map(n, '<leader>tt',':lua require("FTerm").toggle()<cr>')
map('t', '<leader>tt','<C-\\><C-n>:lua require("FTerm").toggle()<cr>')
map(n, '<leader>tp',':lua require("FTerm").run("python ' .. vim.fn.expand("%:t")..'")<CR>')
map(n, '<leader>tj',':lua require("FTerm").run("javac ' .. vim.fn.expand("%:t")..' && java '.. vim.fn.expand("%:t:r") ..'")<CR>')


-- ┌───────────────────────────────────────────────────────────────────────────┐
-- │                                 Highlight                                 │
-- └───────────────────────────────────────────────────────────────────────────┘


map(v,'<leader>h',':<c-u>HSHighlight 9<CR> ')
map(v,'<leader>r',':<c-u>HSRmHighlight<CR>')

-- map({i,v,'s'},'<C-E>',[[luasnip#choice_active()?'<Plug>luasnip-next-choice':'<C-E>']],{silent = true, expr = true,noremap = false})
-- map({i,v,'s'},'<C-E>','<Plug>luasnip-next-choice',{noremap = false})
vim.api.nvim_set_keymap("i", "<C-E>", "<Plug>luasnip-next-choice", {})
vim.api.nvim_set_keymap("s", "<C-E>", "<Plug>luasnip-next-choice", {})

-- ┌───────────────────────────────────────────────────────────────────────────┐
-- │                                    Dap                                    │
-- └───────────────────────────────────────────────────────────────────────────┘

map(n,'\\dc',':lua require"dap".continue()<CR>')
map(n,'\\do',':lua require"dap".step_over()<CR>')
map(n,'\\dj',':lua require"dap".step_into()<CR>')
map(n,'\\dl',':lua require"dap".step_out()<CR>')
map(n,'\\db',':lua require"dap".toggle_breakpoint()<CR>')
map(n,'\\dsc',':lua require"dap".set_breakpoint(vim.fn.input("Breakpoint Condition: "))<CR>')
map(n,'\\dsl',':lua require"dap".set_breakpoint(nil,nil,vim.fn.input("Log point Message: "))<CR>')
map(n,'\\dr',':lua require"dap".repl.open()<CR>')
map(n,'\\de',':lua require"dap".run_last()<CR>')


-- ┌───────────────────────────────────────────────────────────────────────────┐
-- │                                Vimspector                                 │
-- └───────────────────────────────────────────────────────────────────────────┘

--map(n,'<leader>vc','<Plug> VimspectorContinue')
--map(n,'<leader>vs','<Plug> VimspectorStop')
--map(n,'<leader>vr','<Plug> VimspectorRestart')
--map(n,'<leader>vp','<Plug> VimspectorPause')
--map(n,'<leader>vb','<Plug> VimspectorToggleBreakpoint')
--map(n,'<leader>vh','<Plug> VimspectorToggleConditionalBreakpoint')
--map(n,'<leader>vt','<Plug> VimspectorRunToCursor')
--map(n,'<leader>vo','<Plug> VimspectorStepOver')
--map(n,'<leader>vj','<Plug> VimspectorStepInto')
--map(n,'<leader>vl','<Plug> VimspectorStepOut')
--map(n,'<leader>vfu','<Plug> VimspectorUpFrame')
--map(n,'<leader>vfd','<Plug> VimspectorDownFrame')
--map(n,'<leader>ve','<Plug> VimspectorBalloonEval')





