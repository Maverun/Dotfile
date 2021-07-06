
local fn = vim.fn
local o = vim.o
local cmd = vim.cmd

local function highlight(group, fg, bg)
    cmd("highlight " .. group .. " guifg=" .. fg .. " guibg=" .. bg)
end


vim.g.tokyodark_transparent_background = false
vim.g.tokyodark_enable_italic_comment = true
vim.g.tokyodark_enable_italic = true
vim.g.tokyodark_color_gamma = "1.1"

vim.g.tokyonight_style = "night"

cmd("colorscheme tokyonight")
--cmd("colorscheme tokyodark")
highlight('TSComment','#0087ff','None')

--cmd 'hi WindowLine guifg=#4C4D5A guibg=#151623'
--cmd' set winhighlight=VertSplit:WindowLine'

local diagnostic =  {
      'diagnostics',
      -- table of diagnostic sources, available sources:
      -- nvim_lsp, coc, ale, vim_lsp
      sources = {'nvim_lsp'},
      -- displays diagnostics from defined severity
      sections = {'error', 'warn', 'info', 'hint'},
    }

require'lualine'.setup {
  options = {
    icons_enabled = true,
    theme = 'tokyonight';
    component_separators = {'', ''},
    section_separators = {'', ''},
    disabled_filetypes = {}
  },
  sections = {
    lualine_a = {'mode'},
    lualine_b = {'branch'},
    lualine_c = {'filename', diagnostic},
    lualine_x = {'encoding', 'fileformat', 'filetype'},
    lualine_y = {'progress'},
    lualine_z = {'location'}
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {'filename'},
    lualine_x = {'location'},
    lualine_y = {},
    lualine_z = {}
  },
  tabline = {},
  extensions = {}
}
