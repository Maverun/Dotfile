source $HOME/.config/nvim/general/settings.vim
source $HOME/.config/nvim/vim-plug/plugins.vim
source $HOME/.config/nvim/keys/mappings.vim
source $HOME/.config/nvim/general/plugin_setting/coc_setting.vim "Loading COC setting... after mapping of course.
source $HOME/.config/nvim/general/plugin_setting/startify_setting.vim "Load homepage

autocmd Filetype python :source $HOME/.config/nvim/general/abbreviations/python.vim
