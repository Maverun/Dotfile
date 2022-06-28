--┌────────────────────────────────────────────────────────────────────────────┐
--│                                 Dashboard                                  │
--└────────────────────────────────────────────────────────────────────────────┘

local g = vim.g
local db = require('dashboard')
db.custom_center = {
   { icon = ' ', desc =  "Find File                  ", shortcut = "SPC f f" , action = "Telescope find_files" },
   { icon = ' ', desc =  "Recents                    ", shortcut = "SPC f o" , action = "Telescope oldfiles" },
   { icon = ' ', desc =  "Frecency                   ", shortcut = "SPC f r" , action = "Telescope frecency" },
   { icon = ' ', desc =  "Find Word                  ", shortcut = "SPC f g" , action = "Telescope live_grep" },
   { icon = '洛', desc =  "New File                   ", shortcut = "SPC f n" , action = "DashboardNewFile" },
   { icon = ' ', desc =  "Bookmarks                  ", shortcut = "SPC f m" , action = "Telescope marks" },
   { icon = ' ', desc =  "Load Last Session          ", shortcut = "SPC l -" , action = "SessionLoad" },
   { icon = ' ', desc =  "Quit                       ", shortcut = "SPC g q" , action = "q" },
}



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
db.custom_header = result
