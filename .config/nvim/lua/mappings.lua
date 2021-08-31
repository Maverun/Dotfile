vim.g.mapleader=' ' -- setting space as a leader
local n = 'n'
local i = 'i'
local v = 'v'

local function map(mode, lhs, rhs, opts)
  local options = {noremap = true}
  if opts then options = vim.tbl_extend('force', options, opts) end
  vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

local t = function(str)
    return vim.api.nvim_replace_termcodes(str, true, true, true)
end

function resize(vertical, margin)
  local cur_win = vim.api.nvim_get_current_win()
  -- go (possibly) right
  vim.cmd(string.format('wincmd %s', vertical and 'l' or 'j'))
  local new_win = vim.api.nvim_get_current_win()

  -- determine direction cond on increase and existing right-hand buffer
  local not_last = not (cur_win == new_win)
  local sign = margin > 0
  -- go to previous window if required otherwise flip sign
  if not_last == true then
    vim.cmd [[wincmd p]]
  else
    sign = not sign
  end

  sign = sign and '+' or '-'
  local dir = vertical and 'vertical ' or ''
  local cmd = dir .. 'resize ' .. sign .. math.abs(margin) .. '<CR>'
  vim.cmd(cmd)
end

-- ┌───────────────────────────────────────────────────────────────────────────┐
-- │                                Essentials                                 │
-- └───────────────────────────────────────────────────────────────────────────┘

map(n,"<M-s>",":source %<cr>") -- source either vim/lua for future
map(n,';',':') -- save time pressing shift or rely on autoshift


-- unmap lightspeed fFtT, its annoying, only good is s only
map(n,'f','f')
map(n,'F','F')
map(n,'t','t')
map(n,'T','T')

map(n,'<S-q>','@@') --screwed ex mode

-- Save
map(n,"<C-s>",":w<CR>")
map(i,"<C-s>","<ESC>:w<CR>")

-- Easy Caps
map(i,'<M-u>','<Esc>viwUi')
map(n,'<M-u>','viwU')

map(n,'<leader>q',':bp<bar>sp<bar>bn<bar>bd<CR>')
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

--Shfift Line up or down

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
map(v,'<leader>d','"_d')
map(n,'<leader>d','"_d')

--
map(n,'<leader><space>',':nohlsearch<CR>')

map(n,'<C-t>',':TagbarToggle<CR>')
map(n,'<F2>',':NvimTreeToggle<CR>')

--Startify Plugins Hotkeys

map(n,'<M-m>',':Startify<CR>')

-- Mouse Middle Click Disable
map(n,'<MiddleMouse>','<LeftMouse>')
map(n,'<2-MiddleMouse>','<LeftMouse>')
map(n,'<3-MiddleMouse>','<LeftMouse>')
map(n,'<4-MiddleMouse>','<LeftMouse>')

map(i,'<MiddleMouse>','<LeftMouse>')
map(i,'<2-MiddleMouse>','<LeftMouse>')
map(i,'<3-MiddleMouse>','<LeftMouse>')
map(i,'<4-MiddleMouse>','<LeftMouse>')

--CheatSheet
map(n,'<leader>?',":Cheatsheet<CR>")

--ISwap params
map(n,'\\s',':ISwap<CR>')

--Images Paste (Useful for notes/markdown)
map(n,'<F1>',':PasteImg')

function escape()
    --this is since we got telescope prompt that will set buftype that which we are unable to save
    if vim.bo.buftype == 'prompt' then
        print("escaping")
        return t'<esc>'
    end
    return t'<esc>:update'
end
map(i,'<esc>','<esc>:lua escape()<cr>', {silent=true})

-- adding where it doesnt swap with old into reg, we will just use same one. so it make sense that way
map(v,'p','"_dp')
map(v,'P','"_dP')

-- ┌───────────────────────────────────────────────────────────────────────────┐
-- │                                Navigation                                 │
-- └───────────────────────────────────────────────────────────────────────────┘

map(n,'\\k','d$o<esc>p0')
map(n,'\\j','J')
map(n,'<S-k>','k')
map(n,'<S-j>','j')

--we are marking where we are before we begin search so that way we can return to orignal spot
map(n,"/","ms/")
map(n,"?","ms?")

-- instead of moving cursor to top and bottom, we can move left and right fast instead reaching manual way
-- this also mean I dont have to do I<esc> or A<esc>
map(n,'<S-h>','^')
map(n,'<S-l>','$')
map(v,'<S-h>','^')
map(v,'<S-l>','$')

--┌────────────────────────────────────────────────────────────────────────────┐
--│                                   Window                                   │
--└────────────────────────────────────────────────────────────────────────────┘--map(n,'<S-k>',':lua function_K()<CR>')


--Using alt + hjkl for resize windows
map(n,'<M-h>',":lua resize(true,-2)<CR>", {silent = true})
map(n,'<M-j>',":lua resize(false,2)<CR>", {silent = true})
map(n,'<M-k>',":lua resize(false,-2)<CR>", {silent = true})
map(n,'<M-l>',":lua resize(true,2)<CR>", {silent = true})

-- better window navigation
map(n,'<C-h>','<C-w>h')
map(n,'<C-j>','<C-w>j')
map(n,'<C-k>','<C-w>k')
map(n,'<C-l>','<C-w>l')

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
map(n,'<leader>fg',':Telescope live_grep<cr>')
map(n,'<leader>fb',':Telescope buffers<cr>')
map(n,'<leader>fh',':Telescope help_tags<cr>')
map(n,'<leader>fm',':Telescope keymaps<cr>')
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
-- │                                  LSPSAGA                                  │
-- └───────────────────────────────────────────────────────────────────────────┘

--Hover docs
--map(n,'<Space>k',':Lspsaga hover_doc<CR>')
--scroll up and down
--map(n,'<C-n>',':lua require("lspsaga.action").smart_scroll_with_saga(1)<CR>')
--map(n,'<C-p>',':lua require("lspsaga.action").smart_scroll_with_saga(-1)<CR>')
--Check signature of functions - we will use default lsp
--map(n,'<Space>s',':Lspsaga signature_help<CR>')
-- Rename whole file related to this
--map(n,'<Space>r',':Lspsaga rename<CR>')
-- preview definitons
--map(n,'<Space>d',':Lspsaga preview_definition<CR>')

-- ┌───────────────────────────────────────────────────────────────────────────┐
-- │                               FloatTerminal                               │
-- └───────────────────────────────────────────────────────────────────────────┘

map(n, '<leader>tt',':lua require("FTerm").toggle()<cr>')
map('t', '<leader>tt','<C-\\><C-n>:lua require("FTerm").toggle()<cr>')


-- ┌───────────────────────────────────────────────────────────────────────────┐
-- │                                 Highlight                                 │
-- └───────────────────────────────────────────────────────────────────────────┘


map(v,'<leader>h',':<c-u>HSHighlight 9<CR> ')
map(v,'<leader>r',':<c-u>HSRmHighlight<CR>')

function luasnip_choice()
    local snip = require('luasnip')
    if snip.choice_active() then
        print("yes")
        return t '<Plug>luasnip-next-choice'
    end
    return t "<C-E>"
end

vim.cmd[[imap <silent><expr> <C-E> luasnip#choice_active() ? '<Plug>luasnip-next-choice' : '<C-E>']]
vim.cmd[[vmap <silent><expr> <C-E> luasnip#choice_active() ? '<Plug>luasnip-next-choice' : '<C-E>']]
vim.cmd[[smap <silent><expr> <C-E> luasnip#choice_active() ? '<Plug>luasnip-next-choice' : '<C-E>']]
--map(i,'<C-E>',"<esc>:lua luasnip_choice()<cr>",{silent=true})


-- ┌───────────────────────────────────────────────────────────────────────────┐
-- │                                    Dap                                    │
-- └───────────────────────────────────────────────────────────────────────────┘

map(n,'\\dc',':lua require"dap".continue()<CR>')
map(n,'\\do',':lua require"dap".step_over()<CR>')
map(n,'\\dj',':lua require"dap".step_into()<CR>')
map(n,'\\dl',':lua require"dap".step_out()<CR>')
map(n,'\\db',':lua require"dap".toggle_breakpoint()<CR>')
map(n,'\\ds',':lua require"dap".set_breakpoint(vim.fn.input("Breakpoint Condition: "))<CR>')
map(n,'\\dsl',':lua require"dap".set_breakpoint(nil,nil,vim.fn.input("Log point Message: "))<CR>')
map(n,'\\dr',':lua require"dap".repl.open()<CR>')
map(n,'\\drl',':lua require"dap".run_last()<CR>')


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













