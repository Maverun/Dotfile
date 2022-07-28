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

return {
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
