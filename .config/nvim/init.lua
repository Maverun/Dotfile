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
--
vim.api.nvim_create_augroup("LazyDoneTask",{clear = true})
vim.api.nvim_create_autocmd('User',{
    group = 'LazyDoneTask',
    pattern = "LazyDone",
    callback = function(ev)
	-- vim.cmd([[colorscheme tokyonight-night]])
	-- First get currently kitty theme then we can set it
	local home_path = os.getenv("HOME")
	for line in io.lines(home_path .. "/.config/kitty/current-theme.conf") do
	  if string.match(line, "## name:") then
	    get_theme_name = string.lower(string.sub(line,10))
	    break
	  end
	end
	if string.match(get_theme_name, "tokyo night") then
	  get_theme_name = 'tokyonight-night'
	end
	vim.cmd([[colorscheme ]] ..  get_theme_name)
	_G.lualine_theme(get_theme_name)
	_G.markview_theme()
    end,
})

require('settings')
require("lazy").setup("plugins")
require('mappings')
require('autocmd')

