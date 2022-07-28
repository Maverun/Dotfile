local utils = require("snippet/utils_LS");
local ls = require("luasnip")
-- some shorthands...
local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local d = ls.dynamic_node
local l = require("luasnip.extras").lambda
local dl = require('luasnip.extras').dynamic_lambda
local types = require('luasnip.util.types')
local r = require('luasnip.extras').rep
local p = require('luasnip.extras').partial
local n = require('luasnip.extras').nonempty
local m = require('luasnip.extras').match

vim.api.nvim_command("hi LuasnipChoiceNodePassive cterm=italic")
ls.config.setup({
    ext_opts = {
        [types.insertNode] = {
            active = {
                virt_text = {{'●', 'BufferVisibleSign'}},
            },
            --passive = {
                --hl_group = "TSVariableBuiltin",
            --}
        },
        [types.choiceNode] = {
            active = {
                virt_text = {{"●", "Boolean"}},
            },
            --passive = {
                --hl_group = "TSVariableBuiltin",
            --}
        },
    },
    ext_base_prio = 200,
    ext_prio_increase = 7,
})


local current_nsid = vim.api.nvim_create_namespace("LuaSnipChoiceListSelections")
local current_win = nil


local function window_for_choiceNode(choiceNode)
    local buf = vim.api.nvim_create_buf(false, true)
    local buf_text = {}
    local row_selection = 0
    local row_offset = 0
    local text
    for _, node in ipairs(choiceNode.choices) do
        text = node:get_docstring()
        -- find one that is currently showing
        if node == choiceNode.active_choice then
            -- current line is starter from buffer list which is length usually
            row_selection = #buf_text
            -- finding how many lines total within a choice selection
            row_offset = #text
        end
        vim.list_extend(buf_text, text)
    end

    vim.api.nvim_buf_set_text(buf, 0,0,0,0, buf_text)
    local w, h = vim.lsp.util._make_floating_popup_size(buf_text)

    -- adding highlight so we can see which one is been selected.
    local extmark = vim.api.nvim_buf_set_extmark(buf,current_nsid,row_selection ,0,
        {hl_group = 'incsearch',end_line = row_selection + row_offset})

    -- shows window at a beginning of choiceNode.
    local win = vim.api.nvim_open_win(buf, false, {
        relative = "win", width = w, height = h, bufpos = choiceNode.mark:pos_begin_end(), style = "minimal", border = 'rounded'})

    -- return with 3 main important so we can use them again
    return {win_id = win,extmark = extmark,buf = buf}
end

function choice_popup(choiceNode)
    -- build stack for nested choiceNodes.
    if current_win then
        vim.api.nvim_win_close(current_win.win_id, true)
        vim.api.nvim_buf_del_extmark(current_win.buf,current_nsid,current_win.extmark)
    end
    local create_win = window_for_choiceNode(choiceNode)
    current_win = {
        win_id = create_win.win_id,
        prev = current_win,
        node = choiceNode,
        extmark = create_win.extmark,
        buf = create_win.buf
    }
end

function update_choice_popup(choiceNode)
    vim.api.nvim_win_close(current_win.win_id, true)
    vim.api.nvim_buf_del_extmark(current_win.buf,current_nsid,current_win.extmark)
    local create_win = window_for_choiceNode(choiceNode)
    current_win.win_id = create_win.win_id
    current_win.extmark = create_win.extmark
    current_win.buf = create_win.buf
end

function choice_popup_close()
    vim.api.nvim_win_close(current_win.win_id, true)
    vim.api.nvim_buf_del_extmark(current_win.buf,current_nsid,current_win.extmark)
    -- now we are checking if we still have previous choice we were in after exit nested choice
    current_win = current_win.prev
    if current_win then
        -- reopen window further down in the stack.
        local create_win = window_for_choiceNode(current_win.node)
        current_win.win_id = create_win.win_id
        current_win.extmark = create_win.extmark
        current_win.buf = create_win.buf
    end
end

vim.cmd([[
augroup choice_popup
au!
au User LuasnipChoiceNodeEnter lua choice_popup(require("luasnip").session.event_node)
au User LuasnipChoiceNodeLeave lua choice_popup_close()
au User LuasnipChangeChoice lua update_choice_popup(require("luasnip").session.event_node)
augroup END
]])

 --Every unspecified option will be set to the default.
--ls.config.set_config({
    --history = true,
    ---- Update more often, :h events for more info.
    --updateevents = "TextChanged,TextChangedI",
--})


snip = {}
snip.all = require('snippet.all')
snip.java = require('snippet/java')
snip.tex = require('snippet/tex')
snip.python = require('snippet/python')
snip.lua = require('snippet/lua')
snip.org = require('snippet/org')
snip.c = require('snippet/c')
snip.cpp = require('snippet/c')

ls.add_snippets(nil,snip)

require("luasnip.loaders.from_vscode").lazy_load()
