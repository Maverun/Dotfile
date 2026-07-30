-- ┌───────────────────────────────────────────────────────────────────────────┐
-- │                                   Init                                    │
-- └───────────────────────────────────────────────────────────────────────────┘

-- Install Lazy
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)-- using { } for using different branch , loading plugin with certain commands etc

vim.g.mapleader = " " -- Make sure to set `mapleader` before lazy so your mappings are correct


-- vim.g.loaded_python_provider = 0

vim.api.nvim_create_augroup("LazyDoneTask",{clear = true})
vim.api.nvim_create_autocmd('User',{
    group = 'LazyDoneTask',
    pattern = "LazyDone",
    callback = function(ev)
	local home_path = os.getenv("HOME")
	local get_theme_name
	for line in io.lines(home_path .. "/.config/kitty/current-theme.conf") do
	  if string.match(line, "## name:") then
	    get_theme_name = string.lower(string.sub(line,10))
	    break
	  end
	end
	vim.cmd([[colorscheme ]] .. get_theme_name)
	_G.markview_theme()
    end,
})

require('settings')
require("lazy").setup("plugins")
require('lsp')
require('mappings')
require('autocmd')


vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
    pattern = { "Bogiefile", "Gearsfile" },
    callback = function()
        vim.opt.filetype = "yaml"
    end,
})
