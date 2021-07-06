local n = 'n'
local i = 'i'
local v = 'v'

local function map(mode, lhs, rhs, opts)
  local options = {noremap = true}
  if opts then options = vim.tbl_extend('force', options, opts) end
  vim.api.nvim_set_keymap(mode, lhs, rhs, options)
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
-- │                                Navigation                                 │
-- └───────────────────────────────────────────────────────────────────────────┘

--Using alt + hjkl for resize windows
map(n,'<M-h>',":lua resize(true,-2)<CR>")
map(n,'<M-j>',":lua resize(false,2)<CR>")
map(n,'<M-k>',":lua resize(false,-2)<CR>")
map(n,'<M-l>',":lua resize(true,2)<CR>")

-- better window navigation
map(n,'<C-h>','<C-w>h')
map(n,'<C-j>','<C-w>j')
map(n,'<C-k>','<C-w>k')
map(n,'<C-l>','<C-w>l')

--Buffer next page or previously
-- gbn is nice optional, F12,F11 is just in case

map(n,"<F12>",":bn<CR>")
map(n,"<F11>",":bp<CR>")
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
map(v,'<Tab>','<gv')
map(v,'<S-Tab>','>gv')

-- ┌───────────────────────────────────────────────────────────────────────────┐
-- │                                Essentials                                 │
-- └───────────────────────────────────────────────────────────────────────────┘

-- Save
map(n,"<C-s>",":w<CR>")
map(i,"<C-s>","<ESC>:w<CR>")

-- Easy Caps

map(i,'<M-u>','<Esc>viwUi')
map(n,'<M-u>','viwU')

-- Close buffer without closing window
map(n,'<leader>q',':bp<bar>sp<bar>bn<bar>bd<CR>')
-- If i understood this.. it mean, go to
-- previous buffer | split new one | buffer next | buffer delete it
-- TLDR
-- :bp | :sp | :bn | :bd
-- where | mean then do this (like a pipe)

-- Map Ctrl-Backspace to delete previous word in insert mode
-- Cuz as I am using new keyboard wher duble backspace give C-Backspace
-- So i can use it for general stuff other tha vim

map(i,'<C-BS>','<C-W>')
map(i,'<C-F>','<Esc>dea')

map(i,'<S-CR>','<Esc>o')
map(i,'<M-CR>','<Esc>O<Esc>0i')

--Shfift Line up or down

map(v,'<S-Up>',':m-2<CR>gv')
map(v,'<S-Down>',":m '>+1<CR>gv")
map(v,'<S-k>',':m-2<CR>gv')
map(v,'<S-j>',":m '>+1<CR>gv")

map(n,'<S-Up>','<Esc>:m-2<CR>')
map(n,'<S-Down>',"<Esc>:m+1<CR>")
map(n,'<S-k>','<Esc>:m-2<CR>')
map(n,'<S-j>',"<Esc>:m+1<CR>")

map(i,'<S-Up>','<Esc>:m-2<CR>')
map(i,'<S-Down>',"<Esc>:m+1<CR>")

--Dupe the line during insert mode, same with visual mode
--This is sent to register d, so we dont lose initial just in case
map(i,'<C-d>','<Esc>"dyy"dpi')
map(v,'<C-d>','"dygvo<esc>"dp')
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
vim.cmd 'autocmd User Startified nmap <buffer> <C-m> <plug>(startify-open-buffers)'

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
map(n,'<leader>s',':ISwap<CR>')

--Images Paste (Useful for notes/markdown)
map(n,'<F1>',':PasteImg')


-- ┌───────────────────────────────────────────────────────────────────────────┐
-- │                                 Telescope                                 │
-- └───────────────────────────────────────────────────────────────────────────┘

map(n,'<leader>ff',':Telescope find_files<cr>')
map(n,'<leader>fg',':Telescope live_grep<cr>')
map(n,'<leader>fb',':Telescope buffers<cr>')
map(n,'<leader>fh',':Telescope help_tags<cr>')

-- ┌───────────────────────────────────────────────────────────────────────────┐
-- │                                    FZF                                    │
-- └───────────────────────────────────────────────────────────────────────────┘

map(n, "<C-p>",":Files<Cr>")
map(n, "<Leader>b", ':Buffers<Cr>')
map(n, "<Leader>c", ':Commands<Cr>')
map(n, "<Leader>m", ':Maps<Cr>')
map(n, "<Leader>T", ':BTags<Cr>')
map(n, "<Leader>l", ':Lines<Cr>')
--map(n, "<Leader>?", ':Helptags<Cr>')
map(n, "<Leader>mm",':Maps<CR>mappings.vim')


-- ┌───────────────────────────────────────────────────────────────────────────┐
-- │                               Trouble LSPS                                │
-- └───────────────────────────────────────────────────────────────────────────┘

map(n, "<leader>xx", "<cmd>LspTroubleToggle<cr>")
map(n, "<leader>xw", "<cmd>LspTroubleToggle lsp_workspace_diagnostics<cr>")
map(n, "<leader>xd", "<cmd>LspTroubleToggle lsp_document_diagnostics<cr>")
map(n, "<leader>xl", "<cmd>LspTroubleToggle loclist<cr>")
map(n, "<leader>xq", "<cmd>LspTroubleToggle quickfix<cr>")
map(n, "gR", "<cmd>LspTrouble lsp_references<cr>")

-- ┌───────────────────────────────────────────────────────────────────────────┐
-- │                                  LSPSAGA                                  │
-- └───────────────────────────────────────────────────────────────────────────┘

--Hover docs
map(n,'<Space>k',':Lspsaga hover_doc<CR>')
--scroll up and down
map(n,'<C-n>',':lua require("lspsaga.action").smart_scroll_with_saga(1)<CR>')
map(n,'<C-p>',':lua require("lspsaga.action").smart_scroll_with_saga(-1)<CR>')
--Check signature of functions
map(n,'gs',':Lspsaga signature_help<CR>')
-- Rename whole file related to this
map(n,'gr',':Lspsaga rename<CR>')
-- preview definitons
map(n,'gd',':Lspsaga preview_definition<CR>')


-- ┌───────────────────────────────────────────────────────────────────────────┐
-- │                               FloatTerminal                               │
-- └───────────────────────────────────────────────────────────────────────────┘

map(n, '<leader>tt',':lua require("FTerm").toggle()<cr>')
map('t', '<leader>tt','<C-\\><C-n>:lua require("FTerm").toggle()<cr>')


-- ┌───────────────────────────────────────────────────────────────────────────┐
-- │                                 Highlight                                 │
-- └───────────────────────────────────────────────────────────────────────────┘

map(v,'q',':<c-u>HSHighlight 2<CR> ')
map(v,'r',':<c-u>HSRmHighlight<CR>')


-- ┌───────────────────────────────────────────────────────────────────────────┐
-- │                                 Ultisnips                                 │
-- └───────────────────────────────────────────────────────────────────────────┘

vim.g.UltiSnipsExpandTrigger = "<F12>"
vim.g.UltiSnipsJumpForwardTrigger = "<F12>"
vim.g.UltiSnipsJumpBackwardTrigger = "<F12>"




-- ┌───────────────────────────────────────────────────────────────────────────┐
-- │                                    Dap                                    │
-- └───────────────────────────────────────────────────────────────────────────┘

map(n,'<leader>dc',':lua require"dap".continue()<CR>')
map(n,'<leader>do',':lua require"dap".step_over()<CR>')
map(n,'<leader>dj',':lua require"dap".step_into()<CR>')
map(n,'<leader>dl',':lua require"dap".step_out()<CR>')
map(n,'<leader>db',':lua require"dap".toggle_breakpoint()<CR>')
map(n,'<leader>ds',':lua require"dap".set_breakpoint(vim.fn.input("Breakpoint Condition: "))<CR>')
map(n,'<leader>dsl',':lua require"dap".set_breakpoint(nil,nil,vim.fn.input("Log point Message: "))<CR>')
map(n,'<leader>dr',':lua require"dap".repl_open()<CR>')
map(n,'<leader>drl',':lua require"dap".run_last()<CR>')


-- ┌───────────────────────────────────────────────────────────────────────────┐
-- │                                Vimspector                                 │
-- └───────────────────────────────────────────────────────────────────────────┘

map(n,'<leader>vc',':call VimspectorContinue')
map(n,'<leader>vs',':call VimspectorStop')
map(n,'<leader>vr',':call VimspectorRestart')
map(n,'<leader>vp',':call VimspectorPause')
map(n,'<leader>vb',':call VimspectorToggleBreakpoint')
map(n,'<leader>vbc',':call VimspectorToggleConditionalBreakpoint')
map(n,'<leader>vt',':call VimspectorRunToCursor')
map(n,'<leader>vo',':call VimspectorStepOver')
map(n,'<leader>vj',':call VimspectorStepInto')
map(n,'<leader>vl',':call VimspectorStepOut')
map(n,'<leader>vfu',':call VimspectorUpFrame')
map(n,'<leader>vfd',':call VimspectorDownFrame')
map(n,'<leader>vb',':call VimspectorBalloonEval')













