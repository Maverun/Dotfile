--┌────────────────────────────────────────────────────────────────────────────┐
--│                                 treesitter                                 │
--└────────────────────────────────────────────────────────────────────────────┘--Any plugins that will take over 20+ lines will be individual files 

require('nvim-treesitter.configs').setup{
    ensure_installed = 'maintained',
    highlight = {
        enable = true,
        additional_vim_regex_highlighting = true -- <= THIS LINE is the magic! for spelling
    },
    indent = {
        enable = true,
        diable = {'python'},
    },
    autotag = {enable = true},
    incremental_selection = {enable = true,
        keymaps = {
            init_selection = "<cr>",
            node_incremental = "<cr>",
            scope_incremental = "gnn",
            node_decremental = "<bs>",
        }
    },--end of incremental_selection
    rainbow = {
        enable = true,
        extended_mode = true, -- Highlight also non-parentheses delimiters, boolean or table: lang -> boolean
        max_file_lines = 1000, -- Do not enable for files with more than 1000 lines, int
    },

  textobjects = {
    select = {
      enable = true,

      -- Automatically jump forward to textobj, similar to targets.vim 
      lookahead = true,

      keymaps = {
        -- You can use the capture groups defined in textobjects.scm
        ["af"] = "@function.outer",
        ["if"] = "@function.inner",
        ["ac"] = "@class.outer",
        ["ic"] = "@class.inner",
            },-- end of keymaps
        },--end of select

    swap = {
      enable = true,
      swap_next = {
        ["<Right>"] = "@parameter.inner",
      },
      swap_previous = {
        ["<Left>"] = "@parameter.inner",
      },
    },
    }--end of textobjects
}

