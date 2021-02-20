diff=$1
dID=$(bspc query -D --desktop --names);
#diD=${dID:0:1};
bspc node -d ${dID:0:1}$(($((${dID:1}+$diff))%3)) --follow;

