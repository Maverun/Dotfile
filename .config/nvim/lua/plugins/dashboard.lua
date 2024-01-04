--┌────────────────────────────────────────────────────────────────────────────┐
--│                                 Dashboard                                  │
--└────────────────────────────────────────────────────────────────────────────┘

local art = {
    {
        "                                   ",
        "                                   ",
        "                                   ",
        "   ⣴⣶⣤⡤⠦⣤⣀⣤⠆     ⣈⣭⣿⣶⣿⣦⣼⣆          ",
        "    ⠉⠻⢿⣿⠿⣿⣿⣶⣦⠤⠄⡠⢾⣿⣿⡿⠋⠉⠉⠻⣿⣿⡛⣦       ",
        "          ⠈⢿⣿⣟⠦ ⣾⣿⣿⣷    ⠻⠿⢿⣿⣧⣄     ",
        "           ⣸⣿⣿⢧ ⢻⠻⣿⣿⣷⣄⣀⠄⠢⣀⡀⠈⠙⠿⠄    ",
        "          ⢠⣿⣿⣿⠈    ⣻⣿⣿⣿⣿⣿⣿⣿⣛⣳⣤⣀⣀   ",
        "   ⢠⣧⣶⣥⡤⢄ ⣸⣿⣿⠘  ⢀⣴⣿⣿⡿⠛⣿⣿⣧⠈⢿⠿⠟⠛⠻⠿⠄  ",
        "  ⣰⣿⣿⠛⠻⣿⣿⡦⢹⣿⣷   ⢊⣿⣿⡏  ⢸⣿⣿⡇ ⢀⣠⣄⣾⠄   ",
        " ⣠⣿⠿⠛ ⢀⣿⣿⣷⠘⢿⣿⣦⡀ ⢸⢿⣿⣿⣄ ⣸⣿⣿⡇⣪⣿⡿⠿⣿⣷⡄  ",
        " ⠙⠃   ⣼⣿⡟  ⠈⠻⣿⣿⣦⣌⡇⠻⣿⣿⣷⣿⣿⣿ ⣿⣿⡇ ⠛⠻⢷⣄ ",
        "      ⢻⣿⣿⣄   ⠈⠻⣿⣿⣿⣷⣿⣿⣿⣿⣿⡟ ⠫⢿⣿⡆     ",
        "       ⠻⣿⣿⣿⣿⣶⣶⣾⣿⣿⣿⣿⣿⣿⣿⣿⡟⢀⣀⣤⣾⡿⠃     ",
        "                                   ",
    },--end of hydra ahem... hail hydra
    {
        "            .,ad88888888baa,            ",
        "        ,d8P\"\"\"        \"\"9888ba.   ",
        "     .a8\"          ,ad88888888888a     ",
        "    aP'          ,88888888888888888a    ",
        "  ,8\"           ,88888888888888888888, ",
        " ,8'            (888888888( )888888888, ",
        ",8'             `8888888888888888888888 ",
        "8)               `888888888888888888888,",
        "8                  \"8888888888888888888)",
        "8                   `888888888888888888)",
        "8)                    \"888888888888888 ",
        "(b                     \"88888888888888'",
        "`8,        (8)          8888888888888)  ",
        " \"8a                   ,888888888888)  ",
        "   V8,                 d88888888888\"   ",
        "    `8b,             ,d8888888888P'     ",
        "      `V8a,       ,ad8888888888P'       ",
        "         \"\"88888888888888888P\"       ",
        '              """"""""""""              ',
    },--end of ying and yang
    {

        "███╗░░██╗███████╗░█████╗░██╗░░░██╗██╗███╗░░░███╗",
        "████╗░██║██╔════╝██╔══██╗██║░░░██║██║████╗░████║",
        "██╔██╗██║█████╗░░██║░░██║╚██╗░██╔╝██║██╔████╔██║",
        "██║╚████║██╔══╝░░██║░░██║░╚████╔╝░██║██║╚██╔╝██║",
        "██║░╚███║███████╗╚█████╔╝░░╚██╔╝░░██║██║░╚═╝░██║",
        "╚═╝░░╚══╝╚══════╝░╚════╝░░░░╚═╝░░░╚═╝╚═╝░░░░░╚═╝",
    }, --end of neovim


}--end of header

-- for some reason, math.random(#art) doesn't work so i have to do this way.
math.randomseed( os.time() ) -- For random header.
-- local get_number = (os.date("*t").sec % #art) + 1
local get_number = math.random(#art)
local result = art[get_number]
table.insert(result," ")

vim.api.nvim_create_augroup('dashboard_custom',{clear = true})
vim.api.nvim_create_autocmd('FileType',{
    group = 'dashboard_custom',
    pattern = 'dashboard',
    callback = function()
	vim.b.minitrailspace_disable = true
	vim.api.nvim_buf_set_keymap(0,'n','q','<esc>:q<cr>',{noremap = true, silent = true})
	vim.api.nvim_buf_set_keymap(0,'n','f',':enew<cr>:set laststatus=2<cr>',{noremap = true, silent = true})
    end,
    desc = "Able to quit at dashboard",
})

return {{'nvimdev/dashboard-nvim',
    event = 'VimEnter',
    dependencies = { {'nvim-tree/nvim-web-devicons'}},
    opts = {
        config = {
            header = result,
            shortcut = {
                { icon = ' ', desc =  "Find File", key = "t" , action = "Telescope find_files" },
                { icon = ' ', desc =  "Recents", key = "o" , action = "Telescope oldfiles" },
                { icon = ' ', desc =  "Frecency", key = "r" , action = "Telescope frecency" },
                { icon = ' ', desc =  "Find Word", key = "g" , action = "Telescope live_grep" },
                -- { icon = '洛', desc =  "New File", key = "f" , action = "enew<cr>:set laststatus=2<cr>" },
                { icon = ' ', desc =  "Dirbuf", key = "b" , action = "Dirbuf" },
                { icon = ' ', desc =  "Quit", key = "q" , action = "q" },
            }
        }
    }
}
}
