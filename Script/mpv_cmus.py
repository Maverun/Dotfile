import subprocess
import json
import sys

args = sys.argv[1:] # we dont want file name, just rest of args
def call(cmd): # we calling to command, shortcut
    print(cmd)
    p = subprocess.Popen(cmd,stdout=subprocess.PIPE,shell=True)
    o,e = p.communicate()
    return o.decode()

file_data = call("ls /tmp/mpvSockets/")
file_data = file_data.split()
call(f"notify-send {args[0]}")
if len(file_data) == 0:
    # call(f"cmus-remote --{args[0]}")
    call(f"playerctl {args[0]}")
else: # from here, we will deal with MPV now...
    print(file_data[0])
    cmd = {"play-pause":'["cycle","pause"]',"stop":'["quit"]'}
    socat = f"socat - /tmp/mpvSockets/{file_data[0]}"
    c = cmd.get(args[0])
    if c:
        x = call('echo \'{ "command": ' + c + '}\' |' + socat)
    else:
        file = call('echo \'{ "command": ["get_property","path"] }\' |' + socat)
        data = json.loads(file)  # convert to dict

        # we are spliting from path and filename,
        # so last one will generate saying 2nd element is file
        path = data["data"].rsplit("/",1)
        # now we will look for file, they will show in order list of video
        # this way, we can just do index +- 1 for next/prev files
        x = call(f"ls -p \"{path[0]}\"| grep -e .mkv -e.mp4")
        print(x)
        x = x.split("\n")
        i = x.index(path[1])  # index
        step = 1 if args[0] == "next" else -1  # step for next/prev files
        if len(x) <= i + step or i + step < 0: exit(0)
        video = f"{path[0]}/{x[i + step]}"
        print(video)
        file = call('echo \'{ "command": ["quit"] }\' |' + socat)
        #  check = call(f"mpv -fs --slang=en --sid=1 --alang=jp  \"{video}\" &")
        check = call(f"mpv -fs --sid=1  \"{video}\" &")
