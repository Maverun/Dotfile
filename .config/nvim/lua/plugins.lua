local packer = require("packer")
local use = packer.use

-- using { } for using different branch , loading plugin with certain commands etc
return require("packer").startup(
    function()


-- ┌───────────────────────────────────────────────────────────────────────────┐
-- │                                Apperiances                                │
-- └───────────────────────────────────────────────────────────────────────────┘

    use 'tiagovla/tokyodark.nvim'                          -- Colorscheme
    use 'folke/tokyonight.nvim'
    use 'kyazdani42/nvim-web-devicons'                       -- Icon and so on for more conviences
    use 'lukas-reineke/indent-blankline.nvim' -- to display indent line
    use 'norcalli/nvim-colorizer.lua'                      -- to show what color look like
    use 'kshenoy/vim-signature'                            -- To display where MARK is at (ma, mb ) etc
    use 'mhinz/vim-startify'                               -- Home page of VIM/NEOVIM
    use 'chrisbra/csv.vim'                                 -- CSV format pretty
    use "Pocco81/NoCLC.nvim"                                -- Disable cursorline/column on inactive window
    use 'kyazdani42/nvim-tree.lua'
    use 'hoob3rt/lualine.nvim'
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
    use 'scrooloose/NERDTree'    -- File Explorer
    use 'majutsushi/tagbar'      -- display tags

-- ┌───────────────────────────────────────────────────────────────────────────┐
-- │                                   Notes                                   │
-- └───────────────────────────────────────────────────────────────────────────┘


    use 'godlygeek/tabular'
    use 'plasticboy/vim-markdown' --vim markdown for vimwiki
    use 'iamcco/markdown-preview.nvim'
    use 'Pocco81/HighStr.nvim'
    use 'alok/notational-fzf-vim'
    use 'lervag/wiki.vim'
    use 'jbyuki/venn.nvim'

-- ┌───────────────────────────────────────────────────────────────────────────┐
-- │                                LSP Relate                                 │
-- └───────────────────────────────────────────────────────────────────────────┘

    use 'neovim/nvim-lspconfig'                             -- LSP Config that allow us to use instead of coc
    use 'kabouzeid/nvim-lspinstall'                         -- Ease of Install Language Servers
    use 'glepnir/lspsaga.nvim'                               -- Powerful tools to allow uses of code, such as read doc, rename at once etc
    use "ray-x/lsp_signature.nvim"                           -- Allow to show Params signature when typings
    -- use {'ray-x/navigator.lua', requires = {'ray-x/guihua.lua', run = 'cd lua/fzy && make',opt=true}}
    use "folke/lsp-trouble.nvim"                             -- Allow to see all lsp message, error,warning etc at once

-- ┌───────────────────────────────────────────────────────────────────────────┐
-- │                                Essentials                                 │
-- └───────────────────────────────────────────────────────────────────────────┘

    use 'tpope/vim-fugitive'                                 -- GIT
    use 'scrooloose/nerdcommenter'                          -- Commenter!
    use 'numtostr/FTerm.nvim'                               -- Floating Terminal
    use 'tpope/vim-repeat'                                  -- Repeat command previous..
    use 'mattn/emmet-vim'                                   -- HTML dealing stuff
    use 'junegunn/fzf'                                      -- Allowing Fuzzle Finder Search!
    use 'junegunn/fzf.vim'                                  -- FZF well u know fuzzy finder thingy
    use 'norcalli/snippets.nvim'                             -- Snippet for snippet, neat with virtual window yo
    use 'SirVer/ultisnips'                                  -- Snips

    use 'jalvesaq/Nvim-R'                                    -- In replace of Rstudio
    use 'mizlan/iswap.nvim'                                  -- Allow to Swap params ease
    use 'ekickx/clipboard-image.nvim'                        -- Allow to paste img as a url of path (Auto create picture files locally)
    use 'sudormrfbin/cheatsheet.nvim'                        -- Cheat sheet to remind you
    use {'nvim-treesitter/nvim-treesitter', run =':TSUpdate'}-- Treesitter rules all
    use 'nvim-treesitter/playground'                        -- Allow to Debug
    use 'hrsh7th/nvim-compe'                                -- Similar as Coc, to complete menu etc
    use 'tweekmonster/startuptime.vim'                       -- Debug to see system health

    use 'nvim-lua/popup.nvim'                                -- Popup API
    use 'nvim-lua/plenary.nvim'                              -- allow to reuse those function provided
    use 'nvim-telescope/telescope.nvim'                      -- Powerful tools to see data

    use "blackCauldron7/surround.nvim"                       -- allow to surround word!

    -- use {"yamatsu m/nvim-cursorline"}
    use 'tjdevries/train.nvim'                               -- To be Gitgud, Rumor say master UP AND DOWN SON!
    use 'ThePrimeagen/vim-be-good'                           -- be faster with moment. train train!

    use 'mfussenegger/nvim-dap'
    use 'puremourning/vimspector'

    use 'L3MON4D3/LuaSnip'
    end,
    {
        display = {
            border = { "┌", "─", "┐", "│", "┘", "─", "└", "│" }
        }
    }
)
