# The Sway configuration file in ~/.config/sway/config calls this script.
# You should see changes to the status bar after saving this script.
# If not, do "killall swaybar" and $mod+Shift+c to reload the configuration.

# Produces "21 days", for example
uptime_formatted=$(uptime | cut -d ',' -f1  | cut -d ' ' -f4,5)

# The abbreviated weekday (e.g., "Sat"), followed by the ISO-formatted date
# like 2018-10-06 and the time (e.g., 14:01)
date_formatted=$(date "+%a %F %I:%M:%S")

ram=$(free -m | grep Mem | awk {'printf("%s/%s - %s%",$3,$2,int(($3/$2)*100))'})

# Emojis and characters for the status bar
echo "Mem" $ram "| Uptime:" $uptime_formatted ↑ $date_formatted
