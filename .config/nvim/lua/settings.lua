-- ┌───────────────────────────────────────────────────────────────────────────┐
-- │                                 Settings                                  │
-- └───────────────────────────────────────────────────────────────────────────┘

local cmd = vim.cmd  -- to execute Vim commands e.g. cmd('pwd')
local fn = vim.fn    -- to call Vim functions e.g. fn.bufnr()
local g = vim.g      -- a table to access global variables
local opt = vim.opt


opt.syntax = 'on'               -- Able syntax
opt.hidden = true             -- Enable modified buffers in background
opt.encoding = 'utf-8'        -- Encoding displayed
opt.fileencoding = 'utf-8'    -- Encoding written to files
opt.termguicolors = true      -- True color support
opt.joinspaces = false        -- No double spaces with join after a dot
opt.scrolloff = 5             -- Lines of context
opt.sidescrolloff = 8         -- Columns of context
opt.splitright = true         -- Put new windows right of current
opt.splitbelow = true         -- Put new windows below current
--opt.wildmenu = true
--opt.wildmode ='list:longest' -- Command-line completion mode
opt.list = true               -- Show some invisible characters (tabs...)
opt.number = false             -- Print line number
opt.relativenumber = false     -- Relative line numbers


opt.wrap = false              -- Disable line wrap
opt.ruler = true               -- Cursor ruler
opt.inccommand = "split"       -- Allow to see change when replace via :s/
opt.mouse = "a"                -- Allow to use mouse
opt.showmode = false           -- Dont show default -- Insert --
opt.spell = true                -- well...duh
opt.smartcase = true          -- Don't ignore case with capitals
opt.ignorecase = true         -- Ignore case

opt.backup = false             -- Disable Backup since it is bit annoying to deal when open files
opt.writebackup = false         -- similar as backup setting
opt.swapfile = false         -- similar as backup setting

opt.clipboard = 'unnamedplus'  -- allow to merge with system clipboard
opt.cmdheight = 1              -- set command height 0

opt.updatetime = 300
opt.timeoutlen = 200

cmd 'set iskeyword -=_'              -- allow to ignore _ as one word
-- opt.autochdir = true            -- Working directory will be always same
-- opt.filetype = 'plugin'
cmd 'set fillchars+=vert:▏'          -- Setting Window Vertical border to thin
cmd 'set shortmess=I'

opt.conceallevel = 2            -- allow to view markdown ease

opt.completeopt = "menuone,noselect"
opt.undofile = true

opt.listchars = {
    -- tab = '',
    tab = '  ',
    conceal = '┊',
    nbsp = 'ﮊ',
    extends = '>',
    precedes = '<',
    trail = '·',
    eol = '󰌑',
}

-- ┌───────────────────────────────────────────────────────────────────────────┐
-- │                                    Tab                                    │
-- └───────────────────────────────────────────────────────────────────────────┘

local indent = 4

opt.expandtab = true                           -- Use spaces instead of tabs
opt.shiftwidth = indent                        -- Size of an indent
opt.smartindent = true                         -- Insert indents automatically
opt.tabstop = indent                           -- Number of spaces tabs count for
opt.shiftround = true                          -- Round indent

-- ┌───────────────────────────────────────────────────────────────────────────┐
-- │                                   Fold                                    │
-- └───────────────────────────────────────────────────────────────────────────┘


MyFoldText = function()
    local line = vim.fn.getline(vim.v.foldstart)
    local foldedlinecount = vim.v.foldend - vim.v.foldstart + 1
    return '  '.. foldedlinecount .. '  ' .. line
end

vim.o.foldtext = "luaeval('MyFoldText()')"
opt.foldmethod = 'manual'
vim.o.fillchars = "fold: "
-- vim.o.foldlevelstart = 99

-- ┌───────────────────────────────────────────────────────────────────────────┐
-- │                                  Column                                   │
-- └───────────────────────────────────────────────────────────────────────────┘

-- opt.cursorline = true
-- opt.cursorcolumn = true

-- opt.colorcolumn = '80'

-- ┌───────────────────────────────────────────────────────────────────────────┐
-- │                                  VimStay                                  │
-- └───────────────────────────────────────────────────────────────────────────┘

g.viewoptions='cursor,folds,slash,unix'
cmd 'set viewoptions-=options'



--
--FZF Notation FZF for notes
g.nv_search_paths = {
    "/ext_drive/SynologyDrive/NotesTaking/Dev",
    "/ext_drive/SynologyDrive/NotesTaking/Home"
}

-- g.vim_markdown_conceal = 2

--there is plugins for this suda.nvim, but doesn't feel like a worth it  since I wont be editing in permission often.
vim.cmd[[
" Temporary workaround for: https://github.com/neovim/neovim/issues/1716
if has("nvim")
  command! W w !sudo -n tee % > /dev/null || echo "Press <leader>w to authenticate and try again"
  map <leader>w :new<cr>:term sudo true<cr>
else
  command! W w !sudo tee % > /dev/null
end
]]






-- ┌───────────────────────────────────────────────────────────────────────────┐
-- │                                  LSP	                               │
-- └───────────────────────────────────────────────────────────────────────────┘

vim.lsp.enable({
  -- lua
  "lua",
  -- python
  "python",
  "basedpyright",
  "ruff",
  -- yaml
  "yaml",
  -- bash
  "bash",
  -- Json
  'json',
  -- Markdown
  "markdown",
})

_G.inlay_hint_toggle = function()
    vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
end

vim.lsp.config( "*", {
  on_attach = function(client, buffer)
    vim.lsp.inlay_hint.enable()
    -- vim.bo[buffer].formatexpr = "v:lua.vim.lsp.formatexpr"
    if client and client:supports_method("textDocument/foldingRange") then
        local win = vim.api.nvim_get_current_win()
        vim.wo[win][0].foldmethod = "expr"
        vim.wo[win][0].foldexpr = "v:lua.vim.lsp.foldexpr()"
    end

    vim.keymap.set("n", "grq", vim.diagnostic.setloclist, {desc = "Diagnostic QuickList"})
    vim.keymap.set("n", "grD", vim.lsp.buf.declaration, {desc = "Declaration"})
    vim.keymap.set("n", "grd", vim.lsp.buf.definition, {desc = "Definition"})
    vim.keymap.set("n", "gri", _G.inlay_hint_toggle, {desc = "Inlay Hint Toggle"})
    if client:supports_method("textDocument/formatting") then
      vim.keymap.set("n",
        "grf",
        vim.lsp.buf.format,
        {
          buffer = buffer,
          desc = "Formatting whole files"
        }
      )
    end
  end,
})
-- ┌───────────────────────────────────────────────────────────────────────────┐
-- │                                Diagnostics	                               │
-- └───────────────────────────────────────────────────────────────────────────┘

vim.diagnostic.config({
  -- Use the default configuration
  -- virtual_lines = true
  virtual_text = true,

  -- Alternatively, customize specific options
  virtual_lines = false
  -- {
 -- Only show virtual line diagnostics for the current cursor line
 -- current_line = true,
  -- },
})

