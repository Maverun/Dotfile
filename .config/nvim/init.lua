require('plugins')
require('settings')
require('mappings')
require('theme')
--require('statusline')
require('lsp_config')
require('autocmd')


-- Plugins Imports

require('plugins.rainbow')
require('plugins.autopair')
require('plugins.snippet')
require('plugins.startify')
--require('plugins.vimwiki')
require('plugins.whichkey')
require('plugins.wiki')
require('plugins.dap')
require('plugins.vimspector')

-- for some reason, it is better to have this last, so i can use tab properly...
require('compe_completion')