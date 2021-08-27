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
local r = require("luasnip.extras").rep
local types = require('luasnip.util.types')

vim.api.nvim_command("hi LuasnipChoiceNodePassive cterm=italic")
ls.config.setup({
    ext_opts = {
        [types.insertNode] = {
            active = {
                virt_text = {{'InsertNodes', 'TSVariableBuiltin'}},
            },
            --passive = {
                --hl_group = "TSVariableBuiltin",
            --}
        },
        [types.choiceNode] = {
            active = {
                virt_text = {{"MultiChoices", "TSVariableBuiltin"}},
            },
            --passive = {
                --hl_group = "TSVariableBuiltin",
            --}
        },
    },
    ext_base_prio = 200,
    ext_prio_increase = 7,
})

 --Every unspecified option will be set to the default.
--ls.config.set_config({
    --history = true,
    ---- Update more often, :h events for more info.
    --updateevents = "TextChanged,TextChangedI",
--})


-- 'recursive' dynamic snippet. Expands to some text followed by itself.
local rec_ls
rec_ls = function()
	return sn(
		nil,
		c(1, {
			-- Order is important, sn(...) first would cause infinite loop of expansion.
			t(""),
			sn(nil, { t({ "", "\t\\item " }), i(1), d(2, rec_ls, {}) }),
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
local function mirror(args,comment,extra)
    if not extra then extra = '%s' end
    if comment then return comment_line(string.format(extra,args[1][1]),{}) end
	return string.format(extra,args[1][1])
end

ls.snippets = {
	all = {
    s('headline', {
        i(1),
        d(2,headline,{1})
        });

    s('info_owner',{
        f(function(args,usarg) return vim.fn.strftime("%c") end,{1},''),
        t({'','Author: '}),
        i(1,'Maverun'),
        t({'','File: '}),
        f(function(args,usarg) return vim.api.nvim_buf_get_name(0) end,{1},''),
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
    s({trig = "(%d)", regTrig = true, docstring = "repeatmerepeatmerepeatme"}, {
        f(function(args)
            return string.rep("repeatme ", tonumber(args[1].captures[1]))
        end, {})
    }),

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
		ls.parser.parse_snippet(
			"lspsyn",
			"Wow! This ${1:Stuff} really ${2:works. ${3:Well, a bit.}}"
		),

		-- When wordTrig is set, snippets only expand as full words (lte won't expand, te will).
		ls.parser.parse_snippet(
			{ trig = "te", wordTrig = true },
			"${1:cond} ? ${2:true} : ${3:false}"
		),

		-- The last entry of args passed to the user-function is the surrounding snippet.
		s(
			{ trig = "a%d", regTrig = true, wordTrig = true },
			f(function(args)
				return "Triggered with " .. args[1].trigger .. "."
			end, {})
		),
		-- It's possible to use capture-groups inside regex-triggers.
		s(
			{ trig = "b(%d)", regTrig = true, wordTrig = true },
			f(function(args)
				return "Captured Text: " .. args[1].captures[1] .. "."
			end, {})
		),
		-- Use a function to execute any shell command and print its text.
		s("bash", f(bash, {}, "ls")),
		-- Short version for applying String transformations using function nodes.
		s("transform", {
			i(1, "initial text"),
			t({ "", "" }),
			-- lambda nodes accept an l._1,2,3,4,5, which in turn accept any string transformations.
			-- This list will be applied in order to the first node given in the second argument.
			l(l._1:match("[^i]*$"):gsub("i", "o"):gsub(" ", "_"):upper(), 1),
		}),
		s("transform2", {
			i(1, "initial text"),
			t("::"),
			i(2, "replacement for e"),
			t({ "", "" }),
			-- Lambdas can also apply transforms USING the text of other nodes:
			l(l._1:gsub("e", l._2), { 1, 2 }),
		}),
		-- Shorthand for repeating the text in a given node.
		s("repeat", { i(1, "text"), t({ "", "" }), r(1) }),
	},
	java = {
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
	},
	tex = {
		-- rec_ls is self-referencing. That makes this snippet 'infinite' eg. have as many
		-- \item as necessary by utilizing a choiceNode.
		s("ls", {
			t({ "\\begin{itemize}", "\t\\item " }),
			i(1),
			d(2, rec_ls, {}),
			t({ "", "\\end{itemize}" }),
		}),
	},

    python = {
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
            f(function(args) return args[1] end, {})
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

    },
    lua = {
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
            i(2),
            t({'','end -- end of for loops'})
        })


	},
}

--[[
-- Beside defining your own snippets you can also load snippets from "vscode-like" packages
-- that expose snippets in json files, for example <https://github.com/rafamadriz/friendly-snippets>.
-- Mind that this will extend  `ls.snippets` so you need to do it after your own snippets or you
-- will need to extend the table yourself instead of setting a new one.
]]

require("luasnip/loaders/from_vscode").load({ include = { "python" } }) -- Load only python snippets
require("luasnip/loaders/from_vscode").load({ paths = { "./my-snippets" } }) -- Load snippets from my-snippets folder

-- You can also use lazy loading so you only get in memory snippets of languages you use
require("luasnip/loaders/from_vscode").lazy_load()-- You can pass { path = "./my-snippets/"} as well
