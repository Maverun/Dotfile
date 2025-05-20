local diagnostic = {
    'diagnostics',
    -- table of diagnostic sources, available sources:
    -- nvim_lsp, coc, ale, vim_lsp
    sources = { 'nvim_diagnostic' },
    -- displays diagnostics from defined severity
    sections = { 'error', 'warn', 'info', 'hint' },
}

-- tkn = require("tokyonight")
-- local colors = require("tokyonight.colors").setup({})
-- vim.cmd("highlight lualine_a_normal guifg=#1c1d29 guibg="..colors.blue)

local rec_msg = ''
vim.api.nvim_create_autocmd({ 'RecordingEnter', 'RecordingLeave' }, {
    group = vim.api.nvim_create_augroup('LualineRecordingSection', { clear = true }),
    callback = function(e)
        print(e.event)
        if e.event == 'RecordingLeave' then
            rec_msg = ''
        else
            rec_msg = 'RECORDING @' .. vim.fn.reg_recording()
        end
    end,
})


_G.lualine_theme = function(e)
    if e == "tokyonight-night" then
        local custom_tk = require 'lualine.themes.tokyonight'
        custom_tk.normal.a.bg = "#7aa2f7"
    else
        custom_tk = "auto"
    end
    lualine = require('lualine')
    lualine.setup({options = { theme = custom_tk}})
    lualine.refresh()
end

vim.api.nvim_create_autocmd({ 'Colorscheme' }, {
    group = vim.api.nvim_create_augroup('ColorschemeChangeLuline', { clear = true }),
    callback = function(e)
        _G.lualine_theme(e.match)
    end,
})

local custom_tk = require 'lualine.themes.tokyonight'
custom_tk.normal.a.bg = "#7aa2f7"

return {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons', "folke/tokyonight.nvim" },
    priority = 0,
    opts = {
        options = {
            icons_enabled = true,
            theme = custom_tk,
            component_separators = { left = '', right = '' },
            section_separators = { left = '', right = '' },
            disabled_filetypes = {}
        },
        sections = {
            lualine_a = { { 'mode', icon = '☯', } },
            lualine_b = { 'branch', 'diff', 'diagnostics' },
            lualine_c = { 'filename' },
            lualine_x = { {
                function()
                    return rec_msg
                end,
                color = { fg = "#ff9e64" }
                -- {
                -- 	require("noice").api.statusline.mode.get,
                -- 	cond = require("noice").api.statusline.mode.has,
                -- 	color = { fg = "#ff9e64" },
                -- }
            } },
            lualine_y = { "lsp_status", 'encoding', 'fileformat', 'filetype', 'progress' },
            lualine_z = { 'selectioncount', 'location' }
        },
        inactive_sections = {
            lualine_a = {},
            lualine_b = {},
            lualine_c = { 'filename' },
            lualine_x = { 'location' },
            lualine_y = {},
            lualine_z = {}
        },
    }
}
