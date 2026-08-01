-- ┌───────────────────────────────────────────────────────────────────────────┐
-- │                                   Init                                    │
-- └───────────────────────────────────────────────────────────────────────────┘

print("Hello world")

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Bootstrap and setup Lazy
require("config.lazy")

-- Setup autocmd for theme after Lazy is done
vim.api.nvim_create_augroup("LazyDoneTask", { clear = true })
vim.api.nvim_create_autocmd('User', {
    group = 'LazyDoneTask',
    pattern = "LazyDone",
    callback = function(ev)
        local home_path = os.getenv("HOME")
        local get_theme_name
        for line in io.lines(home_path .. "/.config/kitty/current-theme.conf") do
            if string.match(line, "## name:") then
                get_theme_name = string.lower(string.sub(line, 10))
                break
            end
        end
        vim.cmd([[colorscheme ]] .. get_theme_name)
        if _G.markview_theme then
            _G.markview_theme()
        end
    end,
})

-- Load config modules AFTER Lazy setup completes
require('settings')
require('lsp')
require('mappings')
require('autocmd')

-- Custom filetypes
vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
    pattern = { "Bogiefile", "Gearsfile" },
    callback = function()
        vim.opt.filetype = "yaml"
    end,
})

