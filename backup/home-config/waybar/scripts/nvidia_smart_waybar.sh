#!/bin/bash
# Read the raw info from your system or existing script, stripping out Polybar tags
# If the original script outputs "--__--", we will show a clean fallback text or nothing.

raw_output=$(~/.config/polybar/nvidia_smart.sh 2>/dev/null)

# Strip out Polybar text formatting %{F#...} and %{F-}
clean_output=$(echo "$raw_output" | sed -e 's/%{F#[^}]*}//g' -e 's/%{F-}//g')

# If the script is outputting broken placeholder underscores, replace it with something clean
if [[ "$clean_output" == *"-__-"* || -z "$clean_output" ]]; then
    echo "-__- "
else
    echo "󰍛 $clean_output"
fi
