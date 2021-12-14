--┌────────────────────────────────────────────────────────────────────────────┐
--│                                 Dashboard                                  │
--└────────────────────────────────────────────────────────────────────────────┘

local g = vim.g

g.dashboard_disable_at_vimenter = 0
g.dashboard_disable_statusline = 1
g.dashboard_default_executive = "telescope"






g.dashboard_custom_section = {
   a = { description = { "  Find File                 SPC f f" }, command = "Telescope find_files" },
   b = { description = { "  Recents                   SPC f o" }, command = "Telescope oldfiles" },
   c = { description = { "  Frecency                  SPC f r" }, command = "Telescope frecency" },
   d = { description = { "  Find Word                 SPC f g" }, command = "Telescope live_grep" },
   e = { description = { "洛 New File                  SPC f n" }, command = "DashboardNewFile" },
   f = { description = { "  Bookmarks                 SPC f m" }, command = "Telescope marks" },
   g = { description = { "  Load Last Session         SPC l  " }, command = "SessionLoad" },
   h = { description = { "  Quit                      SPC g q" }, command = "q" },
}


g.dashboard_custom_footer = {
   "   ",
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
g.dashboard_custom_header = result
g.dashboard_custom_footer = { '' }
