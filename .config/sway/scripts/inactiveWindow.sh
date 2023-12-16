#!/usr/bin/sh

# HDMI-A-1 Right Monitor
# DP-1 Middle Monitor
# DP-2 Left Monitor
# DP-3 Top Monitor

# Default all monitor connecting.
notify-send "Changing window mode"
if [[ $1 == "4Monitor" ]]; then
	sway output HDMI-A-1 enable 
	sway output DP-1 enable 
	sway output DP-2 enable 
	sway output DP-3 enable 
# Bottom monitor only, happen when top monitor using phone connect.
elif [[ $1 == "3Monitor" ]]; then
	sway output HDMI-A-1 enable 
	sway output DP-1 enable 
	sway output DP-2 enable 
	sway output DP-3 disable 
# One monitor, work usually or need for gw2 when other are busy.	
elif [[ $1 == "1Monitor" ]]; then
	sway output HDMI-A-1 disable 
	sway output DP-1 enable 
	sway output DP-2 disable 
	sway output DP-3 disable 
fi

notify-send "Changing monitor setting"
sh ~/Script/monitorSet
