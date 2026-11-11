#!/bin/bash

if [ "$1" == "Quiet" ]; then
    asusctl profile set Quiet
elif [ "$1" == "next" ]; then
    asusctl profile next
fi

sleep 0.1
profile=$(asusctl profile get | grep 'Active profile' | awk '{print $3}')

case "$profile" in
    "Quiet")
        nvidia-settings -a "[gpu:0]/GPUPowerMizerMode=2" > /dev/null 2>&1
        echo "<span color='#a6e3a1'>●</span>"
        ;;
    "Performance")
        nvidia-settings -a "[gpu:0]/GPUPowerMizerMode=1" > /dev/null 2>&1
        echo "<span color='#f38ba8'>●</span>"
        ;;
    "Balanced")
        nvidia-settings -a "[gpu:0]/GPUPowerMizerMode=0" > /dev/null 2>&1
        echo "<span color='#cba6f7'>●</span>"
        ;;
    *)
        echo "● $profile"
        ;;
esac
