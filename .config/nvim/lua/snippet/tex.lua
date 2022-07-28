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
    --starter of files
    s('starter',{
        t({'\\documentclass{article}','','\\usepackage[utf8]{inputenc}','\\usepackage[T1]{fontenc}','\\usepackage[proportional]{libertine}','\\frenchspacing','\\usepackage[kerning,spacing]{microtype}'}),
        i(0),
    }),

    -- rec_item is self-referencing. That makes this snippet 'infinite' eg. have as many
    -- \item as necessary by utilizing a choiceNode.
    s("itemize", { t({ "\\begin{itemize}", "\t\\item " }), i(1), d(2, utils.recursive_item, {},'\t\\item'), t({ "", "\\end{itemize}" })}),
    s('enum', { t { '\\begin{enumerate}', '\t\\item ' }, i(1),d(2,utils.recursive_item,{},'\t\\item'),t { '', '\\end{enumerate}', '' } }),
    s('item', { t {'\\item ' }, i(1),d(2,utils.recursive_item,{},'\t\\item')}),

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
