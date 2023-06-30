
# Goal is to move them while keeping focused on them

focusedWindow=$(swaymsg -t get_tree | jq -j '.. | select(.type?) | select(.focused) | (.id)')
echo $focusedWindow

sway move container to output $1
swaymsg "[con_id=$focusedWindow]" focus
