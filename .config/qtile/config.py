# -*- coding: utf-8 -*-
import os
import re
import socket
import subprocess
from libqtile.config import Click, Drag, Group, KeyChord, Key, Match, Screen, ScratchPad, DropDown
from libqtile import qtile
from libqtile.command import lazy
from libqtile import layout, bar, widget, hook
from libqtile.lazy import lazy
from typing import List  # noqa: F401
from libqtile.log_utils import logger
from datetime import datetime 
from tkinter import Tk
import json 
myTerm = "alacritty"                             # My terminal of choice


#monitor position, you can find order by xrandr --listactivemonitors    
monitor_position = [[-1, 2,-1],#top
                    [ 3, 0, 1]]#middle

def debug_qtile(qtile):
    logger.warning(str(qtile.current_layout.name))
    logger.warning(json.dumps(qtile.current_layout.info(),indent=3))
    logger.warning(str(qtile.current_layout.clients))
    logger.warning(json.dumps(qtile.cmd_groups(),indent=3))
    # logger.warning(str(qtile.current_screen.current_layout))


def is_atEdge(data,name,current,key):
    #if it only 1 window, always true
    if len(data["clients"]) in (0,1): return True 
    #always cuz only one window
    if name == "treetab" and key in "hl": return True 
    if name == "max" and key in "jk":
        if current == 0 and current in (0,len(data['clients']) -1) and key == "j": return False
        elif current == 0 and key == "k": return True
        elif current == len(data["clients"]) - 1 and key == "j": return True
        else: return False


    #left most,no matter what layerout...
    if key == "h" and current == 0: return True
    elif key =="l" and name in ("slack","columns") and  current == len(data[name]):
        return True
    elif key == "k" and current in (0,1): return True 
    elif key == "j" and current in (0, len(data["clients"]) - 1): return True
    return key == "l" and current > 0 #if other layout and not on left side.
    #this also making sure that key is left, could be h and is on right side

def get_next_screen_index(qtile,key):
    """
    Function: get screen index
    Since we want to make logical sense for screen, even top monitor shouldn't
    wrap around within middle monitor
    Params:
    qtile - qtile object
    key - hjkl directions
    
    Return: -1 if None else index(0+) - Screen Number 
    """
    current_screen = qtile.screens.index(qtile.current_screen)
    index = -1 #Holder index 
    isUp = False if key in "hl" else True
    direction = 1 if key in "jl" else - 1 #j|l = down|right, h|k = left|up
    for row_index, monitor in enumerate(monitor_position):
        if current_screen in monitor:
            index = monitor.index(current_screen)
        #Same row monitor and not going up
        if index >= 0 and not isUp:
            next_index = (index + direction) % len(monitor) #warp it back to start
            return monitor[next_index]
        #if it up and found current row
        elif index >= 0 and isUp:
            #then here we need to get position
            cmonitor_index = monitor.index(current_screen)
            next_row = (row_index + direction) % len(monitor_position)
            next_screen = monitor_position[next_row][cmonitor_index]
            return next_screen
    return -1 #if we couldn't find any... 
    
#end of the function get screen index

def custom_focus(qtile,key):
    layout =  qtile.current_layout
    data = layout.info()
    name = data["name"]
    current = data.get("current",data.get("current_stack",None))
    # logger.warning(json.dumps(data,indent=3))
    current = 0 if current is None and name == "treetab" else current
    #If it at edge, then we can go next screen
    if is_atEdge(data,name,current,key) or (name == "max" and key in "hl"):
        next_screen = get_next_screen_index(qtile,key)
        #for w/e reason it couldn't find screen, just forget about it
        if next_screen == -1: return 
        qtile.focus_screen(next_screen)
        #now we got next screen, let try focus on correct window position           
        #This point here, we will check if window on new screen,
        #if we change focus from right to left, window focus should be on 
        #right side of new screen, same for other direction
        layout = qtile.current_layout #Update layout
        new_data = layout.info()
        new_current = new_data.get("current",new_data.get("current_stack",None))
        if len(new_data["clients"]) == 1: return
        elif new_data["name"] == "treetab": return
        elif new_data["name"] == "max" and key in "hl": return
        elif new_data["name"] == "stack":
            if new_current == 0 and key == "h": layout.cmd_next()
            elif new_current >= 1 and key == "l": layout.cmd_next() 
        else:
            if new_current == 0 and key == "h": layout.cmd_right()
            elif new_current >= 1 and key == "l": layout.cmd_left()
            elif new_current == len(new_data["clients"]) -1 and key in "jk": 
                #bit strange idea as it should opposite, but
                #if we are at bottom, might as well go down
                layout.cmd_down()
        return
    if name == "stack" and key in "hl":
        layout.cmd_next() #terrible but what choice do we got? but 2 stack is enough
    elif key == "h": layout.cmd_left()
    elif key == "j": layout.cmd_down()
    elif key == "k": layout.cmd_up()
    elif key == "l": layout.cmd_right()

def swap_across_screen(qitle,key):
    """
    Function: swap across screen

    Params:
    qitle: ROOT qtile 
    key: hjkl directions 
    """
    #getting current window and screen before we switch to new
    active_win = qtile.current_window
    old_screen = qtile.screens.index(qtile.current_screen)
    new_screen = get_next_screen_index(qtile,key)
    qtile.focus_screen(new_screen)
    #first we must make sure we set focus right...
    layout = qtile.current_layout
    data = layout.info()
    current = data.get("current",data.get("current_stack"))
    #If there is multi window, we will pick one that is closest
    #if it treetab, ignore it!
    if len(data["clients"]) > 1 and data["name"] != "max": #This is similar as custom focus
        if data["name"] == ("treetab","max"): pass # layout.cmd_up()
        elif data["name"] == "stack":
            if current == 0 and key == "h": layout.cmd_next()
            elif current >= 1 and key == "l": layout.cmd_next() 
        else:
            if current == 0 and key == "h": layout.cmd_right()
            if current >= 1 and key == "l": layout.cmd_left()
    #Now we swap them around.
    swap_win = qtile.current_window
    if data["name"] == "monadtall" and key == "h":
        swap_win.toscreen(old_screen)
        active_win.toscreen()
    else:
        active_win.toscreen()
        swap_win.toscreen(old_screen)
    #if it treetab, then just go down
    if data["name"] == "treetab": qtile.current_layout.cmd_down()
#end of the function swap across screen

def custom_swap(qtile,key):
    """
    Function: custom swap

    Params:
    qtile: ROOT object
    key: hjkl keys
    """
    layout =  qtile.current_layout
    data = layout.info()
    name = data["name"]

    current = data.get("current",data.get("current_stack",None))
    current = 0 if current is None and name == "treetab" else current
    #If it at edge, then we can go next screen
    if is_atEdge(data,name,current,key) or (name == "max" and key in "hl"):
        return swap_across_screen(qtile,key)
    if name == "stack" and key in "hl":
        #terrible but what choice do we got? but 2 stack is enough
        layout.cmd_client_to_next() 
        #then terrible idea? We shall see
        layout.cmd_up() #focus on other window
        layout.cmd_client_to_previous() #swap back to other stack (new window)
        layout.cmd_next() #now return to main window we origibal swap
    elif name == "treetab": return 
    elif key == "h": layout.cmd_shuffle_left()
    elif key == "j": layout.cmd_shuffle_down()
    elif key == "k": layout.cmd_shuffle_up()
    elif key == "l": layout.cmd_shuffle_right()
#end of the function custom swap


def custom_send(qtile,key):
    """
    Function: custom send
    This is where you send window to new screen
    Params:
    qtile
    """
    #Get current active window
    active_win = qtile.current_window
    if active_win is None: return #ignore if empty.
    #getting screen index
    new_screen_index = get_next_screen_index(qtile,key)
    #Now focus that screen
    qtile.focus_screen(new_screen_index) 
    #We command active window move to that new screen
    active_win.toscreen()
    #and set it focus
    active_win.focus(warp=True)
  
def custom_switch_group(qtile,direction):
    """
    Function: custom switch group

    Params:
    qtile: ROOT 
    direction: left or right via h l or [] 
    """
    #get current data on this
    data = qtile.cmd_groups()
    #we need to get our current screen 
    screen = qtile.current_screen 
    #Now we will create array of groups so we can check
    data_group = list(data.keys())
    #since its not dynamic, no need to repeat call it
    length = len(data_group)
    current_index = data_group.index(qtile.current_group.name)
    toward_side = 1 if direction == "l" else - 1
    target = None
    while True:
        #now we will go iterative depend on direction given to find one
        #That group is not in screen
        current_index += toward_side
        target = data_group[current_index % length] #making warp possible.
        if data[target]["name"] == "scratchpad": continue #ignore scratchpad, doesn't make sense to go into this.
        if data[target]["screen"] == None: break
    #Now we will swap with that target!
    screen.cmd_toggle_group(target)


def custom_Screenshot(qtile,path,diary=False):
    logger.warning(diary)
    qtile.cmd_spawn(f"flameshot gui -p {path}")
    p = datetime.now()
    p = p.strftime("%F_%H-%M")
    if diary:
        # qtile.cmd_spawn(f"echo ../images/{p}.png | xset -b")
        # pyperclip.copy(f"../images/{p}.png")
        r = Tk()
        r.withdraw()
        r.clipboard_clear()
        r.clipboard_append(f"../images/{p}.png")
        r.update()
        r.destroy()
    
#end of the function custom switch group
#end of the function custom send
# Key-Blinding System Law
# Any thing that is related to WM/Hotkey/Shortcut must active SUPER key
# Main reason for this is that I do not want to bind key to others that software
# could used it, hence interfance it

# - Super - Move around, focus window etc
# - Super + Alt  - Window relate to Screen/Groups
# - Super + Shift - Window to another window (e.g swap window around)
# - Super + Ctrl - Window management (resize etc)
# - Super + Ctrl + Shift + Alt - For script, Will use it on G1-G6 Key (keyboard marco)

home = os.path.expanduser('~')
sup         = ["mod4"]                         # Sets mod key to SUPER/WINDOWS
super_alt   = ["mod4","mod1"]
super_ctrl  = ["mod4","control"]
super_shift = ["mod4","shift"]
Gkey        = ["mod4","control","shift","mod1"]
hyper       = ["mod4","control","shift","mod1"]

keys = [ #Setting key blindings
    Key(sup,"v",lazy.function(debug_qtile)),
    # Key(sup, "Left", lazy.screen.prev_group()),
    # cycle to next group
    # Key(sup, "Right", lazy.screen.next_group()),

# ┌───────────────────────────────────────────────────────────────────────────┐
# │                                Essentials                                 │
# └───────────────────────────────────────────────────────────────────────────┘

    Key(sup, "Return",
        lazy.spawn(myTerm),
        desc='Launches My Terminal'
        ),
    Key(super_shift, "x",
        lazy.spawncmd(),
        desc='Launches My Terminal'
        ),
    Key(super_shift, "Return",
        lazy.spawn("dmenu_run -m 0 -p 'Run: '"),
        # lazy.spawn("rofi -show drun -config ~/.config/rofi/themes/dt-dmenu.rasi -display-drun \"Run: \" -drun-display-format \"{name}\""),
        desc='Run Launcher'
        ),
    #CHORD OF PROGRAM LAUNCHER
    KeyChord(sup,"p",[
            Key([],"f",lazy.spawn("firefox"),lazy.function(lambda x: x.ungrab_chord()), desc="Firefox"),
            Key([],"e",lazy.spawn("thunar"), lazy.function(lambda x: x.ungrab_chord()),desc="Thunar explorer"),
            Key([],"c",lazy.spawn("gnome-clocks"),lazy.function(lambda x: x.ungrab_chord()), desc="Clocks"),
            Key([],"l",
                lazy.spawn('rofi -modi run,drun,window -show drun -show-icons -sidebar-mode -kb-mode-next "Alt+Tab"'),
                Key([],"c",lazy.spawn("gnome-clocks"),lazy.function(lambda x: x.ungrab_chord()), desc="Clocks"),
                # lazy.ungrab_chord(),
                desc="Rofi Appfinder"),
    #End of CHORD
                ],mode="Program Launcher"),
    #Keyboard hotkey G1-G6 
    Key(Gkey,"F12",
        lazy.spawn("flameshot gui"),
        desc="Run Screenshot mode"),
    Key(Gkey,"F11",
        lazy.spawn(home + "/Script/add_todo"),
        desc="Add todo task to TODO.MD"),
    Key(Gkey,"F10",
        lazy.spawn(home + "/Script/config_edit"),
        desc="Confit Edit"),
    Key(Gkey,"F9",
        lazy.spawn('rofi -modi run,drun,window -show drun -show-icons -sidebar-mode -kb-mode-next "Alt+Tab"'),
        desc="Rofi Appfinder"),
    Key(Gkey,"F8",
        lazy.spawn(home + "/Script/kill_process"),
        desc="Confit Edit"),
    Key(Gkey,"F7",
        lazy.spawn(home + "/Script/search"),
        desc="Search Engine"),
    KeyChord(hyper,"s",[
        Key([], "s",
            lazy.spawn("flameshot gui"),
            # lazy.ungrab_chord(),
            lazy.function(lambda x: x.ungrab_chord()),
            desc="Flameshot SS"),
        Key([], "d",
            lazy.function(custom_Screenshot,"/ext_drive/SynologyDrive/vimwiki/Dev/images/",True),
            lazy.ungrab_chord(),
            desc="Flameshot and save files into Dev Diary Vimwiki")
    ], mode="Screenshot Mode"),
    Key(hyper,"t",
        lazy.spawn(home + "/Script/add_todo"),
        desc="Add todo task to TODO.MD"),
    Key(hyper,"e",
        lazy.spawn(home + "/Script/config_edit"),
        desc="Confit Edit"),
    Key(hyper,"k",
        lazy.spawn(home + "/Script/kill_process"),
        desc="Confit Edit"),
    Key(hyper,"f",
        lazy.spawn(home + "/Script/search"),
        desc="Search Engine"),
    # Key(hyper,"w",
        # lazy.spawn("alacritty -t \"NOTE\" -e sh -c 'sleep 0.4 && nvim /ext_drive/SynologyDrive/NotesTaking/index.md'"),
        # desc="Notes"),
    #Audio related
    Key([],"XF86AudioPlay",
        lazy.spawn("python " + home + "/Script/mpv_cmus.py pause"),
        desc="Play music or if MPV available, Play it"),
    Key([],"XF86AudioStop",
        lazy.spawn("python " + home + "/Script/mpv_cmus.py stop"),
        desc="Pause music or if MPV available, pause it"),
    Key([],"XF86AudioPrev",
        lazy.spawn("python " + home + "/Script/mpv_cmus.py prev"),
        desc="Previous music or if MPV available, Previous video"),
    Key([],"XF86AudioNext",
        lazy.spawn("python " + home + "/Script/mpv_cmus.py next"),
        desc="Next music or if MPV available, Next video"),
    Key([],"XF86AudioMute",
        lazy.spawn("/usr/bin/pulseaudio-ctl mute"),
        desc="Mute audio"),
    Key([],"XF86AudioRaiseVolume",
        lazy.spawn("/usr/bin/pulseaudio-ctl up"),
        desc="Raise audio volume"),
    Key([],"XF86AudioLowerVolume",
        lazy.spawn("/usr/bin/pulseaudio-ctl down"),
        desc="Lower audio volume"),
    Key(["shift"],"XF86AudioRaiseVolume",
        lazy.spawn("cmus-remote --volume +5%"),
        desc="Raise cmus volume"),
    Key(["shift"],"XF86AudioLowerVolume",
        lazy.spawn("cmus-remote --volume -5"),
        desc="Lower cmus volume"),

    Key(sup, "Tab",
        lazy.next_layout(),
        desc='Toggle through layouts'
        ),
    Key(super_shift,"Tab",
        lazy.prev_layout(),
        desc='Toggle through previous layout'),
    Key(super_shift, "c",
        lazy.window.kill(),
        desc='Kill active window'
        ),
    Key(super_shift, "r",
        lazy.restart(),
        desc='Restart Qtile'
        ),
    Key(super_shift, "q",
        lazy.shutdown(),
        desc='Shutdown Qtile'
        ),
    ### Switch focus to specific monitor (out of fourth)
    Key(sup, "q",
        lazy.to_screen(3),
        desc='Keyboard focus to monitor 1'
        ),
    Key(sup, "w",
        lazy.to_screen(0),
        desc='Keyboard focus to monitor 2'
        ),
    Key(sup, "e",
        lazy.to_screen(1),
        desc='Keyboard focus to monitor 3'
        ),
    Key(sup, "r",
        lazy.to_screen(2),
        desc='Keyboard focus to monitor 4'
        ),
    ### Switch focus of monitors
    Key(sup, "period",
        lazy.next_screen(),
        desc='Move focus to next monitor'
        ),
    Key(sup, "comma",
        lazy.prev_screen(),
        desc='Move focus to prev monitor'
        ),

    ### Go to next unused group
    Key(sup,"bracketleft",
        lazy.function(custom_switch_group,"h"),
        desc="Move to previous unused group"),
    Key(sup,"bracketright",
        lazy.function(custom_switch_group,"l"),
        desc="Move to next unused group"),



# ┌───────────────────────────────────────────────────────────────────────────┐
# │                                  Window                                   │
# └───────────────────────────────────────────────────────────────────────────┘

    #Window focus key hjkl
    Key(sup,"h",
        lazy.function(custom_focus,"h"),
        desc="Focus left of current window"),
    Key(sup,"j",
        lazy.function(custom_focus,"j"),
        desc="Focus down of current window"),
    Key(sup,"k",
        lazy.function(custom_focus,"k"),
        desc="Focus up of current window"),
    Key(sup,"l",
        lazy.function(custom_focus,"l"),
        desc="Focus right of current window"),

    #Swap window around
    Key(super_shift,"h",
        lazy.function(custom_swap,"h"),
        desc="Swap to left of current window"),

    Key(super_shift,"j",
        lazy.function(custom_swap,"j"),
        desc="Swap to down of current window"),

    Key(super_shift,"k",
        lazy.function(custom_swap,"k"),
        desc="Swap to up of current window"),

    Key(super_shift,"l",
        lazy.function(custom_swap,"l"),
        desc="Swap to right of current window"),

    #Send window to new screen
    Key(super_alt,"h",
        lazy.function(custom_send,"h"),
        desc="Send window to left screen"),
    Key(super_alt,"j",
        lazy.function(custom_send,"j"),
        desc="Send window to down screen"),
    Key(super_alt,"k",
        lazy.function(custom_send,"k"),
        desc="Send window to up screen"),
    Key(super_alt,"l",
        lazy.function(custom_send,"l"),
        desc="Send window to right screen"),

    #Resize Window #as far as I can see, it only affect MonadTall and Tile?
    Key(super_ctrl,"h",
        lazy.layout.shrink_main(),#Make sense since, right is shrinking to left
        desc="Grow master pane"),
    Key(super_ctrl,"j",
        lazy.layout.grow(),
        desc="Grow down of current window"),
    Key(super_ctrl,"k",
        lazy.layout.shrink(),
        desc="Grow up of current window"),
    Key(super_ctrl,"l",
        lazy.layout.grow_main(), #make sense since to growing to right
        desc="Grow right of current window"),
    Key(sup, "n",
        lazy.layout.normalize(),
        desc='normalize window size ratios'
        ),
    Key(super_ctrl,"n",
        lazy.layout.reset(),
        desc="Reset it looks"),
    Key(super_ctrl, "m",
        lazy.layout.maximize(),
        desc='toggle window between minimum and maximum sizes'
        ),
    Key(super_ctrl,"r",
        lazy.layout.rotate(), #Stack
        lazy.layout.flip(), #Monotall, maybe tile?
        desc="Rotate layout"),
    Key(super_ctrl,"Return", #Stack only 
        lazy.layout.toggle_split(),
        desc="Split stack"),
    Key(super_shift, "f",
        lazy.window.toggle_floating(),
        desc='toggle floating'
        ),
    Key(super_shift, "m",
        lazy.window.toggle_fullscreen(),
        desc='toggle fullscreen'
        ),
    #Send Window to Screen
]#End of keys array


# ┌───────────────────────────────────────────────────────────────────────────┐
# │                                   GROUP                                   │
# └───────────────────────────────────────────────────────────────────────────┘

group_names = [("|1|MAIN", {'layout': 'monadtall'}),
               ("|2|DEV", {'layout': 'monadtall'}),
               ("|3|SYS", {'layout': 'monadtall'}),
               ("|4|DOC", {'layout': 'monadtall',"matches":[
                   Match(wm_class="Zathura"),
                   Match(wm_class="cherrytree"),
               ]}),
               ("|5|VBOX", {'layout': 'monadtall'}),
               ("|6|CHAT", {'layout': 'monadtall',"matches":[
                   Match(wm_class="lightcord"),
               ],#End of Match
                            }),#end of |6| CHAT
               ("|7|MUS", {'layout': 'monadtall'}),
               ("|8|VID", {'layout': 'monadtall',"matches":[
                    Match(wm_class="mpv"),
                    Match(wm_class="vlc"),
               ]}),
               ("|9|Game", {'layout': 'monadtall'}),
               ]

groups = [Group(name, **kwargs) for name, kwargs in group_names]

for i, (name, kwargs) in enumerate(group_names, 1):
    keys.append(Key(sup, str(i), lazy.group[name].toscreen()))        # Switch to another group
    keys.append(Key(super_shift, str(i), lazy.window.togroup(name))) # Send current window to another group

# ┌───────────────────────────────────────────────────────────────────────────┐
# │                             Group ScratchPad                              │
# └───────────────────────────────────────────────────────────────────────────┘

groups.append(
               ScratchPad("scratchpad",[
                   DropDown("cmus",f"{myTerm} -e cmus"),
                   DropDown("taskerwarrior",f"{myTerm}",height = 0.7,width = 0.5,opacity = 1,y = 0.2,x = 0.2),
                   DropDown("anime",f"{myTerm} -t \"ANIME\" -e trackma",height = 0.7,width = 0.5,opacity = 1,y = 0.2,x = 0.2),
                   DropDown("notes",f"{myTerm} -t \"NOTE\" -e sh -c 'sleep 0.4 && nvim /ext_drive/SynologyDrive/NotesTaking/index.md'",height = 1, opacity=1)
                   #more Dropdown
               ]))
keys.append(Key(sup,"F11",
                lazy.group["scratchpad"].dropdown_toggle("cmus")))
keys.append(Key(hyper,"w",
                lazy.group["scratchpad"].dropdown_toggle("notes")))
keys.append(Key(hyper,"a",
                lazy.group["scratchpad"].dropdown_toggle("anime")))
keys.append(Key(hyper,'Return',
                lazy.group["scratchpad"].dropdown_toggle("taskerwarrior")))

# ┌───────────────────────────────────────────────────────────────────────────┐
# │                                  Layout                                   │
# └───────────────────────────────────────────────────────────────────────────┘

layout_theme = {"border_width": 2,
                "margin": 8,
                "border_focus": "e1acff",
                "border_normal": "1D2330"
                }

layouts = [
    #layout.MonadWide(**layout_theme),
    #layout.Bsp(**layout_theme),
    #layout.Stack(stacks=2, **layout_theme),
    # layout.Columns(**layout_theme),
    #layout.RatioTile(**layout_theme),
    #layout.VerticalTile(**layout_theme),
    # layout.Matrix(**layout_theme),
    #layout.Zoomy(**layout_theme),
    layout.MonadTall(**layout_theme),
    layout.Max(**layout_theme),
    # layout.Tile(shift_windows=True, **layout_theme),
    layout.Stack(num_stacks=2),
    layout.TreeTab(
        font = "Ubuntu",
        fontsize = 10,
        sections = ["FIRST", "SECOND"],
        section_fontsize = 11,
        bg_color = "141414",
        active_bg = "90C435",
        active_fg = "000000",
        inactive_bg = "384323",
        inactive_fg = "a0a0a0",
        padding_y = 5,
        section_top = 10,
        panel_width = 100
    ),
    layout.Floating(**layout_theme)
]

colors = [["#282c34", "#282c34"], # panel background
          ["#3d3f4b", "#434758"], # background for current screen tab
          ["#ffffff", "#ffffff"], # font color for group names
          ["#ff5555", "#ff5555"], # border line color for current tab
          ["#74438f", "#74438f"], # border line color for 'other tabs' and color for 'odd widgets'
          ["#4f76c7", "#4f76c7"], # color for the 'even widgets'
          ["#e1acff", "#e1acff"]] # window name

prompt = "{0}@{1}: ".format(os.environ["USER"], socket.gethostname())

##### DEFAULT WIDGET SETTINGS #####
widget_defaults = dict(
    font="Ubuntu Mono",
    fontsize = 12,
    padding = 2,
    background=colors[2]
)
extension_defaults = widget_defaults.copy()


def create_widiget_list(ignore = []):
    """
    Function: create widiget list
    """

    widget_collections = [
        widget.Image(
            filename = "~/.config/qtile/icons/python-white.png",
            scale = "False",
            mouse_callbacks = {'Button1': lambda: qtile.cmd_spawn(myTerm)}
        ),
        widget.Sep(
            linewidth = 0,
            padding = 6,
            foreground = colors[2],
            background = colors[0]
        ),
        widget.AGroupBox(
            font = "Ubuntu Bold",
            fontsize = 9,
            margin_y = 2,
            margin_x = 0,
            padding_y = 5,
            padding_x = 3,
            borderwidth = 0,
            foreground = colors[2],
            background = colors[4],
        ),
        widget.Sep(
            linewidth = 0,
            padding = 2,
            foreground = colors[2],
            background = colors[0]
        ),
        widget.GroupBox(
            font = "Ubuntu Bold",
            fontsize = 9,
            margin_y = 3,
            margin_x = 0,
            padding_y = 5,
            padding_x = 3,
            borderwidth = 3,
            active = colors[2],
            inactive = colors[2],
            rounded = False,
            highlight_color = colors[1],
            highlight_method = "line",
            this_current_screen_border = colors[6],
            this_screen_border = colors [4],
            other_current_screen_border = colors[6],
            other_screen_border = colors[4],
            foreground = colors[2],
            background = colors[0],
            use_mouse_wheel = False,
            disable_drag = True,
        ),
        widget.Sep(
            linewidth = 0,
            padding = 6,
            foreground = colors[2],
            background = colors[0]
        ),
        # widget.TaskList(
            # background=colors[0],
            # foreground = colors[6],
            # max_title_width = 100,
        # ),
        widget.Prompt(
            prompt = prompt,
            font = "Ubuntu Mono",
            padding = 10,
            foreground = colors[3],
            background = colors[1]
        ),
        widget.Sep(
            linewidth = 0,
            padding = 40,
            foreground = colors[2],
            background = colors[0]
        ),
        widget.WindowName(
            foreground = colors[6],
            background = colors[0],
            padding = 0
        ),
        widget.Systray(
            background = colors[0],
            padding = 5
        ),
        widget.Sep(
            linewidth = 0,
            padding = 6,
            foreground = colors[0],
            background = colors[0]
        ),
        
        widget.Chord(
            foreground = colors[2],
            background = colors[3]
        ),
        #Pattern begin here
        "PATTERN",
        widget.Net(
            # interface = "enp6s0",
            format = '{down} ↓↑ {up}',
            foreground = colors[2],
            background = colors[4],
            padding = 5
        ),
        [widget.TextBox(
            text = " 🌡",
            padding = 2,
            foreground = colors[2],
            background = colors[5],
            fontsize = 11
        ),
        widget.ThermalSensor(
            foreground = colors[2],
            background = colors[5],
            threshold = 90,
            padding = 5
        )],
        widget.CheckUpdates(
            update_interval = 1800,
            distro = "Arch_checkupdates",
            display_format = "⟳ {updates} Updates",
            mouse_callbacks = {'Button1': lambda: qtile.cmd_spawn(myTerm + ' -e sudo pacman -Syu')},
            background = colors[4],
            foreground = colors[2],
        ),
        [widget.TextBox(
            text = " 🖬",
            foreground = colors[2],
            background = colors[5],
            padding = 0,
            fontsize = 14
        ),
        widget.Memory(
            foreground = colors[2],
            background = colors[5],
            mouse_callbacks = {'Button1': lambda: qtile.cmd_spawn(myTerm + ' -e htop')},
            padding = 5
        )],
        widget.CPU(
            foreground = colors[2],
            background = colors[4],
        ),
        [widget.TextBox(
            text = " Vol:",
            foreground = colors[2],
            background = colors[5],
            padding = 0
        ),
        widget.Volume(
            foreground = colors[2],
            background = colors[5],
            padding = 5
        )],
        [widget.CurrentLayoutIcon(
            custom_icon_paths = [os.path.expanduser("~/.config/qtile/icons")],
            foreground = colors[0],
            background = colors[4],
            padding = 0,
            scale = 0.7
        ),
        widget.CurrentLayout(
            foreground = colors[2],
            background = colors[4],
            padding = 5
        )],
        widget.Clock(
            foreground = colors[2],
            background = colors[5],
            format = "%A, %B %d - %I:%M %p "
        ),
    ]

    text_box_split = "ﳣ" 
    widget_list = []
    run_pattern = False
    for i, ele in enumerate(widget_collections):
        if i in ignore: continue
        if ele == "PATTERN": 
            run_pattern = True
            continue
        if run_pattern:
            #Alt odd/event
            if isinstance(ele,list): fg = ele[1].background
            else: fg = ele.background
            t = widget.TextBox(
                text = text_box_split,
                background = colors[0],
                foreground = fg,
                padding = 0,
                fontsize = 37,
            )
            widget_list.append(t)
        #Since we can make a list to put together a "one widget" its for patterns dont mix up
        if isinstance(ele,list):
            widget_list.extend(ele)
        else:
            widget_list.append(ele)
    return widget_list
#end of the function create widiget list

def init_primary_widget():
    widgets_screen1 = create_widiget_list()
    return widgets_screen1

def init_secondary_widget():
    widgets_screen1 = create_widiget_list()
    # del widgets_screen1[6:7]               # Slicing removes unwanted widgets (systray)
    return widgets_screen1                 # Monitor 2 will display all widgets in widgets_list

def init_screens():
    return [Screen(top=bar.Bar(widgets=init_secondary_widget(), opacity=1.0, size=20)),
            Screen(top=bar.Bar(widgets=init_secondary_widget(), opacity=1.0, size=20)),
            Screen(top=bar.Bar(widgets=init_secondary_widget(), opacity=1.0, size=20)),
            Screen(top=bar.Bar(widgets=init_primary_widget(), opacity=1.0, size=20))]

if __name__ in ["config", "__main__"]:
    screens = init_screens()
    # widgets_list = init_widgets_list()
    # widgets_screen1 = init_widgets_screen1()
    # widgets_screen2 = init_widgets_screen2()

mouse = [
    Drag(sup, "Button1", lazy.window.set_position_floating(),
         start=lazy.window.get_position()),
    Drag(sup, "Button3", lazy.window.set_size_floating(),
         start=lazy.window.get_size()),
    Click(sup, "Button2", lazy.window.bring_to_front())
]

dgroups_key_binder = None
dgroups_app_rules = []  # type: List
main = None
follow_mouse_focus = False
bring_front_click = False
cursor_warp = False

floating_layout = layout.Floating(float_rules=[
    # Run the utility of `xprop` to see the wm class and name of an X client.
    # default_float_rules include: utility, notification, toolbar, splash, dialog,
    # file_progress, confirm, download and error.
    *layout.Floating.default_float_rules,
    Match(title='Confirmation'),  # tastyworks exit box
    Match(title='Qalculate!'),  # qalculate-gtk
    Match(wm_class='kdenlive'),  # kdenlive
    Match(wm_class='pinentry-gtk-2'),  # GPG key password entry
    Match(wm_class="org.gnome.clocks"), #clocks
    Match(wm_class="feh"), #feh
    Match(wm_class="flameshot"), #flameshot
])
auto_fullscreen = True
focus_on_window_activation = "smart"
# focus_on_window_activation = "focus"

# @hook.subscribe.startup_once
# def start_once():
    # home = os.path.expanduser('~')
    # subprocess.call([home + '/.startup_script'])


# XXX: Gasp! We're lying here. In fact, nobody really uses or cares about this
# string besides java UI toolkits; you can see several discussions on the
# mailing lists, GitHub issues, and other WM documentation that suggest setting
# this string if your java app doesn't work correctly. We may as well just lie
# and say that we're a working one by default.
#
# We choose LG3D to maximize irony: it is a 3D non-reparenting WM written in
# java that happens to be on java's whitelist.
WMNAME = "LG3D"
