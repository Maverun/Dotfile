from hyprpy import Hyprland
from hyprpy.utils.shell import run_or_fail
import requests
import subprocess
import json
import csv

instance = Hyprland()


openlinkhud_post = "curl -X POST http://127.0.0.1:27003/api/{param} --silent | jq"

def mouse_profile_change(name):
    json_data = {"deviceId":"5D095A562BF9582B", "userProfileName": name}
    # return f"curl -X POST http://127.0.0.1:27003/api/userProfile/change -d '{json.dumps(json_data)}' --silent | jq"
    return ["curl", f"-X POST http://127.0.0.1:27003/api/userProfile/change -d '{json.dumps(json_data)}' --silent | jq"]

def read():
    with open('/home/maverun/Script/mouse_profile.json', mode='r') as jsonfile:
        data = json.load(jsonfile)
    print(data)
    return data

# print(mouse_profile_change("gw2"))
# MOUSE_PROFILE_SETTINGS = {
#         "gw2-64.exe": "gw2",
#         "OxygenNotIncluded": "oni",
#         }

MOUSE_PROFILE_SETTINGS = read()
#
focused_window = None

# Fetch active window and display information:
window = instance.get_active_window()
print(window.wm_class)
print(window.width)
print(window.position_x)


# Print information about the windows on the active workspace
workspace = instance.get_active_workspace()
for window in workspace.windows:
    print(f"{window.address}: {window.title} [{window.wm_class}]")


# Get the resolution of the first monitor
monitor = instance.get_monitor_by_id(0)
if monitor:
    print(f"{monitor.width} x {monitor.height}")


# Get all windows currently on the special workspace
special_workspace = instance.get_workspace_by_name("special")
if special_workspace:
    special_windows = special_workspace.windows
    for window in special_windows:
        print(window.title)


# Show a desktop notification every time we switch to workspace 6
from hyprpy.utils.shell import run_or_fail

def on_workspace_changed(sender, **kwargs):
    workspace_id = kwargs.get('workspace_id')
    if workspace_id == 6:
        run_or_fail(["notify-send", "We are on workspace 6."])

def active_window(sender, **kwargs):
    MOUSE_PROFILE_SETTINGS = read()
    print(kwargs)
    window_class = kwargs["window_class"]
    window_title = kwargs["window_title"]
    target = MOUSE_PROFILE_SETTINGS.get(window_class, "default")
    target2 = MOUSE_PROFILE_SETTINGS.get(window_title, "default")
    print(target,target2)
    if target == "default" and target2 != "default":
        print("is under statement")
        target = target2
    print(f"Target is {target}")

    json_data = {"deviceId":"5D095A562BF9582B", "userProfileName": target}
    try:
        res = requests.post("http://127.0.0.1:27003/api/userProfile/change", json=json_data, timeout=1)
        print(res)
    except Exception as e:
        print(e)



instance.signals.workspacev2.connect(on_workspace_changed)
instance.signals.activewindow.connect(active_window)
instance.watch()
