vim.g.mapleader = " " -- Make sure to set `mapleader` before lazy so your mappings are correct

return {
    { 'folke/lazy.nvim' },
    -- ┌───────────────────────────────────────────────────────────────────────────┐
    -- │                                Appearances                                │
    -- └───────────────────────────────────────────────────────────────────────────┘

    --'tiagovla/tokyodark.nvim'                          -- Colorscheme
    {
        'folke/tokyonight.nvim',
        lazy = false,
        priority = 1001,
        config = function()
            require('tokyonight').setup {
                style = 'night',
                transparent = false,
                styles = {
                    comments = 'italic',
                    functions = 'NONE',
                }
            }
            vim.cmd([[colorscheme tokyonight-night]])
        end,
    },

    { "miikanissi/modus-themes.nvim", priority = 1000 },

    'nvim-tree/nvim-web-devicons',                                -- Icon and so on for more conviences
    { 'norcalli/nvim-colorizer.lua', opts = { '*' }, event = "VeryLazy" }, -- to show what color look like
    'kshenoy/vim-signature',                                      -- To display where MARK is at (ma, mb ) etc
    -- {'SmiteshP/nvim-navic', event="VeryLazy"},

    --  ┌───────────────────────────────────────────────────────────────────────────┐
    --  │                                   Auto                                    │
    --  └───────────────────────────────────────────────────────────────────────────┘

    'zhimsel/vim-stay', -- Remember fold, cursor etc

    --  ┌───────────────────────────────────────────────────────────────────────────┐
    --  │                                Navagation                                 │
    --  └───────────────────────────────────────────────────────────────────────────┘

    { 'unblevable/quick-scope', event = "VeryLazy" },                             -- Show highlight key for f,F,t,T, best thing.
    { 'hedyhli/outline.nvim',   opts = {},       keys = { { '<C-t>', '<cmd>Outline<CR>' } } }, --display tags

    {
        'smoka7/hop.nvim',
        config = function()
            require 'hop'.setup({
                create_hl_autocmd = false
            })
        end,
        keys = {
            -- {'S',':lua require"hop".hint_words({current_line_only = true,})<CR>',mode= {'n','v','o'}, desc="HOP within current line!",silent = true},
            { 's',         '<cmd>HopWord<CR>',   mode = { 'n', 'v', 'o' }, desc = "HOP!",        silent = true },
            { '<leader>{', '<cmd>HopNode<CR>',   mode = { 'n', 'v', 'o' }, desc = "HOP node!" },
            { 'S',         '<cmd>HopWordMW<CR>', mode = { 'n', 'v', 'o' }, desc = "Hop across window!", silent = true },
        }
    },



    -- 'gaoDean/autolist.nvim' --auto list for you.

    -- ┌───────────────────────────────────────────────────────────────────────────┐
    -- │                                Essentials                                 │
    -- └───────────────────────────────────────────────────────────────────────────┘

    { 'tpope/vim-fugitive', event = "VeryLazy" }, -- GIT
    { 'tpope/vim-sleuth',   event = "VeryLazy" }, -- auto ajust shiftwidth/expandtab
    {
        'numtostr/FTerm.nvim',
        keys = {
            { '<leader>t',  '',                                                                                                           desc = "Fterm" },
            { '<leader>tt', ':lua require("FTerm").toggle()<cr>',                                                                         desc = "Fterm Toggle" },
            { '<leader>tt', '<C-\\><C-n>:lua require("FTerm").toggle()<cr>',                                                              desc = 'Fterm Toggle' },
            { '<leader>tp', ':lua require("FTerm").run("python ' .. vim.fn.expand("%:t") .. '")<CR>',                                     desc = "Run Python Terminal" },
            { '<leader>tj', ':lua require("FTerm").run("javac ' .. vim.fn.expand("%:t") .. ' && java ' .. vim.fn.expand("%:t:r") .. '")<CR>', desc = "Run Java Terminal" },
        }
    }, -- Floating Terminal

    --'junegunn/fzf'                                      -- Allowing Fuzzle Finder Search!
    --'junegunn/fzf.vim'                                  -- FZF well u know fuzzy finder thingy

    --'jalvesaq/Nvim-R'                                    -- In replace of Rstudio
    -- {'ekickx/clipboard-image.nvim'},                        -- Allow to paste img as a url of path (Auto create picture files locally)
    { 'Djancyp/cheat-sheet',       keys = { { '<leader>?', ':CheatSH<CR>' } } }, -- using cheat.sh while in nvim.

    'onsails/lspkind-nvim',
    'nvim-lua/popup.nvim',   -- Popup API
    'nvim-lua/plenary.nvim', -- allow to reuse those function provided

    {
        'knubie/vim-kitty-navigator',
        run = 'cp ./*.py ~/.config/kitty/',
        keys = {
            { '<C-h>', ":KittyNavigateLeft<CR>",  desc = "Move window to left", silent = true, noremap = true },
            { '<C-j>', ":KittyNavigateDown<CR>",  desc = "Move window to down", silent = true, noremap = true },
            { '<C-k>', ":KittyNavigateUp<CR>",    desc = "Move window to up",   silent = true, noremap = true },
            { '<C-l>', ":KittyNavigateRight<CR>", desc = "Move window to right", silent = true, noremap = true },

        }
    },
    -- { 'lervag/vimtex',             ft = "tex" },
    { 'numToStr/Comment.nvim',     event = "VeryLazy",                     opts = {} },

    { 'elihunter173/dirbuf.nvim',  event = "VimEnter" },

    { "andythigpen/nvim-coverage", opts = {},                              event = "VeryLazy" },
    {
        "leath-dub/snipe.nvim",
        keys = {
            { "gbs", function() require("snipe").open_buffer_menu() end, desc = "Open Snipe buffer menu" }
        },
        opts = {
            ui = {
                position = "cursor"
            }
        }
    },

    {
        "folke/noice.nvim",
        event = "VeryLazy",
        priority = 999,
        opts = {
            routes = {
                {
                    view = "notify",
                    filter = { event = "msg_showmode" },
                },
            },
            lsp = {
                -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
                override = {
                    ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
                    ["vim.lsp.util.stylize_markdown"] = true,
                    -- ["cmp.entry.get_documentation"] = true, -- requires hrsh7th/nvim-cmp
                },
            },
            popupmenu = {
                relative = "editor",
                position = {
                    row = "70%",
                    col = "50%",
                },
                -- size = {
                --     width = 60,
                --     height = 10,
                -- },
                border = {
                    style = "rounded",
                    padding = { 0, 1 },
                },
                win_options = {
                    winhighlight = { Normal = "Normal", FloatBorder = "DiagnosticInfo" },
                },
            },
            -- you can enable a preset for easier configuration
            presets = {
                bottom_search = false,    -- use a classic bottom cmdline for search
                command_palette = true,   -- position the cmdline and popupmenu together
                long_message_to_split = true, -- long messages will be sent to a split
                inc_rename = false,       -- enables an input dialog for inc-rename.nvim
                lsp_doc_border = false,   -- add a border to hover docs and signature help
            },
            dependencies = {
                -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
                "MunifTanjim/nui.nvim",
            }
        }
    }, -- noice
    {
        'fei6409/log-highlight.nvim',
        config = function()
            require('log-highlight').setup {}
        end,
    },

}
