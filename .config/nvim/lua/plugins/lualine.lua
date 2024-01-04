local diagnostic =  {
      'diagnostics',
      -- table of diagnostic sources, available sources:
      -- nvim_lsp, coc, ale, vim_lsp
      sources = {'nvim_diagnostic'},
      -- displays diagnostics from defined severity
      sections = {'error', 'warn', 'info', 'hint'},
    }

return {
    'nvim-lualine/lualine.nvim',
    opts = {
	    options = {
		    icons_enabled = true,
		    theme = 'tokyonight';
		    component_separators = {left = '', right = ''},
		    section_separators = {left = '', right = ''},
		    disabled_filetypes = {}
	    },
	    sections = {
		    lualine_a = {{'mode',icon = '☯'}},
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
}
