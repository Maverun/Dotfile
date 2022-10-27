# -*- coding: utf-8 -*-
from logging import currentframe
import os
import time
# import re
import socket
# import subprocess
from libqtile.config import Click, Drag, Group, KeyChord, Key, Match, Screen, ScratchPad, DropDown
from libqtile import qtile
from libqtile.command import lazy
from libqtile import layout, bar, widget, hook,extension
from libqtile.lazy import lazy
from typing import List  # noqa: F401
from libqtile.log_utils import logger
from datetime import datetime 
from tkinter import Tk
import json 
# myTerm = "alacritty"                             # My terminal of choice
myTerm = "kitty -o allow_remote_control=yes --single-instance --listen-on unix:@mykitty"                             # My terminal of choice
defaultTerm = 'kitty'


#monitor position, you can find order by xrandr --listactivemonitors    
monitor_position = [[-1, 2,-1],#top
                    [ 3, 0, 1]]#middle
startUPQtile = datetime.now()
#Tokyonight colors, I like those.
colors = {
    'bg_dark' : "#1f2335",
    'bg' : "#24283b",
    'bg_highlight' : "#292e42",
    'terminal_black' : "#414868",
    # 'fg' : "#c0caf5",
    'fg' : '#ffffff',
    'fg_dark' : "#a9b1d6",
    'fg_gutter' : "#3b4261",
    'dark3' : "#545c7e",
    'comment' : "#565f89",
    'dark5' : "#737aa2",
    'blue0' : "#3d59a1",
    'blue' : "#7aa2f7",
    'cyan' : "#7dcfff",
    'blue1' : "#2ac3de",
    'blue2' : "#0db9d7",
    'blue5' : "#89ddff",
    'blue6' : "#B4F9F8",
    'blue7' : "#394b70",
    'magenta' : "#bb9af7",
    'magenta2' : "#ff007c",
    'purple' : "#74438F",
    'orange' : "#ff9e64",
    'yellow' : "#e0af68",
    'green' : "#9ece6a",
    'green1' : "#73daca",
    'green2' : "#41a6b5",
    'teal' : "#1abc9c",
    'red' : "#f7768e",
    'red1' : "#db4b4b",
  }

class Map(dict):
    """dot.notation access to dictionary attributes"""
    def __init__(self, *args, **kwargs):
        super(Map, self).__init__(*args, **kwargs)
        for arg in args:
            if isinstance(arg, dict):
                for k, v in arg.items():
                    self[k] = v

        if kwargs:
            for k, v in kwargs.items():
                self[k] = v

    def __getattr__(self, attr):
        return self.get(attr)

    def __setattr__(self, key, value):
        self.__setitem__(key, value)

    def __setitem__(self, key, value):
        super(Map, self).__setitem__(key, value)
        self.__dict__.update({key: value})

    def __delattr__(self, item):
        self.__delitem__(item)

    def __delitem__(self, key):
        super(Map, self).__delitem__(key)
        del self.__dict__[key]

colors = Map(colors)

def terminal(command,extra = '',default=False):
    term = defaultTerm if default else myTerm
    return f"{term} {extra} -e sh -c 'sleep 0.4 && {command}'"


def debug_qtile(qtile_):
    logger.warning("under debug qtile")
    data = qtile.cmd_windows()
    currentWindow = qtile.current_window
    chatLayout = qtile._select("group","|4|CHAT").layout
    if chatLayout.name == 'stack':
        def move_client(client,n):
            client.focus(True)
            chatLayout.current_stack.remove(client)
            chatLayout.stacks[n].add(client)
            chatLayout.stacks[n].focus(client)
            chatLayout.group.layout_all()
        clientPos = chatLayout.stacks
        for c in clientPos[0].clients:
            if 'Element' in c.name or "weechat" in c.name:
                move_client(c,1)
        for c in clientPos[1].clients:
            if 'Discord' in c.name:
                move_client(c,0)
    # back to where currently window was at before sorting things out.
    currentWindow.focus(True)
    pass
    
    # qtile.cmd_display_kb('mod4')
    # logger.warning(str(qtile.current_layout.clients))
    # logger.warning(json.dumps(qtile.cmd_groups(),indent=3))
    # logger.warning(str(qtile.current_screen.current_layout))


def is_atEdge(qtile,data,name,current,key):
    #if there is screen above or not, if there is none, then always false for jk
    if get_next_screen_index(qtile,key) == -1 and key in 'jk': return False
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
    if is_atEdge(qtile,data,name,current,key) or (name == "max" and key in "hl"):
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
    if is_atEdge(qtile,data,name,current,key) or (name == "max" and key in "hl"):
        return swap_across_screen(qtile,key)
    if name == "stack" and key in "hl":
        #terrible but what choice do we got? but 2 stack is enough
        layout.cmd_client_to_next() 
        #then terrible idea? We shall see
        layout.cmd_up() #focus on other window
        layout.cmd_client_to_previous() #swap back to other stack (new window)
        layout.cmd_next() #now return to main window we original swap
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
    active_win.cmd_toscreen()
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
    #since its not dynamic(well it is kinda, but for now this currently), no need to repeat call it
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

def get_key(k,mod=None,chkey=None):
    #mod and chkey are one that is Keychords 
    if mod is None: 
        mod = ' + '.join(k.modifiers)
    else: mod = 'CHORD: ' + ' + '.join(mod) + f' + {chkey}'
    mod = mod.replace('mod4','super').replace('mod1','alt') #human readable
    return f"'{mod}' {k.key} '{k.desc}' "
        

def list_keyblinds(qtile):
    #This job is print out all current keyblinds i have so i can see them when i need to 
    #thankfully, they Are quite straightforward and easily
    data = ''
    for k in keys: 
        if isinstance(k,Key): data += get_key(k)
        else: 
            for x in k.submappings: 
                data += get_key(x,k.modifiers,k.key) 
            
    qtile.cmd_spawn(f'yad --title="Qtiles Keyblind" --no-buttons --list --grid-lines=both --geometry=1200x800  --expand-column=0 --column="Modifiers" --column="Key" --column="Descriptions" {data}',True)


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
    Key(sup,"slash",lazy.function(list_keyblinds)),
    Key(sup,"z",lazy.display_kb()),
    Key(sup,"o",lazy.run_extension(extension.WindowList())),

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
        desc='Launches My qtile Terminal'
        ),
    Key(sup, "y",
        lazy.spawn("dmenu_run -m 0 -p 'Run: '"),
        # lazy.spawn("rofi -show drun -config ~/.config/rofi/themes/dt-dmenu.rasi -display-drun \"Run: \" -drun-display-format \"{name}\""),
        desc='Run Launcher'
        ),

    #CHORD OF PROGRAM LAUNCHER
    KeyChord(sup,"p",[
            Key([],"f",lazy.spawn("firefox"),lazy.ungrab_chord(), desc="Firefox"),
            Key([],"e",lazy.spawn("thunar"), lazy.ungrab_chord(),desc="Thunar explorer"),
            Key([],"c",lazy.spawn("gnome-clocks"),lazy.ungrab_chord(), desc="Clocks"),
            Key([],"s",lazy.spawn(home + "/Script/shutdownMenu"),lazy.ungrab_chord(), desc="Shutdown Menu"),
            Key([],"l",
                lazy.spawn('rofi -modi run,drun,window -show drun -show-icons -sidebar-mode -kb-mode-next "Alt+Tab"'),
                lazy.ungrab_chord(),
                desc="Rofi Appfinder"),
    #End of CHORD
                ],mode="Program Launcher"),


    #Screenshot modes
    KeyChord(hyper,"s",[
        Key([], "s",
            lazy.spawn("flameshot gui"),
            lazy.ungrab_chord(),
            # lazy.function(lambda x: x.ungrab_chord()),
            desc="Flameshot SS"),
        Key([], "d",
            lazy.function(custom_Screenshot,"/ext_drive/SynologyDrive/vimwiki/Dev/images/",True),
            lazy.ungrab_chord(),
            desc="Flameshot and save files into Dev Diary Vimwiki")
    ], mode="Screenshot Mode"),

    #scripts
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
    Key(hyper,"d",
        lazy.spawn(home + "/Script/dictionary"),
        desc="Define terms"),
    Key(hyper,"r",
        lazy.spawn(home + "/Script/runScript"),
        desc="Run any script."),
    

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
    Key(super_shift,"bracketleft",
        lazy.function(custom_switch_group,"h"),
        desc="Move to previous unused group"),
    Key(super_shift,"bracketright",
        lazy.function(custom_switch_group,"l"),
        desc="Move to next unused group"),



# ┌───────────────────────────────────────────────────────────────────────────┐
# │                                  Window                                   │
# └───────────────────────────────────────────────────────────────────────────┘

    KeyChord(sup,"n",[
        Key([],"h",
            lazy.layout.shrink_main(),#Make sense since, right is shrinking to left
            desc="Grow master pane"),
        Key([],"j",
            lazy.layout.grow(),
            desc="Grow down of current window"),
        Key([],"k",
            lazy.layout.shrink(),
            desc="Grow up of current window"),
        Key([],"l",
            lazy.layout.grow_main(), #make sense since to growing to right
            desc="Grow right of current window"),
        Key([],"n",
            lazy.layout.reset(),
            desc="Reset it looks"),
        Key([], "m",
            lazy.layout.maximize(),
            desc='toggle window between minimum and maximum sizes'
            ),
        Key([],"r",
            lazy.layout.rotate(), #Stack
            lazy.layout.flip(), #Monotall, maybe tile?
            desc="Rotate layout"),
        Key([],"Return", #Stack only 
            lazy.layout.toggle_split(),
            desc="Split stack"),

    ], mode="Resize"),

    KeyChord(sup,'m',[
        Key([],"h",
            lazy.function(custom_send,"h"),
            desc="Send window to left screen"),
        Key([],"j",
            lazy.function(custom_send,"j"),
            desc="Send window to down screen"),
        Key([],"k",
            lazy.function(custom_send,"k"),
            desc="Send window to up screen"),
        Key([],"l",
            lazy.function(custom_send,"l"),
            desc="Send window to right screen"),

        #Swap window around
        Key(['shift'],"h",
            lazy.function(custom_swap,"h"),
            desc="Swap to left of current window"),

        Key(['shift'],"j",
            lazy.function(custom_swap,"j"),
            desc="Swap to down of current window"),

        Key(['shift'],"k",
            lazy.function(custom_swap,"k"),
            desc="Swap to up of current window"),

        Key(['shift'],"l",
            lazy.function(custom_swap,"l"),
            desc="Swap to right of current window"),
    ], mode="Moving"),

    KeyChord(sup,'Escape',[
        Key([],'x',lazy.layout.shrink_main())
    ], mode="test"),
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
    Key(super_ctrl,"h",
        lazy.function(custom_send,"h"),
        desc="Send window to left screen"),
    Key(super_ctrl,"j",
        lazy.function(custom_send,"j"),
        desc="Send window to down screen"),
    Key(super_ctrl,"k",
        lazy.function(custom_send,"k"),
        desc="Send window to up screen"),
    Key(super_ctrl,"l",
        lazy.function(custom_send,"l"),
        desc="Send window to right screen"),

    #Resize Window #as far as I can see, it only affect MonadTall and Tile?
    Key(super_alt,"h",
        lazy.layout.shrink_main(),#Make sense since, right is shrinking to left
        desc="Grow master pane"),
    Key(super_alt,"j",
        lazy.layout.grow(),
        desc="Grow down of current window"),
    Key(super_alt,"k",
        lazy.layout.shrink(),
        desc="Grow up of current window"),
    Key(super_alt,"l",
        lazy.layout.grow_main(), #make sense since to growing to right
        desc="Grow right of current window"),
    # Key(sup, "n",
    #     lazy.layout.normalize(),
    #     desc='normalize window size ratios'
    #     ),
    Key(super_shift, "f",
        lazy.window.toggle_floating(),
        desc='toggle floating'
        ),
    Key(super_shift, "g",
        lazy.window.bring_to_front()(),
        desc='bring window to front.'
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
               ("|4|CHAT", {'layout': 'stack',"matches":[
                   Match(wm_class="lightcord"),
                   Match(wm_class="discord"),
                   Match(wm_class="element"),
                   Match(title="weechat"),
               ],#End of Match
            }),#end of |6| CHAT
               ("|5|Email", {'layout': 'monadtall','matches':[
                   Match(wm_class='Mail'),
                   Match(wm_class='Thunderbird')
    ]}),
               ("|6|DOC", {'layout': 'monadtall',"matches":[
                   Match(wm_class="Zathura"),
                   Match(wm_class="cherrytree"),
               ]}),
               ("|7|Extra", {'layout': 'monadtall',"matches":[
                    Match(wm_class="Lorien")
                ]}),
               ("|8|VID", {'layout': 'monadtall',"matches":[
                    Match(wm_class="mpv"),
                    Match(wm_class="vlc"),
               ]}),
                ("|9|Game", {'layout': 'monadtall', 'matches':[
                    Match(wm_class='Minecraft_*'),
                    Match(wm_class='gw2-64.exe'),
                    Match(title='Godot Engine'),
                 ]}) #end of 9 game.
               ]

groups = [Group(name, **kwargs) for name, kwargs in group_names]

for i, (name, kwargs) in enumerate(group_names, 1):
    keys.append(Key(sup, str(i), lazy.group[name].toscreen(),desc=f"Move to Group {name}"))        # Switch to another group
    keys.append(Key(super_shift, str(i), lazy.window.togroup(name),desc=f"Send Window to Group {name}")) # Send current window to another group

# ┌───────────────────────────────────────────────────────────────────────────┐
# │                             Group ScratchPad                              │
# └───────────────────────────────────────────────────────────────────────────┘

#     Key(hyper, "slash",
#         lazy.spawn(f"zathura {home}/MoonlanderLayout.pdf"),
#         desc='Show keyboard layout'
#         ),
groups.append(
               ScratchPad("scratchpad",[
                   DropDown("cmus",terminal("cmus",default=True)),
                   DropDown("taskerwarrior",f"{defaultTerm}",height = 0.7,width = 0.5,opacity = 1,y = 0.2,x = 0.2),
                   # DropDown("anime",f"{myTerm} -t \"ANIME\" -e trackma",height = 0.7,width = 0.5,opacity = 1,y = 0.2,x = 0.2),
                   DropDown("anime",terminal('trackma','-T "ANIME"',default=True),height = 0.7,width = 0.5,opacity = 1,y = 0.2,x = 0.2),
                   # DropDown("notes",f"{myTerm} -t \"NOTE\" -e sh -c 'sleep 0.4 && nvim /ext_drive/SynologyDrive/NotesTaking/index.md'",height = 1, opacity=1)
                   DropDown("notes",terminal("nvim /ext_drive/SynologyDrive/orgmode/refile.org",'-T "NOTE"',default=True),height = 1, opacity=1,on_focus_lost_hide=False),
                   DropDown("kabmat",terminal("sh -c kabmat",'-T "KABMAT"',default=True),height = 1, opacity=1,on_focus_lost_hide=False),
                   DropDown("MoonlanderLayout",f"zathura {home}/MoonlanderLayout.pdf",height = 1, opacity=1,on_focus_lost_hide=False),
                   #more Dropdown
               ]))

keys.append(Key(hyper,"c",
                lazy.group["scratchpad"].dropdown_toggle("cmus"), desc="Dropdown cmus"))
keys.append(Key(hyper,"slash",
                lazy.group["scratchpad"].dropdown_toggle("MoonlanderLayout"), desc="Dropdown Keyboard Layout"))
keys.append(Key(hyper,"w",
                lazy.group["scratchpad"].dropdown_toggle("notes"), desc="Dropdown Notes"))
keys.append(Key(hyper,"g",
                lazy.group["scratchpad"].dropdown_toggle("kabmat"), desc="Dropdown Kabmat"))
keys.append(Key(hyper,"a",
                lazy.group["scratchpad"].dropdown_toggle("anime"), desc="Dropdown Animes Listing"))
keys.append(Key(hyper,'Return',
                lazy.group["scratchpad"].dropdown_toggle("taskerwarrior"), desc="Dropdown Terminal/TaskWarrior"))

# ┌───────────────────────────────────────────────────────────────────────────┐
# │                                  Layout                                   │
# └───────────────────────────────────────────────────────────────────────────┘

layout_theme = {"border_width": 2,
                "margin": 8,
                "border_focus": colors.teal,
                "border_normal": "1D2330",
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
    layout.Max(
        border_width= 2,
        border_focus= colors.teal,
        border_normal= "1D2330",
    ),
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

prompt = "{0}@{1}: ".format(os.environ["USER"], socket.gethostname())

##### DEFAULT WIDGET SETTINGS #####
widget_defaults = dict(
    font="Ubuntu Mono",
    fontsize = 12,
    padding = 2,
    background= colors.bg,
    foreground = colors.fg,
)
extension_defaults = widget_defaults.copy()


def create_widiget_list(ignore = []):
    """
    Function: create widiget list
    """

    widget_collections = [
        widget.Image(
            filename = "~/.config/qtile/icons/python-teal.png",
            scale = "False",
            mouse_callbacks = {'Button1': lambda: qtile.cmd_spawn(myTerm)}
        ),
        widget.Sep(
            linewidth = 0,
            padding = 2,
            background = colors.teal,
        ),
        widget.AGroupBox(
            font = "Ubuntu Bold",
            fontsize = 9,
            margin_y = 2,
            margin_x = 0,
            padding_y = 5,
            padding_x = 3,
            borderwidth = 0,
            background = colors.blue0,
        ),
        widget.Sep(
            linewidth = 0,
            padding = 2,
            background = colors.teal
        ),
        # widget.Sep(
        #     linewidth = 0,
        #     padding = 6,
        #     background = colors.bg
        # ),
        widget.GroupBox(
            font = "Ubuntu Bold",
            fontsize = 9,
            margin_y = 3,
            margin_x = 0,
            padding_y = 5,
            padding_x = 3,
            borderwidth = 3,
            rounded = False,
            active = colors.comment,#this one is when there is hidden group have window in
            inactive = colors.comment,#no window inside
            block_highlight_text_color = colors.teal, #current group on screen
            highlight_color = colors.bg_dark,
            highlight_method = "line",
            this_current_screen_border = colors.teal,
            this_screen_border = colors.purple,
            other_current_screen_border = colors.teal,
            other_screen_border = colors.purple,
            background = colors.bg,
            use_mouse_wheel = False,
            disable_drag = True,
        ),
        # widget.TaskList(
        #     background=colors.bg,
        #     foreground = colors.teal,
        #     max_title_width = 100,
        # ),
        widget.Prompt(
            prompt = prompt,
            font = "Ubuntu Mono",
            padding = 10,
            foreground = colors.red1,
            background = colors.bg_dark
        ),
        widget.Sep(
            linewidth = 0,
            padding = 40,
            background = colors.bg
        ),
        widget.WindowName(
            foreground = colors.teal,
            background = colors.bg,
            padding = 0
        ),
        widget.Systray(
            background = colors.bg,
            padding = 5
        ),
        widget.Sep(
            linewidth = 0,
            padding = 6,
            foreground = colors.bg,
            background = colors.bg
        ),
        
        widget.Chord(
            chords_colors = {
                                    #background,foreground
                'Program Launcher':(colors.red1,colors.fg),
                "Screenshot Mode":(colors.fg_dark,colors.teal),
                "Resize":(colors.green,colors.bg),
                "Moving":(colors.yellow,colors.bg),
            }#end of dict
        ),
        #Pattern begin here, The moment this seen this,it will start add in sign that separator from other
        "PATTERN",
        widget.CheckUpdates(
            update_interval = 1800,
            distro = "Arch_checkupdates",
            display_format = "⟳ {updates} Updates",
            mouse_callbacks = {'Button1': lambda: qtile.cmd_spawn(myTerm + ' -e sudo pacman -Syu')},
            background = colors.bg,
            foreground = colors.teal,
            colour_have_updates = colors.teal,
            colour_no_updates = colors.teal,
            padding = 5
        ),
        widget.Net(
            # interface = "enp6s0",
            format = '{down} ↓↑ {up}',
            background = colors.bg,
            padding = 5,
            foreground = colors.teal,
        ),
        # [widget.TextBox(
        #     text = " 🌡",
        #     padding = 2,
        #     background = colors.bg,
        #     fontsize = 11,
        #     foreground = colors.teal,
        # ),
        # widget.ThermalSensor(
        #     background = colors.bg,
        #     threshold = 90,
        #     padding = 5,
        #     foreground = colors.teal,
        # )],
        # widget.NvidiaSensors(
        #     background = colors.bg,
        #     format = '{temp}°C|{fan_speed}|{perf}',
        #     foreground = colors.teal,
        # ),
        [widget.TextBox(
            text = " 🖬",
            background = colors.bg,
            padding = 0,
            fontsize = 14,
            foreground = colors.teal,
        ),
        widget.Memory(
            background = colors.bg,
            mouse_callbacks = {'Button1': lambda: qtile.cmd_spawn(myTerm + ' -e htop')},
            padding = 5,
            foreground = colors.teal,
        )],
        widget.CPU(
            background = colors.bg,
            foreground = colors.teal,
            padding = 5,
        ),
        [widget.TextBox(
            text = " Vol:",
            background = colors.bg,
            padding = 0,
            foreground = colors.teal,
        ),
        widget.Volume(
            background = colors.bg,
            padding = 5,
            foreground = colors.teal,
        )],
        [widget.CurrentLayoutIcon(
            custom_icon_paths = [os.path.expanduser("~/.config/qtile/icons")],
            background = colors.bg,
            padding = 0,
            scale = 0.7,
            foreground = colors.teal,
        ),
        widget.CurrentLayout(
            background = colors.bg,
            padding = 5,
            foreground = colors.teal,
        )],
        widget.Clock(
            background = colors.bg,
            format = "%A, %B %d - %I:%M %p ",
            foreground = colors.teal,
            padding = 5,
        ),
    ]

    t = widget.Sep(
        foreground = colors.teal,
        padding = 0,
        linewidth=2,
        size_percent = 100
    )
    # text_box_split = "ﳣ"
    widget_list = []
    run_pattern = False
    for i, ele in enumerate(widget_collections):
        # if i in ignore: continue
        if any(isinstance(ele,ignoreItem) for ignoreItem in ignore): continue
        if ele == "PATTERN": 
            run_pattern = True
            continue
        if run_pattern:
            #Alt odd/event
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
    widgets_screen1 = create_widiget_list([widget.Systray])
    # del widgets_screen1[6:7]               # Slicing removes unwanted widgets (systray)
    return widgets_screen1                 # Monitor 2 will display all widgets in widgets_list

def init_screens():
    #they are kinda based of monitor position, can find more info about this at top of this files
    return [Screen(top=bar.Bar(widgets=init_secondary_widget(), opacity=1.0, size=20,border_width=1,border_color = colors.teal)),
            Screen(top=bar.Bar(widgets=init_secondary_widget(), opacity=1.0, size=20,border_width=1,border_color = colors.teal)),
            Screen(top=bar.Bar(widgets=init_secondary_widget(), opacity=1.0, size=20,border_width=1,border_color = colors.teal)),
            Screen(top=bar.Bar(widgets=init_primary_widget(), opacity=1.0, size=20,border_width=1,border_color = colors.teal))]


# @hook.subscribe.enter_chord
# def enterChord(name):
    
#     logger.warning("hello")
#     logger.warning(name)
#     logger.warning(colors[2])

@hook.subscribe.client_new
def client_new(client):
    logger.warning("under client new")
    logger.warning(client)
    logger.warning(client.name)
    # logger.warning(client.info())
    currentTime = datetime.now()
    if (currentTime - startUPQtile ).total_seconds() <= 60:
        killClient = ['Clocks','KDE Connect']
        data = qtile.cmd_windows()
        #we are killing client that come with startup, we need them to run in the background..
        #idk if there is a better way than this but eh.
        client_list_toKill = [x['id'] for x  in data if x['name'] in killClient]
        for wid in client_list_toKill:
            # wid = [x for x in data if x['name'] == client][0]['id']
            qtile.windows_map.get(wid).kill()

        #i want to make discord/element/weechat in correct order
        #left side of stack should be discord only, and right side of stack should only have weechat and element.
        currentWindow = qtile.current_window
        chatLayout = qtile._select("group","|4|CHAT").layout
        if chatLayout.name == 'stack':
            def move_client(client,n):
                client.focus(True)
                chatLayout.current_stack.remove(client)
                chatLayout.stacks[n].add(client)
                chatLayout.stacks[n].focus(client)
                chatLayout.group.layout_all()
            chatLayout.focus_first()
            clientPos = chatLayout.stacks
            for c in clientPos[0].clients:
                if 'Element' in c.name or "weechat" in c.name:
                    move_client(c,1)
            for c in clientPos[1].clients:
                if 'Discord' in c.name:
                    move_client(c,0)
        # back to where currently window was at before sorting things out.
        currentWindow.focus(True)


@hook.subscribe.client_name_updated
def client_name_update(client):
    if client.name == 'weechat': 
        logger.warning("moving weechat to |4|CHAT")
        client.togroup("|4|CHAT")
        client.focus(False)
        client.group.layout.cmd_client_to_stack(1)
        # client.group.layout.layout_all()

    # logger.warning('under the updated client')
    # logger.warning(client)
    # logger.warning(client.name)
    # logger.warning(json.dumps(qtile.cmd_groups(),indent=2))

# @hook.subscribe.startup_complete
# def afterStartup():
#   pass

# @hook.subscribe.client_focus
# def focusClient(w):
#     logger.warning("there is change of focus and that window is ")
#     logger.warning(w)

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
    Match(wm_class="yad"), #yad dialog
    Match(title="Godot Engine"), #Burrito as a godot engine...
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
