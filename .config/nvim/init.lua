-- ┌───────────────────────────────────────────────────────────────────────────┐
-- │                                   Init                                    │
-- └───────────────────────────────────────────────────────────────────────────┘

-- Install Lazy
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath) -- using { } for using different branch , loading plugin with certain commands etc

vim.g.mapleader = " "         -- Make sure to set `mapleader` before lazy so your mappings are correct


-- vim.g.loaded_python_provider = 0

require('settings')
require("lazy").setup("plugins")
require('mappings')
require('autocmd')

