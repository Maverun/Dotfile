#!/bin/bash


#This is for go next desktop within same monitor

diff=$1; # 1 = left, 2 = right
dID=$(bspc query -D --desktop --names);

#diD=${dID:0:1};
bspc desktop -f ${dID:0:1}$(($((${dID:1}+$diff))%3))

