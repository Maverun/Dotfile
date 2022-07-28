print("luasnip loaded c")
local ls = require('luasnip')
local utils = require("snippet/utils_LS");
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
local fmt = require('luasnip.extras.fmt').fmt

local q = require"vim.treesitter.query"
local ts_locals = require "nvim-treesitter.locals"
local ts_utils = require "nvim-treesitter.ts_utils"

local get_node_text = vim.treesitter.get_node_text


vim.treesitter.set_query('c',
  'LUASnipDocMethod',
[[
(function_definition  
    [
     type: (primitive_type)
     type: (type_identifier)
    ] @type
    [
     declarator: (function_declarator
         declarator: (identifier) @methods 
         parameters: (parameter_list) @params (#offset! @params)
     )

     declarator: (pointer_declarator
        (function_declarator
            declarator: (identifier) @methods 
            parameters: (parameter_list) @params (#offset! @params)
        )
     )
    ]@function_declarator
)

]])


local function parse_signature(raw)
    --raw can be empty 
    -- () string
    -- or
    -- (int x, int y) string
    -- into {x,y} table
    data = {}
    raw = string.gsub(raw,"[(]",""):gsub("[)]","")
    if raw == "" then
        return ""
    end
    -- for token in raw:gmatch("[^%s]+") do
    counter = 0
    for _,token in pairs(vim.split(raw,",")) do
        holder = vim.split(token, " ")
        table.insert(data,holder[#holder])
    end
    return data

end

local function get_doc()
  local language_tree = vim.treesitter.get_parser(0, 'c')
  local syntax_tree = language_tree:parse()
  local root = syntax_tree[1]:root()
  local query = vim.treesitter.get_query("c", "LUASnipDocMethod")
  local current_pos = vim.api.nvim_win_get_cursor(0)
  -- print(vim.inspect(current_pos))
  for _, captures, metadata in query:iter_matches(root, 0,current_pos[1],current_pos[1] +10) do
      param_name_list = parse_signature(q.get_node_text(captures[3],0))
      -- param = parse_signature(captures[3])
      method = q.get_node_text(captures[2],0)
  end

  -- snippet_nodes = {fmt([[\\\ {}\n\\\]],i(1))}
  snippet_nodes = {
        t("/// "),
        i(1),
        t({"","///"}),
        -- fmt([[\\\ {}\n\\\]],i(1))
    }
  for index,item in ipairs(param_name_list) do
  --   -- table.insert(snippet_nodes,fmt([[\\\@param ]]..item..[[ {}]],i(index + 1)))
    vim.list_extend(snippet_nodes,
            {
            t({"",""}),

            t("///@param "..item.." "),
            i(index+1),
            -- fmt([[\\\@param ]]..item..[[ {}]],i(index + 1))
        }
    )
  --
  end

  -- print(vim.inspect(snippet_nodes))
    -- local snip = sn(nil,snippet_nodes)
  return sn(nil,snippet_nodes)



end


return {
    s("doc", {d(1,get_doc)})

} -- end of data


