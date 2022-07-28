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
      f(utils.mirror,{2},{comment = true, extra = 'function %s end'})
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
