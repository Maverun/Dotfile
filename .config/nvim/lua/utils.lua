-- ┌───────────────────────────────────────────────────────────────────────────┐
-- │                                   Utils                                   │
-- └───────────────────────────────────────────────────────────────────────────┘
-- help to inspect results, e.g.:
-- ':lua _G.dump(vim.fn.getwininfo())'
function _G.dump(...)
    local objects = vim.tbl_map(vim.inspect, { ... })
    -- print(unpack(objects))
end

local M = {}

function M.has_neovim_v05()
    if vim.fn.has('nvim-0.5') == 1 then
        return true
    end
    return false
end

function M.is_root()
    local output = vim.fn.systemlist "id -u"
    return ((output[1] or "") == "0")
end

function M.is_darwin()
    local os_name = vim.loop.os_uname().sysname
    return os_name == 'Darwin'
--[[ local output = vim.fn.systemlist "uname -s"
    return not not string.find(output[1] or "", "Darwin") ]]
end

function M.shell_type(file)
    vim.fn.system(string.format("type '%s'", file))
    if vim.v.shell_error ~= 0 then return false
    else return true end
end

function M.have_compiler()
    if M.shell_type('cc') or
        M.shell_type('gcc') or
        M.shell_type('clang') or
        M.shell_type('cl') then
        return true
    end
    return false
end

function M.tablelength(T)
    local count = 0
    for _ in pairs(T) do count = count + 1 end
    return count
end

function M.get_visual_selection()
    -- must exit visual mode or program croaks
    -- :visual leaves ex-mode back to normal mode
    -- use 'gv' to reselect the text
    vim.cmd[[visual]]
    local _, csrow, cscol, _ = unpack(vim.fn.getpos("'<"))
    local _, cerow, cecol, _ = unpack(vim.fn.getpos("'>"))
    local lines = vim.fn.getline(csrow, cerow)
    -- local n = cerow-csrow+1
    local n = M.tablelength(lines)
    if n <= 0 then return '' end
    lines[n] = string.sub(lines[n], 1, cecol)
    lines[1] = string.sub(lines[1], cscol)
    print(n, csrow, cscol, cerow, cecol, table.concat(lines, "\n"))
    return table.concat(lines, "\n")
end

function M.ensure_loaded_cmd(modules, cmds)
    vim.cmd[[packadd packer.nvim]]
    for _, m in ipairs(modules) do
        vim.cmd([[PackerLoad ]] .. m)
    end
    for _, c in ipairs(cmds) do
        vim.cmd(c)
    end
end

--[[
function M.list_buffers()
for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
print(bufnr, vim.api.nvim_buf_get_name(bufnr))
end
end
]]

function M.toggle_cursor_column()
    if not vim.g.cursor_toggle_mave then return end
    local is_ruler = vim.g.ruler_toggle_mave
    local is_cursor = vim.g.cursor_toggle_mave
    local wininfo = vim.fn.getwininfo()
    local cwind = vim.api.nvim_get_current_win()
    for _, win in pairs(wininfo) do
        local ft = vim.api.nvim_get_option_value('filetype', {buf = win['bufnr']})
        if ft == nil or ft == '' or ft == 'TelescopePrompt' or ft == "dashboard" then return end
        if win['winid'] ~= cwind then
            -- vim.api.nvim_set_option_value('colorcolumn', '', {win=win['winid']})
            vim.api.nvim_set_option_value('cursorline', false , {win=win['winid']})
            vim.api.nvim_set_option_value('cursorcolumn', false, {win=win['winid']})
        else
            -- vim.api.nvim_set_option_value('colorcolumn', '80', {win=win['winid']})
            vim.api.nvim_set_option_value('cursorline', is_cursor and true, {win=win['winid']})
            vim.api.nvim_set_option_value('cursorcolumn', is_cursor and true, {win=win['winid']})
        end
    end
end

function M.mind_nvim_control_win_size()
    -- get window info and current window
    local wininfo = vim.fn.getwininfo()
    local cwind = vim.api.nvim_get_current_win()
    current_size = vim.api.nvim_win_get_width(0)
    -- if we are less than 2, it is fine but more than 2 window, we need to narrow down mind.
    -- this can happen often when you open up mind files.
    -- if #wininfo < 3 then return end
    local setWidth = require'mind'.opts.ui.width
    local targetwin = cwind
    for _, win in pairs(wininfo) do
        -- print(_,win['bufnr'], win['variables']['netrw_prvfile'])
        -- get filetype of that window it checking and compare if that where I am in.
        local ft = vim.api.nvim_buf_get_option(win['bufnr'], 'filetype')
        if ft == "mind" and cwind ~= win['winid'] then
            setWidth = 10
            targetwin = win['winid']
        end
        if ft == "mind" then
            vim.api.nvim_win_set_width(targetwin,setWidth)
        end
    end


end

-- 'q': find the quickfix window
-- 'l': find all loclist windows
function M.find_qf(type)
    local wininfo = vim.fn.getwininfo()
    local win_tbl = {}
    for _, win in pairs(wininfo) do
        local found = false
        if type == 'l' and win['loclist'] == 1 then
            found = true
        end
        -- loclist window has 'quickfix' set, eliminate those
        if type == 'q' and win['quickfix'] == 1 and win['loclist'] == 0  then
            found = true
        end
        if found then
            table.insert(win_tbl, { winid = win['winid'], bufnr = win['bufnr'] })
        end
    end
    return win_tbl
end

-- open quickfix if not empty
function M.open_qf()
    local qf_name = 'quickfix'
    local qf_empty = function() return vim.tbl_isempty(vim.fn.getqflist()) end
    if not qf_empty() then
        vim.cmd('copen')
        vim.cmd('wincmd J')
    else
        print(string.format("%s is empty.", qf_name))
    end
end

-- enum all non-qf windows and open
-- loclist on all windows where not empty
function M.open_loclist_all()
    local wininfo = vim.fn.getwininfo()
    local qf_name = 'loclist'
    local qf_empty = function(winnr) return vim.tbl_isempty(vim.fn.getloclist(winnr)) end
    for _, win in pairs(wininfo) do
        if win['quickfix'] == 0 then
            if not qf_empty(win['winnr']) then
                -- switch active window before ':lopen'
                vim.api.nvim_set_current_win(win['winid'])
                vim.cmd('lopen')
            else
                print(string.format("%s is empty.", qf_name))
            end
        end
    end
end

-- toggle quickfix/loclist on/off
-- type='*': qf toggle and send to bottom
-- type='l': loclist toggle (all windows)
function M.toggle_qf(type)
    local windows = M.find_qf(type)
    if M.tablelength(windows) > 0 then
        -- hide all visible windows
        for _, win in pairs(windows) do
            vim.api.nvim_win_hide(win.winid)
        end
    else
        -- no windows are visible, attempt to open
        if type == 'l' then
            M.open_loclist_all()
        else
            M.open_qf()
        end
    end
end

-- taken from:
-- https://www.reddit.com/r/neovim/comments/o1byad/what_lua_code_do_you_have_to_enhance_neovim/
--
-- tmux like <C-b>z: focus on one buffer in extra tab
-- put current window in new tab with cursor restored
M.tabedit = function()
    -- skip if there is only one window open
    if vim.tbl_count(vim.api.nvim_tabpage_list_wins(0)) == 1 then
        print('Cannot expand single buffer')
        return
    end

    local buf = vim.api.nvim_get_current_buf()
    local view = vim.fn.winsaveview()
    -- note: tabedit % does not properly work with terminal buffer
    vim.cmd [[tabedit]]
    -- set buffer and remove one opened by tabedit
    local tabedit_buf = vim.api.nvim_get_current_buf()
    vim.api.nvim_win_set_buf(0, buf)
    vim.api.nvim_buf_delete(tabedit_buf, {force = true})
    -- restore original view
    vim.fn.winrestview(view)
end

-- restore old view with cursor retained
M.tabclose = function()
    local buf = vim.api.nvim_get_current_buf()
    local view = vim.fn.winsaveview()
    vim.cmd [[tabclose]]
    -- if we accidentally land somewhere else, do not restore
    local new_buf = vim.api.nvim_get_current_buf()
    if buf == new_buf then vim.fn.winrestview(view) end
end

-- expand or minimize current buffer in a more natural direction (tmux-like)
-- ':resize <+-n>' or ':vert resize <+-n>' increases or decreasese current
-- window horizontally or vertically. When mapped to '<leader><arrow>' this
-- can get confusing as left might actually be right, etc
-- the below can be mapped to arrows and will work similar to the tmux binds
-- map to: "<cmd>lua require'utils'.resize(false, -5)<CR>"
M.resize = function(vertical, margin)
    -- what a point of resize if there is only one window!?
    local wininfo = vim.fn.getwininfo()
    if #wininfo == 1 then return end

    local cur_win = vim.api.nvim_get_current_win()
    vim.cmd(string.format('wincmd %s', vertical and 'l' or 'j'))
    local new_win = vim.api.nvim_get_current_win()

    -- we will first check if it gonna be resize height and then we need to check if there is multi row window
    -- otherwise it would resize height OF CMD LINE, which can reset if cmdheight=0
    -- REMINDER: vertical are for horizontally resize....
    if cur_win == new_win and not vertical then
        -- since we did j, but what of k...
        vim.cmd('wincmd k')
        local new_win2 = vim.api.nvim_get_current_win()
        -- if it match, then that mean there is only one window in that area.
        if cur_win == new_win2 then
            return
        end
    end

    -- determine direction cond on increase and existing right-hand buffer
    -- if both are same then we will flip sign
    local sign = margin > 0
    if cur_win == new_win then
        sign = not sign
    end

    -- Just in case, we want to return to where we were at before run this function.
    vim.api.nvim_set_current_win(cur_win)

    sign = sign and '+' or '-'
    local dir = vertical and 'vertical ' or ''
    local cmd = dir .. 'resize ' .. sign .. math.abs(margin) .. '<CR>'
    vim.cmd(cmd)
end

-- Based on make_position_param from $VIMRUNTIME/lua/vim/lsp/util.lua
function M.make_function_position_param()
    local row, col = unpack(vim.call("searchpos", "\\w(", "bn")) -- TODO: restrict to current line
    row = row - 1
    local line = vim.api.nvim_buf_get_lines(0, row, row+1, true)[1]
    if not line then
        return { line = 0; character = 0; }
    end
    col = vim.str_utfindex(line, col)
    return { line = row; character = col; }
end


-- Based on vim.lsp.util.make_position_params
function M.make_function_position_params()
    return {
        textDocument = vim.lsp.util.make_text_document_params();
        position = M.make_function_position_param();
    }
end


return M
