"=============================================================================="
"                                   Rainbow                                    "
"=============================================================================="

let g:rainbow_active = 1


"https://github.com/luochen1990/rainbow#configure
let g:rainbow_conf = {
\	'guifgs': ['royalblue3', 'darkorange3', 'seagreen3', 'firebrick'],
\	'ctermfgs': ['lightblue', 'lightyellow', 'lightcyan', 'lightmagenta'],
\	'guis': [''],
\	'cterms': [''],
\	'operators': '_,_',
\	'parentheses': ['start=/(/ end=/)/ fold', 'start=/\[/ end=/\]/ fold', 'start=/{/ end=/}/ fold'],
\	'separately': {
\		'*': {},
\		'markdown':0, 
\		'lisp': {'guifgs': ['royalblue3', 'darkorange3', 'seagreen3', 'firebrick', 'darkorchid3']},
\		'haskell': {'parentheses': ['start=/(/ end=/)/ fold', 'start=/\[/ end=/\]/ fold', 'start=/\v\{\ze[^-]/ end=/}/ fold']},
\		'vim': {'parentheses_options': 'containedin=vimFuncBody'},
\		'perl': {'syn_name_prefix': 'perlBlockFoldRainbow'},
\		'stylus': {'parentheses': ['start=/{/ end=/}/ fold contains=@colorableGroup']},
\		'css': 0},
\}
