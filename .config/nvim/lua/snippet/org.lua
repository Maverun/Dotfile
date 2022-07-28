local ls = require("luasnip")
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

return {
    s('item', { t {'\t- [ ] ' }, i(1),d(2,utils.recursive_item,{},'\t- [ ] ')}),

    s('metadata',fmt("#+title: {}\n#+author: Maverun\n#+Tags: {}\n{}",{
        i(1,'Title'),i(2),i(0)
    })),

    s('codeblock',fmt("#+NAME: {}\n#+BEGIN_SRC {}\n{}\n#+END_SRC\n{}",{i(1),i(2,"Language"),i(3),i(0)}))
}--end of return.

