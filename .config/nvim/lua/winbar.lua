--This belong to asidlo, github user. I like how it is look and structure of code so I use it.
local M = {}

M.separator = ''

M.disabled_filetypes = {
    'alpha', 'NvimTree', 'packer', 'toggleterm', 'help',
    'Trouble', 'Outline', 'TelescopePrompt', '', 'git', 'gitmessengerpopup', 'notify'
}

M.setup = function()
    local colors_ok, colors = pcall(require, 'tokyonight.colors')
    if not colors_ok then
        vim.notify(string.format('winbar.setup() -> Missing tokyonight.colors', vim.log.levels.WARN))
    else
        M.colors = colors.setup()
        vim.api.nvim_set_hl(0, 'WinBar', { bg = M.colors.bg, fg = M.colors.comment })
    end

    local navic_ok, navic = pcall(require, 'nvim-navic')
    if not navic_ok then
        vim.notify(string.format('winbar.setup() -> Missing nvim-navic', vim.log.levels.WARN))
        return
    end

    M.navic = navic

    M.navic.setup({
        separator = ' ' .. M.separator .. ' ',

        icons = {
            File          = "%#CmpItemKindFile#" .. " " .. "%*",
            Module        = "%#CmpItemKindModule#" .. " " .. "%*",
            Namespace     = "%#CmpItemKindNamespace#" .. " " .. "%*",
            Package       = "%#CmpItemKindPackage#" .. " " .. "%*",
            Class         = "%#CmpItemKindClass#" .. " " .. "%*",
            Method        = "%#CmpItemKindMethod#" .. " " .. "%*",
            Property      = "%#CmpItemKindProperty#" .. " " .. "%*",
            Field         = "%#CmpItemKindField#" .. " " .. "%*",
            Constructor   = "%#CmpItemKindConstructor#" .. " " .. "%*",
            Enum          = "%#CmpItemKindEnum#" .. "練" .. "%*",
            Interface     = "%#CmpItemKindInterface#" .. "練" .. "%*",
            Function      = "%#CmpItemKindFunction#" .. " " .. "%*",
            Variable      = "%#CmpItemKindVariable#" .. " " .. "%*",
            Constant      = "%#CmpItemKindConstant#" .. " " .. "%*",
            String        = "%#CmpItemKindString#" .. " " .. "%*",
            Number        = "%#CmpItemKindNumber#" .. " " .. "%*",
            Boolean       = "%#CmpItemKindBoolean#" .. "◩ " .. "%*",
            Array         = "%#CmpItemKindArray#" .. " " .. "%*",
            Object        = "%#CmpItemKindObject#" .. " " .. "%*",
            Key           = "%#CmpItemKindKey#" .. " " .. "%*",
            Null          = "%#CmpItemKindNull#" .. "ﳠ " .. "%*",
            EnumMember    = "%#CmpItemKindEnumMember#" .. " " .. "%*",
            Struct        = "%#CmpItemKindStruct#" .. " " .. "%*",
            Event         = "%#CmpItemKindEvent#" .. " " .. "%*",
            Operator      = "%#CmpItemKindOperator#" .. " " .. "%*",
            TypeParameter = "%#CmpItemKindTypeParameter#" ..  " " .. "%*",
        },
    })
end

-- See :h statusline for %v values
M.eval = function()
    if vim.tbl_contains(M.disabled_filetypes, vim.bo.filetype) then
        vim.opt_local.winbar = nil
        return
    end

    vim.opt_local.winbar = "%{%v:lua.require('winbar').eval()%}"

    local file_path = vim.api.nvim_eval_statusline('%f', {}).str

    file_path = file_path:gsub('/', string.format(' %s ', M.separator))

    if not M.navic or not M.navic.is_available() then
        return string.format('     %s', file_path)
    end

    if M.navic.get_location() == "" then
        return string.format('     %s', file_path)
    end

    return string.format('     %s %s %s', file_path, M.separator, M.navic.get_location())

end

return M
