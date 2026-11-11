#!/bin/bash

# First arg is passed to brightnessctl
brightnessctl set "$1" >/dev/null

# Get laptop brightness %
LAPTOP=$(brightnessctl -m | awk -F, '{gsub("%","",$4); print $4}')

# Scale for Dell using a gamma curve
DELL=$(awk "BEGIN {
    x=$LAPTOP/100;
    y=(x^0.8)*100;
    printf \"%d\", y
}")

# Clamp to valid range
if [ "$DELL" -gt 100 ]; then
    DELL=100
elif [ "$DELL" -lt 0 ]; then
    DELL=0
fi

# Set Dell brightness
ddcutil --bus=1 setvcp 10 "$DELL" >/dev/null 2>&1
