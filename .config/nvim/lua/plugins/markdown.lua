-- ┌───────────────────────────────────────────────────────────────────────────┐
-- │                                   Notes                                   │
-- └───────────────────────────────────────────────────────────────────────────┘

local bullet = { "◉", "✿", "✦", "¤", "", "✸" }
local colors = require('tokyonight.colors').setup()

local gen_heading_spec = function(level, icon)
  return {
    style = "label",
    padding_left = " ",
    padding_right = " ",
    corner_right = "" .. string.rep("", 6 - level),
    corner_right_hl = "decorated_h" .. level .. "_inv",
    icon = bullet[level] .. " ",
    sign = icon,
    sign_hl = "decorated_h" .. level .. "_inv",
    hl = "decorated_h" .. level,
  }
end

highlight_groups = {
    { group_name = "decorated_h1",     value = { bg = colors.cyan, fg = colors.bg, bold = true } },
    { group_name = "decorated_h1_inv", value = { fg = colors.cyan, bold = true } },
    { group_name = "decorated_h2",     value = { bg = colors.green, fg = colors.bg, bold = true } },
    { group_name = "decorated_h2_inv", value = { fg = colors.green, bold = true } },
    { group_name = "decorated_h3",     value = { bg = colors.magenta, fg = colors.bg, bold = true } },
    { group_name = "decorated_h3_inv", value = { fg = colors.magenta, bold = true } },
    { group_name = "decorated_h4",     value = { bg = colors.orange, fg = colors.bg, bold = true } },
    { group_name = "decorated_h4_inv", value = { fg = colors.orange, bold = true } },
    { group_name = "decorated_h5",     value = { bg = colors.red, fg = colors.bg, bold = true } },
    { group_name = "decorated_h5_inv", value = { fg = colors.red, bold = true } },
    { group_name = "decorated_h6",     value = { bg = colors.yellow, fg = colors.bg, bold = true } },
    { group_name = "decorated_h6_inv", value = { fg = colors.yellow, bold = true } },
}

for k,item in pairs(highlight_groups) do
    vim.api.nvim_set_hl(0, item["group_name"], item["value"])
end


return {
    -- {'plasticboy/vim-markdown', ft="markdown"}, --vim markdown for vimwiki
    {'dkarter/bullets.vim', ft="markdown"},
    -- {
    --     "lukas-reineke/headlines.nvim",
    --     dependencies = "nvim-treesitter/nvim-treesitter",
    --     ft="markdown",
    --     config = true, -- or `opts = {}`
    --     opts = {
    --         markdown = {
    --             bullets = { "◉", "✿", "✦", "¤", "", "✸" },
    --             bullet_highlights = { "markdownH1","markdownH2","markdownH3","markdownH4","markdownH5","markdownH6"},
    --         }
    --     }
    -- },

    {
        "iamcco/markdown-preview.nvim",
        cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
        ft = { "markdown" },
        build = function() vim.fn["mkdp#util#install"]() end,
        keys = {
            {"<leader>n",':MarkdownPreviewToggle<CR>', desc="Notes"},
            {"<leader>no",':MarkdownPreviewToggle<CR>', desc="Markdown Preview Toggle"},
        }
    },
    {
        "OXY2DEV/markview.nvim",
        lazy = false,      -- Recommended
        priority = 49,
        -- ft = "markdown" -- If you decide to lazy-load anyway

        dependencies = {
            "nvim-treesitter/nvim-treesitter",
            "nvim-tree/nvim-web-devicons"
        },
        opts = {
            previews = {
                linewise_hybrid_mode = true,
                modes = {'c'},
                hybrid_modes = { 'n' },
            },
            markdown = {
                headings = {
                    heading_1 = gen_heading_spec(1, "󰼏 "),
                    heading_2 = gen_heading_spec(2, "󰎨 "),
                    heading_3 = gen_heading_spec(3, "󰼑 "),
                    heading_4 = gen_heading_spec(4, "󰎲 "),
                    heading_5 = gen_heading_spec(5, "󰼓 "),
                    heading_6 = gen_heading_spec(6, "󰎴 "),

                } -- end of    shift_width = 0,
            }
        }
    }
}

