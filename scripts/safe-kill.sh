#!/bin/bash
# ~/.config/hypr/scripts/safe-kill.sh
set -euo pipefail

excluded=( "dev.zed.Zed" "spotify" "discord" "blueman-blueman-applet")
active_class=$(hyprctl activewindow -j | jq -r '.class // empty')
[ -n "$active_class" ] || exit 0

for c in "${excluded[@]}"; do
    if [[ "$active_class" == "$c" ]]; then
        hyprctl dispatch 'hl.dsp.window.move({ workspace = "special:minimized", follow = false })'
        exit 0
    fi
done

hyprctl dispatch 'hl.dsp.window.close()'
