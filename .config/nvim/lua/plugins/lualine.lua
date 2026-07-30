local rec_msg = ''
vim.api.nvim_create_autocmd({ 'RecordingEnter', 'RecordingLeave' }, {
    group = vim.api.nvim_create_augroup('LualineRecordingSection', { clear = true }),
    callback = function(e)
        if e.event == 'RecordingLeave' then
            rec_msg = ''
        else
            rec_msg = 'RECORDING @' .. vim.fn.reg_recording()
        end
    end,
})

return {
    'nvim-lualine/lualine.nvim',
    event = 'VeryLazy',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    opts = {
        options = {
            icons_enabled = true,
            theme = 'auto',
            component_separators = { left = '', right = '' },
            section_separators = { left = '', right = '' },
            disabled_filetypes = {}
        },
        sections = {
            lualine_a = { { 'mode', icon = '☯', } },
            lualine_b = { 'branch', 'diff', 'diagnostics' },
            lualine_c = { 'filename' },
            lualine_x = { {
                function() return rec_msg end,
                color = { fg = "#ff9e64" }
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
