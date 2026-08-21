---@module 'hl'
-- vim: filetype=lua
-- Please note not all available settings / options are set here.
-- For a full list, see the wiki
--
-- See https://wiki.hyprland.org/Configuring/Monitors/
-- DP-2 = Right monitor
-- DP-1 = Middle monitor (main)
-- HDMI-A-1 = Left monitor
-- DP-3 = Top monitor

hl.monitor({
    output   = "HDMI-A-1",
    mode     = "1920x1080@60",
    position = "0x1440",
    scale    = 1,
})

hl.monitor({
    output   = "DP-1",
    mode     = "2560x1440@240",
    position = "1920x1080",
    scale    = 1,
})

hl.monitor({
    output   = "DP-2",
    mode     = "1920x1080@60",
    position = "4480x1440",
    scale    = 1,
})

hl.monitor({
    output   = "DP-3",
    mode     = "1920x1080",
    position = "1920x0",
    scale    = 1,
})

-- hl.monitor({
--     output   = "DP-3",
--     mode     = "disable",
--     position = "auto",
--     scale    = 1,
-- })

-- See https://wiki.hyprland.org/Configuring/Keywords/ for more
-- Execute your favorite apps at launch
-- exec-once = waybar & hyprpaper & firefox
-- Source a file (multi-file configs)
-- source = ~/.config/hypr/myColors.conf
-- Set programs that you use
local terminal = "kitty"
local fileManager = "thunar"
-- $menu = wofi --show drun
-- $menu = tofi-run -c ~/.config/tofi/tokyonight_dmenu | xargs hyprctl dispatch exec --
local menu = "tofi-run -c ~/.config/tofi/tokyonight_dmenu| xargs hyprctl dispatch exec --"
local script = "~/Script"
local hypr_script = "~/.config/hypr/scripts"
local ipc = "noctalia msg "

-- ┌────────────────────────────────────────────────────────────────────────────┐
-- │                           Environment Variables                            │
-- └────────────────────────────────────────────────────────────────────────────┘

-- Some default env vars.
hl.env("XCURSOR_SIZE", 24)
hl.env("QT_QPA_PLATFORMTHEME", "qt5ct")
-- change to qt6ct if you have that
hl.env("QT_QPA_PLATFORM", "wayland;xcb")
-- env = GDK_BACKEND,wayland;x11
hl.env("GDK_BACKEND", "wayland")
hl.env("XDG_CURRENT_DESKTOP", "Hyprland")
hl.env("XDG_SESSION_TYPE", "wayland")
hl.env("XDG_SESSION_DESKTOP", "Hyprland")
-- env = SDL_VIDEODRIVER,wayland
-- env = CLUTTER_BACKEND,wayland
hl.env("BEMENU_OPTS", "--tb")

--#1a1b26 --tf ##7dcfff --nb ##1a1b26 --nf ##c0caf5 --hb ##283457 --hf ##c0caf5 --ab ##292e42 --af ##c0caf5

hl.env("HYPRCURSOR_THEME", "rose-pine-hyprcursor")

-- For all categories, see https://wiki.hyprland.org/Configuring/Variables/

hl.config({
    input = {
        kb_layout = "us",
        numlock_by_default = true,
        repeat_rate = 40,
        repeat_delay = 210,
        -- 0 - Cursor movement will not change focus.
        -- 1 - Cursor movement will always change focus to the window under the cursor.
        -- 2 - Cursor focus will be detached from keyboard focus. Clicking on a window will move keyboard focus to that window.
        -- 3 - Cursor focus will be completely separate from keyboard focus. Clicking on a window will not change keyboard focus.
        follow_mouse = 2,
        mouse_refocus = false,
        float_switch_override_focus = 2,
        special_fallthrough = true,
        touchpad = {
            natural_scroll = false,
        },
        sensitivity = 0,
        -- -1.0 - 1.0, 0 means no modification.
    },
})

hl.config({
    general = {
        -- See https://wiki.hyprland.org/Configuring/Variables/ for more
        gaps_in = 0,
        gaps_out = 10,
        border_size = 2,
        no_focus_fallback = false,
        layout = "dwindle",
        -- no_cursor_warps = true
        -- Please see https://wiki.hyprland.org/Configuring/Tearing/ before you turn this on
        allow_tearing = false,
        -- splash = false,
        col = {
            active_border = { colors = { "rgba(33ccffee)", "rgba(00ff99ee)" }, angle = 45 },
            inactive_border = "rgba(595959aa)",
        },
    },
})

debug.disable_logs = false
debug.gl_debugging = true
hl.config({
    decoration = {
        -- See https://wiki.hyprland.org/Configuring/Variables/ for more
        rounding = 10,
        blur = {
            enabled = false,
            size = 3,
            passes = 1,
            vibrancy = 0.1696,
        },
    },
})

hl.config({
    animations = {
        enabled = true,
        -- Some default animations, see https://wiki.hyprland.org/Configuring/Animations/ for more
    },
})

-- dwindle {
--     # See https://wiki.hyprland.org/Configuring/Dwindle-Layout/ for more
--     pseudotile = true # master switch for pseudotiling. Enabling is bound to mainMod + P in the keybinds section below
--     preserve_split = true # you probably want this
-- }
-- master {
--     # See https://wiki.hyprland.org/Configuring/Master-Layout/ for more
--     new_is_master = true
-- }

hl.config({
    misc = {
        -- See https://wiki.hyprland.org/Configuring/Variables/ for more
        force_default_wallpaper = 0,
        -- Set to 0 to disable the anime mascot wallpapers
        mouse_move_focuses_monitor = false,
        middle_click_paste = false,
        disable_splash_rendering = false,
    },
})

-- Example per-device config
-- See https://wiki.hyprland.org/Configuring/Keywords/#per-device-input-configs for more
-- device:epic-mouse-v1 {
--     sensitivity = -0.5
-- }
--

-- ┌────────────────────────────────────────────────────────────────────────────┐
-- │                                Assign/Rules                                │
-- └────────────────────────────────────────────────────────────────────────────┘

hl.window_rule({
    name  = "windowrule-1",
    match = {
        class = ".*",
    },
    idle_inhibit = "fullscreen",
})

-- Example windowrule v1
-- windowrule = float, ^(kitty)$
-- Example windowrule v2
-- windowrulev2 = float,class:^(kitty)$,title:^(kitty)$
-- See https://wiki.hyprland.org/Configuring/Window-Rules/ for more

hl.window_rule({
    name  = "windowrule-2",
    match = {
        class = ".*",
    },
    suppress_event = "maximize",
})

hl.window_rule({
    name  = "windowrule-3",
    match = {
        title = "$(Godot)$",
    },
        workspace = "9 silent"
    ,})

hl.window_rule({
    name  = "windowrule-4",
    match = {
        class = "(gw2-64.exe)",
    },
    allows_input = true,
})

-- windowrule = allows_input on, match:class (gw2-64.exe)

hl.window_rule({
    name  = "tile_on",
    match = {
        class = "gw2-64.exe",
    },
    tile = true,
})

hl.window_rule({
    name  = "workspace_9",
    match = {
        class = "(gw2-64.exe)",
    },
    workspace = 9,
})

-- windowrule = fakefullscreen, gw2-64.exe

hl.window_rule({
    name  = "tile_on",
    match = {
        title = "Guild Wars 2",
    },
    tile = true,
})

hl.window_rule({
    name  = "workspace_9",
    match = {
        title = "Guild Wars 2",
    },
    workspace = 9,
})

-- windowrule = fakefullscreen, (Guild Wars 2)

hl.workspace_rule({
    workspace = 9,
    monitor = "DP-1",
})

-- windowrule = fullscreen, Burrito

hl.window_rule({
    name  = "windowrule-5",
    match = {
        class = "(mpv)",
    },
    workspace = 8,
    no_follow_mouse = true,
    no_initial_focus = true,
})

-- windowrulev2 = monitor DP-3, title:(mpv)

hl.window_rule({
    name  = "windowrule-6",
    match = {
        class = "(thunderbird)",
    },
    workspace = 5,
})

hl.window_rule({
    name  = "windowrule-7",
    match = {
        title = "(yad)",
    },
    float = true,
})

hl.window_rule({
    name  = "windowrule-8",
    match = {
        class = "(discord)",
    },
    workspace = 4,
})

hl.window_rule({
    name  = "windowrule-9",
    match = {
        title = "(weechat)",
    },
    workspace = 4,
})

hl.window_rule({
    name  = "windowrule-10",
    match = {
        title = "(Fractal)",
    },
    workspace = 4,
})

hl.window_rule({
    name  = "windowrule-11",
    match = {
        title = "(satty)",
    },
    float = true,
})

hl.window_rule({
    name  = "windowrule-12",
    match = {
        title = "(Notetaker)",
    },
    float = true,
    center = true,
    size = { 800, 800 },
})

hl.window_rule({
    name  = "windowrule-13",
    match = {
        title = "(Extension+Mozilla Firefox.*)",
    },
    float = true,
})

hl.window_rule({
    name  = "windowrule-14",
    match = {
        class = "(kitty)",
    },
    opacity = "1 0.9",
})

hl.window_rule({
    name  = "windowrule-15",
    match = {
        class = "(firefox)",
    },
    workspace = 1,
})

hl.window_rule({
    name  = "windowrule-16",
    match = {
        title = "(YouTube)",
    },
    workspace = 3,
})

-- windowrule=opacity 0.3 override 0.3 override,title:(.*)(YouTube)

hl.window_rule({
    name  = "windowrule-17",
    match = {
        class = "^(xwaylandvideobridge)$",
    },
    -- opacity = { 0.0, "override", 0.0, "override" },
    no_anim = true,
    no_initial_focus = true,
    max_size = { 1, 1 },
    no_blur = true,
})

hl.window_rule({
    name  = "windowrule-18",
    match = {
        title = "^(SteamVR Status)$",
        class = "^(com.valvesoftware.vrmonitor)$",
    },
    stay_focused = true,
    min_size = { 1, 1 },
})

--Special Rules for Steam to get the drop-down and lower right “Add Game” menus to work right.

hl.window_rule({
    name  = "windowrule-19",
    match = {
        title = "^()$",
        class = "^(steam)$",
    },
    stay_focused = true,
    min_size = { 1, 1 },
})

hl.window_rule({
    name  = "Arknight Enfield",
    match = {
        title = "Enfield",
    },
    tile = true,
    float = false,
    workspace = 9,
})

hl.window_rule({
    name = "Arknight Launcher",
    match = {
        title = "GRYPHLINK"
    },
    tile= true,
    workspace = 9,
    float = false,
    center = true
})

hl.window_rule({
    name  = "Exilium",
    match = {
        title = "*EXILIUM*",
    },
    tile = true,
    float = false,
    workspace = 9,
})

hl.layer_rule({
    match = {
        namespace = "noctalia-background-.*$",
    },
    ignore_alpha = 0.5,
    blur = true,
    blur_popups = true,
})

hl.workspace_rule({
    workspace = 1,
    monitor = "DP-1",
})

hl.workspace_rule({
    workspace = 4,
    monitor = "HDMI-A-1",
})

hl.workspace_rule({
    workspace = 8,
    monitor = "DP-3",
})

hl.workspace_rule({
    workspace = 3,
    monitor = "DP-2",
})

-- bind = , mouse:274, exec, ;

-- ┌────────────────────────────────────────────────────────────────────────────┐
-- │                                  Keyblind                                  │
-- └────────────────────────────────────────────────────────────────────────────┘

-- See https://wiki.hyprland.org/Configuring/Keywords/ for more

local mainMod = "SUPER"

local hyper = "SUPER+CTRL+ALT+SHIFT"

-- Sub mode http://wiki.hyprland.org/Configuring/Binds/#submaps

-- 2. Resize

hl.bind("SUPER" .. " + " .. "R", hl.dsp.submap("resize"))

--"Resize Mode"

hl.define_submap("resize", function()
    hl.bind("L", hl.dsp.window.resize({ x = 10, y = 0, relative = true }),{ repeating = true }) --"Resize Right"
    hl.bind("J", hl.dsp.window.resize({ x = 0, y = 10, relative = true }),{ repeating = true }) --"Resize Down"
    hl.bind("K", hl.dsp.window.resize({ x = 0, y = -10, relative = true }),{ repeating = true }) --"Resize Up"
    hl.bind("H", hl.dsp.window.resize({ x = -10, y = 0, relative = true }),{ repeating = true }) --"Resize Left"
    hl.bind("escape", hl.dsp.submap("reset"))
    --"Escape mode"
end)


-- 3. Program launcher

hl.bind("SUPER" .. " + " .. "P", hl.dsp.submap("program_launcher"))

--"Program Launcher"

hl.define_submap("program_launcher", function()
    hl.bind("F", hl.dsp.exec_cmd("firefox")) --"Firefox"
    hl.bind("E", hl.dsp.exec_cmd("thunar")) --"File Manager"
    hl.bind("C", hl.dsp.exec_cmd("gnome-clock")) --"Gnome Clock"
    hl.bind("S", hl.dsp.exec_cmd("~/Script/shutdownMenu")) --"Shutdown Menu"
    hl.bind("F", hl.dsp.submap("reset"))
    hl.bind("E", hl.dsp.submap("reset"))
    hl.bind("C", hl.dsp.submap("reset"))
    hl.bind("S", hl.dsp.submap("reset"))
    -- use reset to go back to the global submap
    hl.bind("escape", hl.dsp.submap("reset"))
    --"Escape mode"
    -- will reset the submap, meaning end the current one and return to the global one
end)


-- 2. Screenshot

hl.bind(hyper .. " + " .. "S", hl.dsp.exec_cmd("grim -g \"$(slurp -d)\" - | wl-copy")) --"Screenshot"
hl.bind(hyper .. " + " .. "E", hl.dsp.submap("screenshot")) --"Screenshot Mode"

hl.define_submap("screenshot", function()
    -- Edit of region select.
    hl.bind("A", hl.dsp.exec_cmd("grim -g \"$(slurp -d)\" - | satty --filename - --output-filename - --copy-command wl-copy --early-exit copy"))
    -- "Edit Screenshot with Region select"

    -- Whole screen of currently monitor
    hl.bind("W", hl.dsp.exec_cmd("grim -o \"$(hyprctl activeworkspace | awk '/on monitor/ { print $7 }' | sed 's/:.*//g')\" - | wl-copy"))
    -- "Whole screen screenshot"

    -- Edit whole screen of currently monitor
    hl.bind("E", hl.dsp.exec_cmd("grim -o \"$(hyprctl activeworkspace | awk '/on monitor/ { print $7 }' | sed 's/:.*//g')\" - | satty --filename - --output-filename - --copy-command wl-copy --early-exit copy"))
    --"Whole screenshot Edit"
    hl.bind("R", hl.dsp.exec_cmd("replay-sorcery save"))
    hl.bind("A", hl.dsp.submap("reset"))
    hl.bind("W", hl.dsp.submap("reset"))
    hl.bind("E", hl.dsp.submap("reset"))
    hl.bind("R", hl.dsp.submap("reset"))
    -- use reset to go back to the global submap
    hl.bind("escape", hl.dsp.submap("reset"))
    --"Escape Mode"
end)


-- 2. Monitor Mode

hl.bind(hyper .. " + " .. "m", hl.dsp.submap("monitorMode"))

--"Monitor Mode"

hl.define_submap("monitorMode", function()
    hl.bind(1, hl.dsp.exec_cmd("~/.config/hypr/scripts/monitorSet 1Monitor")) --"One Monitor (Center)"
    hl.bind("h", hl.dsp.exec_cmd("~/.config/hypr/scripts/monitorSet 2MonitorLeft")) --"Two Monitor with left"
    hl.bind("l", hl.dsp.exec_cmd("~/.config/hypr/scripts/monitorSet 2MonitorRight")) --"2 Monitor with right"
    hl.bind(3, hl.dsp.exec_cmd("~/.config/hypr/scripts/monitorSet 3Monitor")) --"3 Monitor (Default)"
    hl.bind(4, hl.dsp.exec_cmd("~/.config/hypr/scripts/monitorSet 4Monitor")) --"4 Monitor(Including top)"
    hl.bind(1, hl.dsp.submap("reset"))
    hl.bind("h", hl.dsp.submap("reset"))
    hl.bind("l", hl.dsp.submap("reset"))
    hl.bind(3, hl.dsp.submap("reset"))
    hl.bind(4, hl.dsp.submap("reset"))
    -- use reset to go back to the global submap
    hl.bind("escape", hl.dsp.submap("reset"))
    --"Escape mode"
    -- will reset the submap, meaning end the current one and return to the global one
end)


-- Example binds, see https://wiki.hyprland.org/Configuring/Binds/ for more

hl.bind(mainMod .. " + " .. "RETURN", hl.dsp.exec_cmd("kitty")) --"Terminal"
hl.bind(mainMod .. " + " .. "SHIFT" .. " + " .. "C", hl.dsp.window.close()) --"Close/Kill"
hl.bind(mainMod .. " + " .. "SHIFT" .. " + " .. "M", hl.dsp.exit()) --"Exit"
-- hl.bind(mainMod .. " + " .. "Y", hl.dsp.exec_cmd("tofi-run -c ~/.config/tofi/tokyonight_dmenu| xargs -I hyprctl dispatch 'hl.dsp.exec_cmd('{}')'")) --"Menu Launcher"
hl.bind(mainMod .. " + " .. "PERIOD", hl.dsp.exec_cmd("notify-send $(hyprctl activewindow | sed -n -e 9p -e 10p -e 11p -e 12p)"))

--"Window information"
hl.bind(mainMod .. " + " .. "PERIOD", hl.dsp.exec_cmd("notify-send $(hyprctl activewindow)"))
hl.bind(mainMod .. " + " .. "F", hl.dsp.window.fullscreen())

--"Fullscreen"
-- bind = $mainMod SHIFT, F, fullscreen, 1 #"Fullscreen
hl.bind(mainMod .. " + " .. "SHIFT" .. " + " .. "P", hl.dsp.window.pin()) --"Pin"
hl.bind(mainMod .. " + " .. "SPACE", hl.dsp.focus({ window = "floating" })) --"Floating Focus"
hl.bind(mainMod .. " + " .. "SHIFT" .. " + " .. "SPACE", hl.dsp.window.float()) --"Floating Toggle"
hl.bind(hyper .. " + " .. "A", hl.dsp.workspace.toggle_special("anime"))

--"Anime Trackma"

-- bind = $hyper, L, exec, hyprlock #"HyprLock"
-- bind = $hyper, O , exec, killall waybar && waybar
-- bind = $mainMod, P, pseudo, # dwindle
-- bind = $mainMod, J, togglesplit, # dwindle

-- Script running

-- 1. Scripts
local script_dir = os.getenv("HOME") .. "/Script/"


-- hl.bind(hyper .. " + " .. "E", hl.dsp.exec_cmd("~/Script/config_edit")) --"Config Edit"
hl.bind(hyper .. " + " .. "K", hl.dsp.exec_cmd(script_dir .. "kill_process")) --"Kill Process"
hl.bind(hyper .. " + " .. "F", hl.dsp.exec_cmd(script_dir .. "search")) --"Search"
hl.bind(hyper .. " + " .. "D", hl.dsp.exec_cmd(script_dir .. "discord_macro")) --"Discord Marco"
hl.bind(hyper .. " + " .. "R", hl.dsp.exec_cmd(script_dir .. "runScript")) --"Run script"
hl.bind(hyper .. " + " .. "T", hl.dsp.exec_cmd(script_dir .. "add_todo")) --"Todo list"
hl.bind(mainMod .. " + " .. "O", hl.dsp.exec_cmd("~/Script/hyprlandFindWindow")) --"Find window"
hl.bind(hyper .. " + " .. "N", hl.dsp.exec_cmd("[float] kitty --class=Notetaker sh ~/Script/notetaker")) --"Floating Note taker"
hl.bind(mainMod .. " + " .. "D", hl.dsp.exec_cmd("~/.config/hypr/scripts/toggle_show_desktop.sh"))

--"Show desktop"
hl.bind(hyper .. " + " .. "W", hl.dsp.exec_cmd("~/.config/hypr/scripts/hyprpaper_change_often.sh"))

--"Change wallpaper"

-- Music/Audio stuff

-- 2. Audio

hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("python ~/Script/mpv_cmus.py play-pause")) --"Play MPV/Media"
hl.bind("XF86AudioStop", hl.dsp.exec_cmd("python ~/Script/mpv_cmus.py stop")) --"Stop MPV/Media"
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("python ~/Script/mpv_cmus.py prev")) --"Prev MPV/Media"
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("python ~/Script/mpv_cmus.py next")) --"Next MPV/Media"

-- bind = , XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
-- binde = , XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 1%+
-- binde = , XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 1%-
-- binde = , Shift+XF86AudioRaiseVolume, exec, playerctl volume 0.1+
-- binde = , Shift+XF86AudioLowerVolume, exec, playerctl volume 0.1-

hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd(ipc .. "volume-up"))
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd(ipc .. "volume-down"))
hl.bind("XF86AudioMute", hl.dsp.exec_cmd(ipc .. "volume-mute"))
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd(ipc .. "brightness-up"))
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd(ipc .. "brightness-down"))

-- 1. Window Management

-- Move focus with mainMod + arrow keys

hl.bind(mainMod .. " + " .. "left", hl.dsp.focus({ direction = "left" }),{ repeating = true }) --"Focus Left"
hl.bind(mainMod .. " + " .. "right", hl.dsp.focus({ direction = "right" }),{ repeating = true }) --"Focus Right"
hl.bind(mainMod .. " + " .. "up", hl.dsp.focus({ direction = "up" }),{ repeating = true }) --"Focus Up"
hl.bind(mainMod .. " + " .. "down", hl.dsp.focus({ direction = "down" }),{ repeating = true }) --"Focus Down"
hl.bind(mainMod .. " + " .. "H", hl.dsp.focus({ direction = "left" }),{ repeating = true }) --"Focus Left"
hl.bind(mainMod .. " + " .. "L", hl.dsp.focus({ direction = "right" }),{ repeating = true }) --"Focus Right"
hl.bind(mainMod .. " + " .. "K", hl.dsp.focus({ direction = "up" }),{ repeating = true }) --"Focus Up"
hl.bind(mainMod .. " + " .. "J", hl.dsp.focus({ direction = "down" }),{ repeating = true }) --"Focus Down"

-- Move window
hl.bind(mainMod .. " + " .. "SHIFT" .. " + " .. "H", hl.dsp.window.move({ direction = "l" })) --"Move Left"
hl.bind(mainMod .. " + " .. "SHIFT" .. " + " .. "L", hl.dsp.window.move({ direction = "r" })) --"Move Right"
hl.bind(mainMod .. " + " .. "SHIFT" .. " + " .. "K", hl.dsp.window.move({ direction = "u" })) --"Move Up"
hl.bind(mainMod .. " + " .. "SHIFT" .. " + " .. "J", hl.dsp.window.move({ direction = "d" })) --"Move Down"

-- Move window

-- TODO: manual review (unknown dispatcher: resizeactive)
-- hl.bind("$mainMod + ALT + H", hl.dsp.resizeactive("-5 0"))

--"Resize Left"

-- TODO: manual review (unknown dispatcher: resizeactive)
-- hl.bind("$mainMod + ALT + L", hl.dsp.resizeactive("5 0"))

--"Resize Right"

-- TODO: manual review (unknown dispatcher: resizeactive)
-- hl.bind("$mainMod + ALT + K", hl.dsp.resizeactive("0 -5"))

--"Resize Up"

-- TODO: manual review (unknown dispatcher: resizeactive)
-- hl.bind("$mainMod + ALT + J", hl.dsp.resizeactive("0 5"))

--"Resize Down"

-- 1. Workspace

-- Switch workspaces with mainMod + [0-9]

hl.bind(mainMod .. " + " .. 1, hl.dsp.focus({ workspace = 1 })) --"Switch to workspace 1"
hl.bind(mainMod .. " + " .. 2, hl.dsp.focus({ workspace = 2 })) --"Switch to workspace 2"
hl.bind(mainMod .. " + " .. 3, hl.dsp.focus({ workspace = 3 })) --"Switch to workspace 3"
hl.bind(mainMod .. " + " .. 4, hl.dsp.focus({ workspace = 4 })) --"Switch to workspace 4"
hl.bind(mainMod .. " + " .. 5, hl.dsp.focus({ workspace = 5 })) --"Switch to workspace 5"
hl.bind(mainMod .. " + " .. 6, hl.dsp.focus({ workspace = 6 })) --"Switch to workspace 6"
hl.bind(mainMod .. " + " .. 7, hl.dsp.focus({ workspace = 7 })) --"Switch to workspace 7"
hl.bind(mainMod .. " + " .. 8, hl.dsp.focus({ workspace = 8 })) --"Switch to workspace 8"
hl.bind(mainMod .. " + " .. 9, hl.dsp.focus({ workspace = 9 })) --"Switch to workspace 9"
hl.bind(mainMod .. " + " .. 0, hl.dsp.focus({ workspace = 10 })) --"Switch to workspace 10"

-- Move active window to a workspace with mainMod + SHIFT + [0-9]
hl.bind(mainMod .. " + " .. "SHIFT" .. " + " .. 1, hl.dsp.window.move({ workspace = 1 })) --"Send Window to workspace 1"
hl.bind(mainMod .. " + " .. "SHIFT" .. " + " .. 2, hl.dsp.window.move({ workspace = 2 })) --"Send Window to workspace 2"
hl.bind(mainMod .. " + " .. "SHIFT" .. " + " .. 3, hl.dsp.window.move({ workspace = 3 })) --"Send Window to workspace 3"
hl.bind(mainMod .. " + " .. "SHIFT" .. " + " .. 4, hl.dsp.window.move({ workspace = 4 })) --"Send Window to workspace 4"
hl.bind(mainMod .. " + " .. "SHIFT" .. " + " .. 5, hl.dsp.window.move({ workspace = 5 })) --"Send Window to workspace 5"
hl.bind(mainMod .. " + " .. "SHIFT" .. " + " .. 6, hl.dsp.window.move({ workspace = 6 })) --"Send Window to workspace 6"
hl.bind(mainMod .. " + " .. "SHIFT" .. " + " .. 7, hl.dsp.window.move({ workspace = 7 })) --"Send Window to workspace 7"
hl.bind(mainMod .. " + " .. "SHIFT" .. " + " .. 8, hl.dsp.window.move({ workspace = 8 })) --"Send Window to workspace 8"
hl.bind(mainMod .. " + " .. "SHIFT" .. " + " .. 9, hl.dsp.window.move({ workspace = 9 })) --"Send Window to workspace 9"
hl.bind(mainMod .. " + " .. "SHIFT" .. " + " .. 0, hl.dsp.window.move({ workspace = 10 })) --"Send Window to workspace 10"

-- Move window to according to direction you select to monitor.

hl.bind(mainMod .. "+CTRL+H", hl.dsp.window.move({ monitor = "l" }))   --"Move to Left monitor"
hl.bind(mainMod .. "+CTRL+L", hl.dsp.window.move({ monitor = "r" }))   --"Move to Right monitor"
hl.bind(mainMod .. "+CTRL+K", hl.dsp.window.move({ monitor = "u" }))   --"Move to Up monitor"
hl.bind(mainMod .. "+CTRL+J", hl.dsp.window.move({ monitor = "d" }))   --"Move to Down monitor"

-- move workspace to other monitor

hl.bind(mainMod .. "+ CTRL + SHIFT + H", hl.dsp.workspace.move({ monitor = "l" })) --"Move Workspace to left monitor"
hl.bind(mainMod .. "+ CTRL + SHIFT + L", hl.dsp.workspace.move({ monitor = "r" })) --"Move Workspace to right monitor"
hl.bind(mainMod .. "+ CTRL + SHIFT + K", hl.dsp.workspace.move({ monitor = "u" })) --"Move Workspace to up monitor"
hl.bind(mainMod .. "+ CTRL + SHIFT + J", hl.dsp.workspace.move({ monitor = "d" })) --"Move Workspace to down monitor"

-- bind = $mainMod CTRL SHIFT, H, focuscurrentorlast
-- bind = $mainMod CTRL SHIFT, L, focuscurrentorlast
-- bind = $mainMod CTRL SHIFT, K, focuscurrentorlast
-- bind = $mainMod CTRL SHIFT, J, focuscurrentorlast

-- Example special workspace (scratchpad)

-- 2. Misc
hl.bind(mainMod .. " + " .. "S", hl.dsp.workspace.toggle_special("magic")) --"Toggle Special Workspace"
hl.bind(mainMod .. " + " .. "SHIFT" .. " + " .. "S", hl.dsp.window.move({ workspace = "special:magic" })) --"Move it to special workspace"

-- Group stuff
hl.bind(mainMod .. " + " .. "E", hl.dsp.group.toggle()) --"Toggle Group"
hl.bind(mainMod .. " + " .. "tab", hl.dsp.group.next()) --"Change Group Active"
hl.bind(mainMod .. " + " .. "SHIFT" .. " + " .. "tab", hl.dsp.group.next({ forward = false })) --"Change Group Active

-- Scroll through existing workspaces with mainMod + scroll
hl.bind(hyper .. " + " .. "mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(hyper .. " + " .. "mouse_up", hl.dsp.focus({ workspace = "e-1" }))

-- Move/resize windows with mainMod + LMB/RMB and dragging
hl.bind(hyper .. " + " .. "mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(hyper .. " + " .. "mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Window layout

-- Noctalia quickshell
hl.bind(mainMod .. "+comma", hl.dsp.exec_cmd(ipc .. "settings-toggle")) --"Noctalia Setting toggle"
-- hl.bind(mainMod .. "+C", hl.dsp.exec_cmd(ipc .. "panel-toggle control-center")) --"Noctalia Control Center"
hl.bind(mainMod .. "+C", hl.dsp.exec_cmd(ipc .. "panel-toggle clipboard")) --"Noctalia Control Center"
hl.bind(mainMod .. "+Y", hl.dsp.exec_cmd(ipc .. "panel-toggle launcher")) --"Noctalia Control Center"

hl.bind(hyper .. " + " .. "P", hl.dsp.exec_cmd(ipc .. "panel-toggle session"))
hl.bind(hyper .. " + " .. "L", hl.dsp.exec_cmd(ipc .. "call lockScreen lock"))

--"Lock the screen"
hl.bind(mainMod .. " + " .. "F1", hl.dsp.exec_cmd(ipc .. "call plugin:keybind-cheatsheet toggle"))
hl.bind(hyper .."+Tab", hl.dsp.exec_cmd(ipc .. "window-switcher"))
-- Noctalia Settings
hl.window_rule({
    match = { class = "dev.noctalia.Noctalia" },
    float = true,
    size = { 1080, 920 },
})

--"Hyprland Cheatsheet"


-- ┌────────────────────────────────────────────────────────────────────────────┐
-- │                                  Startup                                   │
-- └────────────────────────────────────────────────────────────────────────────┘

hl.on("hyprland.start", function()
    hl.exec_cmd("~/Script/fix.sh")
    hl.exec_cmd("dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")
    hl.exec_cmd("noctalia")
    hl.exec_cmd("systemctl --user start hyprpolkitagent")
    hl.exec_cmd("~/home_venv/bin/python3 ~/Script/hyprlandEvent.py")
    hl.exec_cmd("[workspace 2 silent] kitty")
    hl.exec_cmd("/usr/lib/kdeconnectd --replace")
    hl.exec_cmd("[workspace 8 silent] sleep 90 && kdeconnect-app")
    hl.exec_cmd("[workspace 4 silent] webcord")
    hl.exec_cmd("[workspace special:anime silent; float] kitty --class=trackma trackma")
    hl.exec_cmd("[workspace 1 silent] firefox")
    hl.exec_cmd("clipmenud")
    hl.exec_cmd("synology-drive autostart")
    hl.exec_cmd("protonmail-bridge --no-window")
    hl.exec_cmd("protonvpn-app --start-minimized")
    hl.exec_cmd("/usr/lib/polkit-kde-authentication-agent-1")
    -- hl.exec_cmd("wl-clip-persist --clipboard both")
end)

-- For Noctalia Color templates
require("noctalia").apply_theme()
