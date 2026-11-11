#!/bin/bash

SSID=$(iwgetid -r 2>/dev/null)
SIGNAL=$(iwconfig wlan0 2>/dev/null | awk -F'=' '/Signal level/ {print $3}' | awk '{print $1}')

if [ -z "$SSID" ]; then
    printf '{"text":"󰖪","class":"disconnected","tooltip":false}\n'
else
    printf '{"text":"󰖩","class":"connected","tooltip":false}\n'
fi
