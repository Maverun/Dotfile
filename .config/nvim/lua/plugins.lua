-- Install packer
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)-- using { } for using different branch , loading plugin with certain commands etc

vim.g.mapleader = " " -- Make sure to set `mapleader` before lazy so your mappings are correct


require("lazy").setup({
-- ┌───────────────────────────────────────────────────────────────────────────┐
-- │                                Appearances                                │
-- └───────────────────────────────────────────────────────────────────────────┘

    --'tiagovla/tokyodark.nvim'                          -- Colorscheme
    'folke/tokyonight.nvim',
    'kyazdani42/nvim-web-devicons',                       -- Icon and so on for more conviences
    'lukas-reineke/indent-blankline.nvim',              -- to display indent line
    'norcalli/nvim-colorizer.lua',                      -- to show what color look like
    'kshenoy/vim-signature',                            -- To display where MARK is at (ma, mb ) etc
    'glepnir/dashboard-nvim',                           -- Home page of Neovim
    'nvim-lualine/lualine.nvim',
    'SmiteshP/nvim-navic',

--  ┌───────────────────────────────────────────────────────────────────────────┐
--  │                                   Auto                                    │
--  └───────────────────────────────────────────────────────────────────────────┘

    'windwp/nvim-autopairs',  -- Auto pairs for ( [ {
    'windwp/nvim-ts-autotag',                             -- auto tag and allow to auto retag, useful for html related fields
    'p00f/nvim-ts-rainbow',  -- Rainbow parenthesis etc
    --, 'wakatime/vim-wakatime' -- Waka time
    'zhimsel/vim-stay',      -- Remember fold, cursor etc
    "folke/which-key.nvim",                               -- Reminder what key combination you could press upon prefix

--  ┌───────────────────────────────────────────────────────────────────────────┐
--  │                                Navagation                                 │
--  └───────────────────────────────────────────────────────────────────────────┘

    'unblevable/quick-scope', -- Show highlight key for f,F,t,T, best thing.
    'simrat39/symbols-outline.nvim', --display tags

    {'phaazon/hop.nvim',config=function() require'hop'.setup() end},

-- ┌───────────────────────────────────────────────────────────────────────────┐
-- │                                   Notes                                   │
-- └───────────────────────────────────────────────────────────────────────────┘


    'plasticboy/vim-markdown', --vim markdown for vimwiki
    'dkarter/bullets.vim',
    -- 'gaoDean/autolist.nvim' --auto list for you.

-- ┌───────────────────────────────────────────────────────────────────────────┐
-- │                                LSP Relate                                 │
-- └───────────────────────────────────────────────────────────────────────────┘

    'neovim/nvim-lspconfig',                             -- LSP Config that allow us to use instead of coc
    'williamboman/mason.nvim',
    'williamboman/mason-lspconfig.nvim',
    'brymer-meneses/grammar-guard.nvim',

-- ┌───────────────────────────────────────────────────────────────────────────┐
-- │                                Essentials                                 │
-- └───────────────────────────────────────────────────────────────────────────┘

    'tpope/vim-fugitive',                                 -- GIT
    'tpope/vim-sleuth',                                 -- auto ajust shiftwidth/expandtab
    'numtostr/FTerm.nvim',                               -- Floating Terminal

    --'junegunn/fzf'                                      -- Allowing Fuzzle Finder Search!
    --'junegunn/fzf.vim'                                  -- FZF well u know fuzzy finder thingy

    --'jalvesaq/Nvim-R'                                    -- In replace of Rstudio
    'ekickx/clipboard-image.nvim',                        -- Allow to paste img as a url of path (Auto create picture files locally)
    'Djancyp/cheat-sheet', -- using cheat.sh while in nvim.
    {'nvim-treesitter/nvim-treesitter', run =':TSUpdate'}, -- Treesitter rules all
    'nvim-treesitter/playground',                        -- Allow to Debug
    'nvim-treesitter/nvim-treesitter-textobjects',
    "luckasRanarison/tree-sitter-hypr",

    'hrsh7th/nvim-cmp',                                -- Similar as Coc, to complete menu etc
    'hrsh7th/cmp-nvim-lsp',
    'hrsh7th/cmp-buffer',
    'hrsh7th/cmp-nvim-lua',
    'hrsh7th/cmp-path',
    "hrsh7th/cmp-nvim-lsp-signature-help",

    'saadparwaiz1/cmp_luasnip',
    'tweekmonster/startuptime.vim',                       -- Debug to see system health
    'onsails/lspkind-nvim',
    'nvim-lua/popup.nvim',                                -- Popup API
    'nvim-lua/plenary.nvim',                              -- allow to reuse those function provided
    'nvim-telescope/telescope.nvim',                      -- Powerful tools to see data
    'crispgm/telescope-heading.nvim',


    'tami5/sql.nvim',
    "nvim-telescope/telescope-frecency.nvim",

    { 'echasnovski/mini.nvim', branch = 'stable' },

    'mfussenegger/nvim-dap',
    'theHamsta/nvim-dap-virtual-text',
    'rcarriga/nvim-dap-ui',

    'L3MON4D3/LuaSnip',
    'rafamadriz/friendly-snippets',
    {
        'glacambre/firenvim',
        run = function() vim.fn['firenvim#install'](0) end
    },

    {'knubie/vim-kitty-navigator', run = 'cp ./*.py ~/.config/kitty/'},
    'Vigemus/iron.nvim',

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
    'kdheepak/lazygit.nvim',
    'elihunter173/dirbuf.nvim',

})
