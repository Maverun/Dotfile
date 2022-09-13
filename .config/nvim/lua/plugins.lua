-- Install packer
local install_path = vim.fn.stdpath 'data' .. '/site/pack/packer/start/packer.nvim'

if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  vim.fn.execute('!git clone https://github.com/wbthomason/packer.nvim ' .. install_path)
end

local packer = require("packer")
local use = packer.use

-- using { } for using different branch , loading plugin with certain commands etc
return require("packer").startup(
    function()

    use 'wbthomason/packer.nvim' -- Package manager
-- ┌───────────────────────────────────────────────────────────────────────────┐
-- │                                Apperiances                                │
-- └───────────────────────────────────────────────────────────────────────────┘

    --use 'tiagovla/tokyodark.nvim'                          -- Colorscheme
    use 'folke/tokyonight.nvim'
    use 'kyazdani42/nvim-web-devicons'                       -- Icon and so on for more conviences
    use 'lukas-reineke/indent-blankline.nvim' -- to display indent line
    use 'norcalli/nvim-colorizer.lua'                      -- to show what color look like
    use 'kshenoy/vim-signature'                            -- To display where MARK is at (ma, mb ) etc
    use 'glepnir/dashboard-nvim'                           -- Home page of Neovim
    use 'nvim-lualine/lualine.nvim'
    use 'SmiteshP/nvim-navic'

-- ┌───────────────────────────────────────────────────────────────────────────┐
-- │                                   Auto                                    │
-- └───────────────────────────────────────────────────────────────────────────┘

    use 'windwp/nvim-autopairs'  -- Auto pairs for ( [ {
    use 'windwp/nvim-ts-autotag'                             -- auto tag and allow to auto retag, useful for html related fields
    use 'p00f/nvim-ts-rainbow'  -- Rainbow parenthesis etc
    use 'wakatime/vim-wakatime' -- Waka time
    use 'zhimsel/vim-stay'      -- Remember fold, cursor etc
    use "folke/which-key.nvim"                               -- Reminder what key combination you could press upon prefix

-- ┌───────────────────────────────────────────────────────────────────────────┐
-- │                                Navagation                                 │
-- └───────────────────────────────────────────────────────────────────────────┘

    use 'unblevable/quick-scope' -- Show highlight key for f,F,t,T, best thing.
    use 'simrat39/symbols-outline.nvim' --display tags

    -- use 'kyazdani42/nvim-tree.lua'
    -- use 'ggandor/lightspeed.nvim'
    use {'phaazon/hop.nvim',config=function() require'hop'.setup() end}

-- ┌───────────────────────────────────────────────────────────────────────────┐
-- │                                   Notes                                   │
-- └───────────────────────────────────────────────────────────────────────────┘


    use 'godlygeek/tabular'
    use 'plasticboy/vim-markdown' --vim markdown for vimwiki
    use 'gaoDean/autolist.nvim' --auto list for you.
    -- use 'iamcco/markdown-preview.nvim'
    -- use 'Pocco81/HighStr.nvim'
    -- use 'alok/notational-fzf-vim'
    -- use 'lervag/wiki.vim'
    -- use 'jbyuki/venn.nvim'

-- ┌───────────────────────────────────────────────────────────────────────────┐
-- │                                LSP Relate                                 │
-- └───────────────────────────────────────────────────────────────────────────┘

    use 'neovim/nvim-lspconfig'                             -- LSP Config that allow us to use instead of coc
    -- use 'kabouzeid/nvim-lspinstall'                         -- Ease of Install Language Servers
    use 'williamboman/nvim-lsp-installer'
    use 'brymer-meneses/grammar-guard.nvim'

-- ┌───────────────────────────────────────────────────────────────────────────┐
-- │                                Essentials                                 │
-- └───────────────────────────────────────────────────────────────────────────┘

    use 'tpope/vim-fugitive'                                 -- GIT
    use 'tpope/vim-sleuth'                                 -- auto ajust shiftwidth/expandtab
    -- use 'tpope/vim-commentary'
    use 'numtostr/FTerm.nvim'                               -- Floating Terminal

    --use 'junegunn/fzf'                                      -- Allowing Fuzzle Finder Search!
    --use 'junegunn/fzf.vim'                                  -- FZF well u know fuzzy finder thingy

    --use 'jalvesaq/Nvim-R'                                    -- In replace of Rstudio
    -- use 'mizlan/iswap.nvim'                                  -- Allow to Swap params ease
    use 'ekickx/clipboard-image.nvim'                        -- Allow to paste img as a url of path (Auto create picture files locally)
    -- use 'sudormrfbin/cheatsheet.nvim'                        -- Cheat sheet to remind you
    use 'Djancyp/cheat-sheet' -- using cheat.sh while in nvim.
    use {'nvim-treesitter/nvim-treesitter', run =':TSUpdate'}-- Treesitter rules all
    use 'nvim-treesitter/playground'                        -- Allow to Debug
    use 'nvim-treesitter/nvim-treesitter-textobjects'

    use 'hrsh7th/nvim-cmp'                                -- Similar as Coc, to complete menu etc
    use 'hrsh7th/cmp-nvim-lsp'
    use 'hrsh7th/cmp-buffer'
    use 'hrsh7th/cmp-nvim-lua'
    use 'hrsh7th/cmp-path'
    use "hrsh7th/cmp-nvim-lsp-signature-help"

    use 'saadparwaiz1/cmp_luasnip'
    use 'tweekmonster/startuptime.vim'                       -- Debug to see system health
    use 'onsails/lspkind-nvim'
    use 'nvim-lua/popup.nvim'                                -- Popup API
    use 'nvim-lua/plenary.nvim'                              -- allow to reuse those function provided
    use 'nvim-telescope/telescope.nvim'                      -- Powerful tools to see data
    use 'crispgm/telescope-heading.nvim'


    use 'tami5/sql.nvim'
    use "nvim-telescope/telescope-frecency.nvim"

    use { 'echasnovski/mini.nvim', branch = 'stable' }
    -- use 'tjdevries/train.nvim'                               -- To be Gitgud, Rumor say master UP AND DOWN SON!
    -- use 'ThePrimeagen/vim-be-good'                           -- be faster with moment. train train!

    use 'mfussenegger/nvim-dap'
    use 'theHamsta/nvim-dap-virtual-text'
    use 'rcarriga/nvim-dap-ui'
    --use 'puremourning/vimspector'
    -- use "bfredl/nvim-ipy"
    -- use "ivanov/vim-ipython"

    use 'L3MON4D3/LuaSnip'
    use 'rafamadriz/friendly-snippets'
    use {
        'glacambre/firenvim',
        run = function() vim.fn['firenvim#install'](0) end
    }

    use {'knubie/vim-kitty-navigator', run = 'cp ./*.py ~/.config/kitty/'}
    use 'hkupty/iron.nvim'
--┌────────────────────────────────────────────────────────────────────────────┐
--│                                  Orgmode                                   │
--└────────────────────────────────────────────────────────────────────────────┘

    use {'nvim-orgmode/orgmode', config = function()
                require('orgmode').setup{}
            end
    }

    -- use {'lukas-reineke/headlines.nvim',config = function() require'headlines'.setup() end}
    -- use {'akinsho/org-bullets.nvim',config = function() require'org-bullets'.setup() end}


    use 'lervag/vimtex'
    use {'numToStr/Comment.nvim', config = function() require("Comment").setup{} end}
    use 'phaazon/mind.nvim'

end,
    {
        display = {
            border = { "┌", "─", "┐", "│", "┘", "─", "└", "│" }
        }
    }
)
