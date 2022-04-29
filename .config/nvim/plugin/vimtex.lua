--┌────────────────────────────────────────────────────────────────────────────┐
--│                                  Vimtex                                    │
--└────────────────────────────────────────────────────────────────────────────┘
local g = vim.g

g.text_flavor = 'latex'

g.latex_view_general_viewer = 'zathura'
g.vimtex_view_method = 'zathura'
g.vimtex_compiler_progname = 'nvr'


g.vimtext_compiler_latexmk = {build_dir = "build"}
