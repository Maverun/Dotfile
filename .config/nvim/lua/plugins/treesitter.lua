--┌────────────────────────────────────────────────────────────────────────────┐
--│                                 treesitter                                 │
--└────────────────────────────────────────────────────────────────────────────┘
return {
    {
        'nvim-treesitter/nvim-treesitter',
        build = ':TSUpdate',
        event = "VeryLazy",
        config = function()
            require 'nvim-treesitter.configs'.setup {
                -- ensure_installed = 'maintained',
                highlight = {
                    enable = true,
                    additional_vim_regex_highlighting = true -- <= THIS LINE is the magic! for spelling
                },
                indent = {
                    enable = false,
                    -- diable = {'python','orgmode'},
                },
                autotag = { enable = true },
                incremental_selection = {
                    enable = true,
                    keymaps = {
                        init_selection = "<cr>",
                        node_incremental = "<cr>",
                        scope_incremental = "gnn",
                        node_decremental = "<bs>",
                    }
                }, --end of incremental_selection
                rainbow = {
                    enable = true,
                    extended_mode = true,  -- Highlight also non-parentheses delimiters, boolean or table: lang -> boolean
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
                        }, -- end of keymaps
                    },     --end of select

                    swap = {
                        enable = true,
                        swap_next = {
                            ["<right>"] = "@parameter.inner",
                        },
                        swap_previous = {
                            ["<left>"] = "@parameter.inner",
                        },
                    },
                }, --end of textobjects

                ensure_installed = {
                    "python",
                    "bash",
                    "json",
                    "jsonc",
                    "lua",
                    "regex",
                    "vim",
                    "vimdoc",
                    "yaml",
                    "markdown",
                    "markdown_inline",
                }
            }
        end

    },
    { 'nvim-treesitter/nvim-treesitter-textobjects' },
    { 'nvim-treesitter/playground',                 event = "VeryLazy" },
    {
        "HiPhish/rainbow-delimiters.nvim",
        config = function()
            require 'rainbow-delimiters.setup'.setup {
                highlight = {
                    -- 'RainbowDelimiterRed',
                    'RainbowDelimiterYellow',
                    'RainbowDelimiterBlue',
                    'RainbowDelimiterOrange',
                    'RainbowDelimiterGreen',
                    'RainbowDelimiterViolet',
                    'RainbowDelimiterCyan',
                },
            }
        end
    },
}
