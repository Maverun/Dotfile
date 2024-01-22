vim.g.mapleader = " " -- Make sure to set `mapleader` before lazy so your mappings are correct

return{
-- ┌───────────────────────────────────────────────────────────────────────────┐
-- │                                Appearances                                │
-- └───────────────────────────────────────────────────────────────────────────┘

    --'tiagovla/tokyodark.nvim'                          -- Colorscheme
    {'folke/tokyonight.nvim',
        lazy = false,
        priority = 1000,
        opts = {
            style = 'night',
            transparent = false,
            styles = {
                comments = 'italic',
                functions = 'NONE',
            }
        }
    },
    'nvim-tree/nvim-web-devicons',                       -- Icon and so on for more conviences
    'lukas-reineke/indent-blankline.nvim',              -- to display indent line
    {'norcalli/nvim-colorizer.lua',opts={'*'}},         -- to show what color look like
    'kshenoy/vim-signature',                            -- To display where MARK is at (ma, mb ) etc
    'SmiteshP/nvim-navic',

--  ┌───────────────────────────────────────────────────────────────────────────┐
--  │                                   Auto                                    │
--  └───────────────────────────────────────────────────────────────────────────┘

    --, 'wakatime/vim-wakatime' -- Waka time
    'zhimsel/vim-stay',      -- Remember fold, cursor etc

--  ┌───────────────────────────────────────────────────────────────────────────┐
--  │                                Navagation                                 │
--  └───────────────────────────────────────────────────────────────────────────┘

    'unblevable/quick-scope', -- Show highlight key for f,F,t,T, best thing.
    { 'simrat39/symbols-outline.nvim', opts={}, keys = { {'<C-t>',':SymbolsOutline<CR>'} } }, --display tags

    {'smoka7/hop.nvim',config=function() require'hop'.setup() end,
    keys = {
        -- {'S',':lua require"hop".hint_words({current_line_only = true,})<CR>',mode= {'n','v','o'}, desc="HOP within current line!",silent = true},
        {'s','<cmd>HopWord<CR>', mode ={'n','v','o'}, desc="HOP!", silent = true},
        {'<leader>{','<cmd>HopNode<CR>', mode ={'n','v','o'}, desc="HOP node!"},
        {'S','<cmd>HopWordMW<CR>', mode ={'n','v','o'}, desc="Hop across window!", silent = true},
    }
},

-- ┌───────────────────────────────────────────────────────────────────────────┐
-- │                                   Notes                                   │
-- └───────────────────────────────────────────────────────────────────────────┘


    'plasticboy/vim-markdown', --vim markdown for vimwiki
    'dkarter/bullets.vim',
    -- 'gaoDean/autolist.nvim' --auto list for you.

-- ┌───────────────────────────────────────────────────────────────────────────┐
-- │                                Essentials                                 │
-- └───────────────────────────────────────────────────────────────────────────┘

    'tpope/vim-fugitive',                                 -- GIT
    'tpope/vim-sleuth',                                 -- auto ajust shiftwidth/expandtab
    {'numtostr/FTerm.nvim',
        keys = {
            {'<leader>tt',':lua require("FTerm").toggle()<cr>', desc = "Fterm Toggle"},
            {'<leader>tt','<C-\\><C-n>:lua require("FTerm").toggle()<cr>', desc = 'Fterm Toggle'},
            {'<leader>tp',':lua require("FTerm").run("python ' .. vim.fn.expand("%:t")..'")<CR>',  desc = "Run Python Terminal"},
            {'<leader>tj',':lua require("FTerm").run("javac ' .. vim.fn.expand("%:t")..' && java '.. vim.fn.expand("%:t:r") ..'")<CR>',  desc = "Run Java Terminal"},
        }
},                               -- Floating Terminal

    --'junegunn/fzf'                                      -- Allowing Fuzzle Finder Search!
    --'junegunn/fzf.vim'                                  -- FZF well u know fuzzy finder thingy

    --'jalvesaq/Nvim-R'                                    -- In replace of Rstudio
    'ekickx/clipboard-image.nvim',                        -- Allow to paste img as a url of path (Auto create picture files locally)
    {'Djancyp/cheat-sheet', keys = { {'<leader>?',':CheatSH<CR>'} } }, -- using cheat.sh while in nvim.

    'tweekmonster/startuptime.vim',                       -- Debug to see system health
    'onsails/lspkind-nvim',
    'nvim-lua/popup.nvim',                                -- Popup API
    'nvim-lua/plenary.nvim',                              -- allow to reuse those function provided

    { 'echasnovski/mini.nvim', branch = 'stable' },

    'L3MON4D3/LuaSnip',
    'rafamadriz/friendly-snippets',

    {'knubie/vim-kitty-navigator', run = 'cp ./*.py ~/.config/kitty/',
       keys = {
            {'<C-h>', ":KittyNavigateLeft<CR>", desc= "Move window to left", silent=true, noremap = true},
            {'<C-j>', ":KittyNavigateDown<CR>", desc= "Move window to down", silent=true, noremap = true},
            {'<C-k>', ":KittyNavigateUp<CR>", desc= "Move window to up", silent=true, noremap = true},
            {'<C-l>', ":KittyNavigateRight<CR>", desc= "Move window to right", silent=true, noremap = true},

       }
},
    -- 'Vigemus/iron.nvim',

    'lervag/vimtex',
    {'numToStr/Comment.nvim', config = function() require("Comment").setup{} end},

    {
        "nvim-neotest/neotest",
        requres = {
            "nvim-lua/plenary.nvim",
            "nvim-treesitter/nvim-treesitter",
            "autoinemadec/FixCursorHold.nvim"
        }
    },
    'nvim-neotest/neotest-python',
    {'kdheepak/lazygit.nvim',
        keys = {
            {'<leader>gg',':LazyGit<CR>'},
        }
    },
    'elihunter173/dirbuf.nvim',

}
