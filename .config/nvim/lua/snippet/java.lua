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

return {
    -- Very long example for a java class.
    s("fn", {
        d(6, utils.jdocsnip, { 2, 4, 5 }),
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
