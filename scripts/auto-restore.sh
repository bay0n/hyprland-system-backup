#!/bin/bash
# ~/.config/hypr/scripts/auto-restore.sh

set -euo pipefail

socket="$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock"
[ -S "$socket" ] || exit 0

socat -U - "UNIX-CONNECT:${socket}" | while read -r line; do
    if [[ "$line" == activewindow\>\>* ]]; then
        ws=$(hyprctl activewindow -j | jq -r '.workspace.name')
        addr=$(hyprctl activewindow -j | jq -r '.address')
        if [[ "$ws" == "special:minimized" ]]; then
            current_ws=$(hyprctl activeworkspace -j | jq -r '.id')
            hyprctl dispatch "hl.dsp.window.move({ workspace = ${current_ws}, follow = true, window = \"address:${addr}\" })"
        fi
    fi
done
