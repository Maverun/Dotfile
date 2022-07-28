--┌────────────────────────────────────────────────────────────────────────────┐
--│                                   Utils                                    │
--└────────────────────────────────────────────────────────────────────────────┘

local ls = require("luasnip")

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

data = {}
-- 'recursive' dynamic snippet. Expands to some text followed by itself.
local recursive_item
recursive_item = function(args,snip,old_state,initial_text)
    return sn(
        nil,
        c(1, {
            -- Order is important, sn(...) first would cause infinite loop of expansion.
            t(""),
            sn(nil, { t({ "", "\t"..initial_text }), i(1), d(2, recursive_item, {},initial_text) }),
        })
    )
end

function data.jdocsnip(args, old_state)
    local nodes = {
        t({ "/**", " * " }),
        i(1, "A short Description"),
        t({ "", "" }),
    }

    -- These will be merged with the snippet; that way, should the snippet be updated,
    -- some user input eg. text can be referred to in the new snippet.
    local param_nodes = {}

    if old_state then
        nodes[2] = i(1, old_state.descr:get_text())
    end
    param_nodes.descr = nodes[2]

    -- At least one param.
    if string.find(args[2][1], ", ") then
        vim.list_extend(nodes, { t({ " * ", "" }) })
    end

    local insert = 2
    for index, arg in ipairs(vim.split(args[2][1], ", ", true)) do
        -- Get actual name parameter.
        arg = vim.split(arg, " ", true)[2]
        if arg then
            local inode
            -- if there was some text in this parameter, use it as static_text for this new snippet.
            if old_state and old_state[arg] then
                inode = i(insert, old_state["arg" .. arg]:get_text())
            else
                inode = i(insert)
            end
            vim.list_extend(
                nodes,
                { t({ " * @param " .. arg .. " " }), inode, t({ "", "" }) }
            )
            param_nodes["arg" .. arg] = inode

            insert = insert + 1
        end
    end

    if args[1][1] ~= "void" then
        local inode
        if old_state and old_state.ret then
            inode = i(insert, old_state.ret:get_text())
        else
            inode = i(insert)
        end

        vim.list_extend(
            nodes,
            { t({ " * ", " * @return " }), inode, t({ "", "" }) }
        )
        param_nodes.ret = inode
        insert = insert + 1
    end

    if vim.tbl_count(args[3]) ~= 1 then
        local exc = string.gsub(args[3][2], " throws ", "")
        local ins
        if old_state and old_state.ex then
            ins = i(insert, old_state.ex:get_text())
        else
            ins = i(insert)
        end
        vim.list_extend(
            nodes,
            { t({ " * ", " * @throws " .. exc .. " " }), ins, t({ "", "" }) }
        )
        param_nodes.ex = ins
        insert = insert + 1
    end

    vim.list_extend(nodes, { t({ " */" }) })

    local snip = sn(nil, nodes)
    -- Error on attempting overwrite.
    snip.old_state = param_nodes
    return snip
end

-- Make sure to not pass an invalid command, as io.popen() may write over nvim-text.
function data.bash(_, command)
    local file = io.popen(command, "r")
    local res = {}
    for line in file:lines() do
        table.insert(res, line)
    end
    return res
end


local function comment_line(line,ignore)
    local comment = vim.api.nvim_buf_get_option(0,'commentstring')
    if ignore[vim.bo.filetype] == true then comment = '%s' end
    return string.format(comment,line)
end

function data.headline(args,old_state,initial_text)
    print("oh man")
    if not old_state then old_state = {} end

    local nodes = {}
    -- if it initial start which can tell if it empty strings
    if args[1][1] == '' then
        return sn(nil,nodes)
    end

    local clen = 0
    if vim.bo.filetype ~= 'markdown' then
        -- - 2 since there will be %s so we want to ignore that
        clen = string.len(vim.api.nvim_buf_get_option(0,'commentstring')) - 2
    end
    -- first we will create top and bottom border line
    -- 78 since we Are using 2 slot for both side
    local top = '┌'..string.rep('─',78-clen)..'┐'
    local bottom = '└'..string.rep('─',78 - clen)..'┘'
    local text_body = {}
    local middle = (80 - clen) / 2
    for k,v in pairs(args[1]) do
        local half = string.len(v) / 2
        local left = '│'..string.rep(" ",middle-1-half)..v
        local message = left..string.rep(" ",80-string.len(left)-1)..'│'
        table.insert(text_body,comment_line(message,{markdown=true}))
    end

    -- now we will enter them into nodes so we can add it to snippets
    if vim.bo.filetype == 'markdown' then table.insert(nodes,t({'```',''})) end
    table.insert(nodes,t({comment_line(top,{markdown=true}),''}))
    table.insert(text_body,'')
    table.insert(nodes,t(text_body))
    table.insert(nodes,t({comment_line(bottom,{markdown=true})}))
    if vim.bo.filetype == 'markdown' then table.insert(nodes,t({'','```',''})) end
    -- now let deletes any previously nodes...
    -- first we get current line which is bottom likely.
    local bottom_line = vim.fn.line('.')
    local top_line = bottom_line - #args[1] -- this get top line
    vim.api.nvim_buf_set_lines(0,top_line,bottom_line,false,{})
    -- return a results
    local snip = sn(nil,nodes)
    snip.old_state = old_state
    return snip

end

-- args is a table, where 1 is the text in Placeholder 1, 2 the text in
-- placeholder 2,...
function data.mirror(args,snip,comment,extra)
    if not extra then extra = '%s' end
    print(args,comment,extra)
    if comment then return comment_line(string.format(extra,args[1][1]),{}) end
    return string.format(extra,args[1][1])
end


return data
