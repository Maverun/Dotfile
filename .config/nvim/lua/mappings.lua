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

function smart_dd()
    -- checking if it just white space, if yes, then do void delete.
    if vim.api.nvim_get_current_line():match("^%s*$") then
        return "\"_dd"
    else
        return "dd"
    end
end

-- ┌───────────────────────────────────────────────────────────────────────────┐
-- │                                Essentials                                 │
-- └───────────────────────────────────────────────────────────────────────────┘
map(n,'<leader>/',':%s/<c-r><c-w>',{desc = "Search/Sub current word"})
vim.keymap.set({n,v},'dd',smart_dd,{expr=true})
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

map(n,'<Up>','<Esc>:m-2<CR>')
map(n,'<Down>',"<Esc>:m+1<CR>")

map(i,'<S-Up>','<Esc>:m-2<CR>')
map(i,'<S-Down>',"<Esc>:m+1<CR>")


--Dupe the line during insert mode, same with visual mode
--This is sent to register d, so we dont lose initial just in case
map(i,'<M-d>','<Esc>"dyy"dpi')
map(v,'<M-d>','"dygvo<esc>"dp')
map(n,'<M-d>','"dyy"dp')

--Send them to VOID register
map({v,n},'dv','"_d',{desc = "VOID Delete"})

--
map(n,'<leader><space>',':nohlsearch<CR>', {desc = 'Remove Highlight'})

-- Mouse Middle Click Disable
map({v,n,i},'<MiddleMouse>','<LeftMouse>')
map({v,n,i},'<2-MiddleMouse>','<LeftMouse>')
map({v,n,i},'<3-MiddleMouse>','<LeftMouse>')
map({v,n,i},'<4-MiddleMouse>','<LeftMouse>')

map('t','<esc>','<C-\\><C-n>') -- escape terminal trap!

-- adding where it doesnt swap with old into reg, we will just use same one. so it make sense that way
map(v,'p','"_dP')
-- map(v,'P','"_dP')

function ruler_toggle()
    vim.g.ruler_toggle_mave = not vim.g.ruler_toggle_mave
    vim.opt.number = vim.g.ruler_toggle_mave
    -- vim.opt.relativenumber = not vim.opt.relativenumber._value
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

-- ┌───────────────────────────────────────────────────────────────────────────┐
-- │                                Navigation                                 │
-- └───────────────────────────────────────────────────────────────────────────┘

-- hop.nvim
-- map({n,v,o},'S',':lua require"hop".hint_words({current_line_only = true,})<CR>',{desc="HOP within current line!",silent = true})
-- map({n,v,o},'s','<cmd>HopWord<CR>',{desc="HOP!"})

--we are marking where we are before we begin search so that way we can return to original spot via <C-o> jump
map(n,"/","ms/")
map(n,"?","ms?")

-- instead of moving cursor to top and bottom, we can move left and right fast instead reaching manual way
-- I dont really use default mapping of H/L so this is good opportunity to replaces it
-- this also mean I don't have to do I<esc> or A<esc>
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
--└────────────────────────────────────────────────────────────────────────────┘
--map(n,'<S-k>',':lua function_K()<CR>')


--Using alt + hjkl for resize windows
map(n,'<M-h>',":lua require'utils'.resize(true,-2)<CR>", {silent = true})
map(n,'<M-j>',":lua require'utils'.resize(false,2)<CR>", {silent = true})
map(n,'<M-k>',":lua require'utils'.resize(false,-2)<CR>", {silent = true})
map(n,'<M-l>',":lua require'utils'.resize(true,2)<CR>", {silent = true})

--Buffer next page or previously
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
