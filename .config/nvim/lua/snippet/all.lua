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
    s('headline', {
        i(1),
        d(2,utils.headline,{1})
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
}
