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

local function jdocsnip(args, old_state)
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
local function bash(_, command)
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

local function headline(args,old_state,initial_text)
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
local function mirror(args,snip,comment,extra)
    if not extra then extra = '%s' end
    print(args,commen,extra)
    if comment then return comment_line(string.format(extra,args[1][1]),{}) end
    return string.format(extra,args[1][1])
end

ls.snippets = {}

ls.snippets.all = {
    s('headline', {
        i(1),
        d(2,headline,{1})
        });

    s('info_owner',{
        f(function(args,usarg) return vim.fn.strftime("%c") end,{1},''),
        t({'','Author: '}),
        i(1,'Maverun'),
        t({'','File: '}),
        -- f(function(args,usarg) return vim.api.nvim_buf_get_name(0) end,{1},''),
        f(function(args,usarg) return vim.fn.expand("%:t") end,{1},''),
        t({'',''}),
        i(0),
        }),--end of info owner

    s("trigsa", {
        i(1),
        f(function(args, user_arg_1) return user_arg_1 .. args[1][1] end,
            {1},
            "Will be appended to text from i(0)"),
        i(0)
    }),

    --s({trig = "(%d)", regTrig = true, docstring = "repeatmerepeatmerepeatme"}, {
        --f(function(args)
            --return string.rep("repeatme ", tonumber(args[1].captures[1]))
        --end, {})
    --}),

        -- trigger is fn.
        s("fn", {
            -- Simple static text.
            t("//Parameters: "),
            -- function, first parameter is the function, second the Placeholders
            -- whose text it gets as input.
            f(mirror, 2),
            t({ "", "function " }),
            -- Placeholder/Insert.
            i(1),
            t("("),
            -- Placeholder with initial text.
            i(2, "int foo"),
            -- Linebreak
            t({ ") {", "\t" }),
            -- Last Placeholder, exit Point of the snippet. EVERY 'outer' SNIPPET NEEDS Placeholder 0.
            i(0),
            t({ "", "}" }),
        }),

        s("class", {
            -- Choice: Switch between two different Nodes, first parameter is its position, second a list of nodes.
            c(1, {
                t("public "),
                t("private "),
            }),
            t("class "),
            i(2),
            t(" "),
            c(3, {
                t("{"),
                -- sn: Nested Snippet. Instead of a trigger, it has a position, just like insert-nodes. !!! These don't expect a 0-node!!!!
                -- Inside Choices, Nodes don't need a position as the choice node is the one being jumped to.
                sn(nil, {
                    t("extends "),
                    i(1),
                    t(" {"),
                }),
                sn(nil, {
                    t("implements "),
                    i(1),
                    t(" {"),
                }),
            }),
            t({ "", "\t" }),
            i(0),
            t({ "", "}" }),
        }),

        -- Parsing snippets: First parameter: Snippet-Trigger, Second: Snippet body.
        -- Placeholders are parsed into choices with 1. the placeholder text(as a snippet) and 2. an empty string.
        -- This means they are not SELECTed like in other editors/Snippet engines.
        -- ls.parser.parse_snippet(
        --     "lspsyn",
        --     "Wow! This ${1:Stuff} really ${2:works. ${3:Well, a bit.}}"
        -- ),

        -- When wordTrig is set, snippets only expand as full words (lte won't expand, te will).
        -- ls.parser.parse_snippet(
        --     { trig = "te", wordTrig = true },
        --     "${1:cond} ? ${2:true} : ${3:false}"
        -- ),

        -- The last entry of args passed to the user-function is the surrounding snippet.
        --s(
            --{ trig = "a%d", regTrig = true, wordTrig = true },
            --f(function(args)
                --return "Triggered with " .. args[1].trigger .. "."
            --end, {})
        --),
        -- It's possible to use capture-groups inside regex-triggers.
        -- s(
        --     { trig = "b(%d)", regTrig = true, wordTrig = true },
        --     f(function(args)
        --         return "Captured Text: " .. args[1].captures[1] .. "."
        --     end, {})
        -- ),
        -- Use a function to execute any shell command and print its text.
        -- s("bash", f(bash, {}, "ls")),
        -- Short version for applying String transformations using function nodes.
        -- s("transform", {
        --     i(1, "initial text"),
        --     t({ "", "" }),
        --     -- lambda nodes accept an l._1,2,3,4,5, which in turn accept any string transformations.
        --     -- This list will be applied in order to the first node given in the second argument.
        --     l(l._1:match("[^i]*$"):gsub("i", "o"):gsub(" ", "_"):upper(), 1),
        -- }),
        -- s("transform2", {
        --     i(1, "initial text"),
        --     t("::"),
        --     i(2, "replacement for e"),
        --     t({ "", "" }),
        --     -- Lambdas can also apply transforms USING the text of other nodes:
        --     l(l._1:gsub("e", l._2), { 1, 2 }),
        -- }),
        -- Shorthand for repeating the text in a given node.
        -- s("repeat", { i(1, "text"), t({ "", "" }), r(1) }),
}
ls.snippets.java = {
        -- Very long example for a java class.
        s("fn", {
            d(6, jdocsnip, { 2, 4, 5 }),
            t({"", ""}),
            c(1, {
                t("public "),
                t("private "),
            }),
            c(2, {
                t("void"),
                t("String"),
                t("char"),
                t("int"),
                t("double"),
                t("boolean"),
                i(nil, ""),
            }),
            t(" "),
            i(3, "myFunc"),
            t("("),
            i(4),
            t(")"),
            c(5, {
                t(""),
                sn(nil, {
                    t({ "", " throws " }),
                    i(1),
                }),
            }),
            t({ " {", "\t" }),
            i(0),
            t({ "", "}" }),
        }),
    }
ls.snippets.tex = {
    --starter of files
    s('starter',{
        t({'\\documentclass{article}','','\\usepackage[utf8]{inputenc}','\\usepackage[T1]{fontenc}','\\usepackage[proportional]{libertine}','\\frenchspacing','\\usepackage[kerning,spacing]{microtype}'}),
        i(0),
    }),

    -- rec_item is self-referencing. That makes this snippet 'infinite' eg. have as many
    -- \item as necessary by utilizing a choiceNode.
    s("itemize", { t({ "\\begin{itemize}", "\t\\item " }), i(1), d(2, recursive_item, {},'\t\\item'), t({ "", "\\end{itemize}" })}),
    s('enum', { t { '\\begin{enumerate}', '\t\\item ' }, i(1),d(2,recursive_item,{},'\t\\item'),t { '', '\\end{enumerate}', '' } }),
    s('item', { t {'\\item ' }, i(1),d(2,recursive_item,{},'\t\\item')}),

    -- document setup
    s('doc', {
        t '\\documentclass[',
        i(2),
        t ']{',
        i(1),
        t { '}', '' },
        i(0),
        t { '', '\\begin{document}', '', '\\end{document}' },
    }),
    s('use', { t '\\usepackage', n(2, '['), i(2, 'opts'), n(2, ']'), t '{', i(1), t { '}', '' } }),

    -- environments
    s('beg', {
        t '\\begin{',
        i(1),
        t '}\\label{',
        l(l._1:sub(1, 3), 1),
        t ':',
        i(2),
        t { '}', '\t' },
        i(0),
        t { '', '\\end{' },
        r(1),
        t { '}', '' },
    }),

    s('eq', {
        m(1, '^$', '\\begin{equation*}', '\\begin{equation}\\label{eq:'),
        i(1),
        n(1, '}'),
        t { '', '\t' },
        i(0),
        m(1, '^$', '\n\\end{equation*}', '\n\\end{equation}'),
    }),

    -- sectioning
    s('chap', { t '\\chapter{', i(1), t '}\\label{chap:', i(2), t { '}', '' } }),
    s('sec', { t '\\section{', i(1), t '}\\label{sec:', i(2), t { '}', '' } }),
    s('ssec', { t '\\subsection{', i(1), t '}\\label{sec:', i(2), t { '}', '' } }),
    s('sssec', { t '\\subsubsection{', i(1), t '}\\label{sec:', i(2), t { '}', '' } }),
    s('par', { t '\\paragraph{', i(1), t { '}', '' } }),

    -- math
    s('int', { t '\\int', n(1, '_{'), i(1, '\\Omega'), n(1, '}'), t ' ', i(0), t '\\,d', i(2, 'x') }),
    s('sum', { t '\\sum_{', i(1), t '}', n(2, '^{'), i(2), n(2, '}') }),
    s('seq', { t '\\{', i(2), t '\\}', n(1, '_{'), i(1, 'n\\in\\N'), n(1, '}') }),
    s('lim', { t '\\lim_{', i(1, 'n\\to\\infty'), t '} ' }),
    s('frac', { t '\\frac{', i(1), t '}{', i(2), t '}' }),

    -- including
    s('inc', { t '\\includegraphics[', i(2, 'width='), t ']{', i(1), t '}' }),

    -- formatting
    s('em', { t '\\emph{', i(1), t '}' }),
    s('bf', { t '\\textbf{', i(1), t '}' }),
}

ls.snippets.python = {
        s({trig='main',wordTrig=true,name="Main setup",desc="Main setup to show that this is a scripts."},{
            t({'def main():','\tpass','','','if __name__ == "__main__":','\tmain()'}),
    }),
        -- calling functions with async provided
        --TODO add self feature in?
        -- TODO docstrings add
        s({trig='def',wordTrig=true,name='function',dscr='The functions creations with async support  and docstrings'},{
            c(1,{t('def '),t('async def ')}),
            i(2),
            t({'('}),
            i(3),
            t({'):',''}),
            i(0),
            -- f(function(args) return args[1] end, {})
        }),

        -- loops
        s({trig='for',wordTrig=true, name='Loops', dscr='The loops with few choice'},
            {
            t('for '),
            i(1,'i'),
            t(' in '),
            c(2,{
                sn(nil,{
                    t('range('),
                    i(1,'n'),
                    t(')')
                }),
                i(1,'data')
            }),
            t(':'),
        }),

    }

ls.snippets.lua = {
        s({trig="if", wordTrig=true}, {
            t({"if "}),
            i(1),
            t({" then", "\t"}),
            i(0),
            t({"", "end"})
        }),

        s({trig="ee", wordTrig=true}, {
            t({"else", "\t"}),
            i(0),
        }),

        s({trig='function',wordTrig=true},{
            c(1,{t('local function '),t('function ')}),
            i(2),
            t('('),
            i(3),
            t({')',''}),
            i(0),
            t({'','end '}),
            f(mirror,{2},true,'function %s end')
            }),

        s({trig='for',wordTrig=true},{
            t('for '),
            c(1,{
                sn(nil,{ -- for i = 1, 100,1
                    t(''),i(1,'i'), t(' = '), i(2,'1'), t(','),i(3,'100'), t(','),i(4,'1')
                }),
                sn(nil,{ -- for k,v in pairs/ipairs
                    t(''),i(1,'k'),t(', '),i(2,'v'),t(' in '), c(3,{t('pairs'),t('ipairs')}), t('('),i(4,'data'),t({')'})
                })
            }), -- end of choices
            t({' do',''}),
            i(0),
            t({'','end -- end of for loops'})
        }),

        s({trig='test',wordTrig=true},{
            t('for '),
            c(1,{
                sn(nil,{ -- for i = 1, 100,1
                    t(''),i(1,'i'), t(' = '), i(2,'1'), t(','),i(3,'100'), t(','),i(4,'1'),t({"wew","las","oh god","help"})
                }),
                sn(nil,{ -- for k,v in pairs/ipairs
                    t(''),i(1,'k'),t(', '),i(2,'v'),t(' in '), c(3,{t('pairs'),t('ipairs')}), t('('),i(4,'data'),t({')'})
                }),
                sn(nil,{ -- for i = 1, 100,1
                    t(''),i(1,'i'), t(' = '), i(2,'1'), t(','),i(3,'100'), t(','),i(4,'1'),t({"wew","las"})
                }),
            }), -- end of choices
            t({' do',''}),
            i(0),
            t({'','end -- end of for loops'})
        }),
    }



ls.snippets.org = {
    s('item', { t {'\t- [ ] ' }, i(1),d(2,recursive_item,{},'\t- [ ] ')}),
}
