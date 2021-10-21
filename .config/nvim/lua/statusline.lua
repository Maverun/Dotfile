-- ┌───────────────────────────────────────────────────────────────────────────┐
-- │                                StatusLine                                 │
-- └───────────────────────────────────────────────────────────────────────────┘

local fn = vim.fn
--local g = vim.g
local cmd = vim.cmd

--Based of https://nihilistkitten.me/nvim-lua-statusline/
--and https://github.com/nihilistkitten/dotfiles/blob/main/nvim/lua/statusline.lua

function gen_section(hl_string, items)
    out = ""
    for _, item in pairs(items) do
        if item ~= "" then
            if out == "" then
                out = " " .. item
            else
                --out = out .. " | " .. item
                out = out .. " │ " .. item
            end
        end
    end
    return hl_string .. out .. " "
end

local function highlight(group, fg, bg,extraText)
    cmd("highlight " .. group .. " guifg=" .. fg .. " guibg=" .. bg)
    cmd("highlight " .. group .."Text" .. " guifg=" .. bg)
end

local dark_text = "#24283b"

highlight("StatusNormal",   dark_text, "#4799EB")
highlight("StatusNop",      dark_text, "#ff9e64")
highlight("StatusInsert",   dark_text, "#2BBB4F")
highlight("StatusVisual",   dark_text, "#986FEC")
highlight("StatusSelect",   dark_text, "#ff9e64")
highlight("StatusReplace",  dark_text, "#ff9e64")
highlight("StatusCommand",  dark_text, "#D7A542")
highlight("StatusPrompt",   dark_text, "#ff9e64")
highlight("StatusShell",    dark_text, "#e0af68")
highlight("StatusNone",     dark_text, "#444b6a")
highlight("StatusLineDark", "#9098bd", "#232433")
highlight('DeActiveStatus',dark_text,  "#303030")

local emph_highlight = "%#StatusLine#"
local dark_highlight = "%#StatusLineDark#"

-- sensibly group the vim modes
function get_mode_group(m)
    -- to get something like  , do ctrl-v then press key
    local mode_groups = {
        n = "Normal",
        no = "Nop",
        nov = "Nop",
        noV = "Nop",
        ["noCTRL-V"] = "Nop",
        niI = "Normal",
        niR = "Normal",
        niV = "Normal",
        v = "Visual-Char",
        V = "Visual-Line",
        [""] = "Visual-Block",
        s = "Select-Char",
        S = "Select-Line",
        [""] = "Select-Block",
        i = "Insert",
        ic = "Insert",
        ix = "Insert",
        R = "Replace",
        Rc = "Replace",
        Rv = "Replace",
        Rx = "Replace",
        c = "Command",
        cv = "Command",
        ce = "Command",
        r = "Prompt",
        rm = "Prompt",
        ["r?"] = "Prompt",
        ["!"] = "Shell",
        t = "Term",
        ["null"] = "None"
    }
    return mode_groups[m]
end

-- get the highlight group for a mode group
function get_mode_group_color(mg,textonly)
    -- This is to make sure there is no extra -b... otherwise it will give error which is for Visual-Block etc
    local isExtra = mg.find(mg,'-')
    textonly = textonly or false
    if isExtra then
        mg = mg:sub(0,isExtra-1)
    end
    if textonly then
        return "%#Status" .. mg .. "Text" .. "#"
    end
    return "%#Status" .. mg .. "#"
end

-- get the display name for the group
function get_mode_group_display_name(mg)
    return mg:upper()
end

-- whether the file has been modified
function is_modified()
    if vim.bo.modified then
        if vim.bo.readonly then
            return "-"
        end
        return ""
    end
    return ""
end

-- whether the file is read-only
function is_readonly()
    if vim.bo.readonly then
        return "RO"
    end
    return ""
end

function process_diagnostics(prefix, n, hl)
    out = prefix .. n
    if n > 0 then
        return hl .. out .. dark_highlight
    end
    return out
end

-- from https://github.com/nvim-lua/lsp-status.nvim/blob/master/lua/lsp-status/diagnostics.lua
local function get_lsp_diagnostics(bufnr)
    local result = {
    local levels = {
        errors = "Error",
        warnings = "Warning",
        info = "Information",
        hints = "Hint"
    }

    for k, level in pairs(levels) do
        result[k] = vim.lsp.diagnostic.get_count(bufnr, level)
    end

    return result
end



function GetFileType()
    if (vim.bo.filetype == 'typescript') then
        return ' '

    elseif (vim.bo.filetype == 'python') then
        return ' '

    elseif (vim.bo.filetype == 'html') then
        return ' '

    elseif (vim.bo.filetype == 'scss') then
        return ' '

    elseif (vim.bo.filetype == 'css') then
        return ' '

    elseif (vim.bo.filetype == 'javascript then') then
        return ' '

    elseif (vim.bo.filetype == 'javascriptreact then') then
        return ' '

    elseif (vim.bo.filetype == 'markdown') then
        return ' '

    elseif (vim.bo.filetype == 'sh' or vim.bo.filetype == 'zsh') then
        return ' '

    elseif (vim.bo.filetype == 'vim') then
        return ' '

    elseif (vim.bo.filetype == '') then
        return ''

    elseif (vim.bo.filetype == 'rust') then
        return ' '

    elseif (vim.bo.filetype == 'ruby') then
        return ' '

    elseif (vim.bo.filetype == 'cpp') then
        return ' '

    elseif (vim.bo.filetype == 'c') then
        return ' '

    elseif (vim.bo.filetype == 'go') then
        return ' '

    elseif (vim.bo.filetype == 'lua') then
        return ' '

    elseif (vim.bo.filetype == 'haskel') then
        return ' '

    else
        return ' '

    end
end

function status_line()
    local diagnostics = get_lsp_diagnostics()
    local mode = fn.mode()
    local mg = get_mode_group(mode)
    local accent_color = get_mode_group_color(mg)

    local focus = vim.g.statusline_winid == fn.win_getid()
    if focus then -- If window is enter or focus currently
        mode_text = gen_section(accent_color, {get_mode_group_display_name(mg)})
        mode_text = mode_text .. ''
        fileStat = gen_section(accent_color,{'%p%%','%l:%c'})
        filetypeColor = get_mode_group_color(mg,true)
    else
        -- Setting it empty to show that it is deactive
        mode_text = ""
        fileStat = gen_section(dark_highlight,{'%p%%','%l:%c'})
        -- File will be plain black or dark so we know
        filetypeColor = dark_highlight
    end

    return table.concat {
        mode_text,
        gen_section(emph_highlight, {is_readonly(), "%t", is_modified()}),
        gen_section(
            dark_highlight,
            {
                process_diagnostics(":", diagnostics.errors, "%#LspDiagnosticsDefaultError#"),
                process_diagnostics(":", diagnostics.warnings, "%#LspDiagnosticsDefaultWarning#"),
                process_diagnostics(":", diagnostics.info, "%#LspDiagnosticsDefaultInformation#")
            }
        ),
        "%=",
        --"%{v:register}", --show which last register was used
        gen_section(
            filetypeColor,
            {
                vim.b.gitsigns_status,
                vim.bo.filetype .. ' '.. GetFileType()
            }
        ),
        fileStat
    }
end


vim.o.statusline = "%!luaeval('status_line()')"
