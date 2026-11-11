#!/bin/bash

set -euo pipefail

addr=$(hyprctl activewindow -j | jq -r '.address // empty')
[ -n "$addr" ] || exit 0

state_file="${XDG_RUNTIME_DIR:-/tmp}/hypr-opacity-${addr#0x}"
window="address:$addr"

set_opacity() {
    local value="$1"

    hyprctl dispatch "hl.dsp.window.set_prop({ prop = \"opacity_override\", value = \"true\", window = \"$window\" })"
    hyprctl dispatch "hl.dsp.window.set_prop({ prop = \"opacity\", value = \"$value\", window = \"$window\" })"
    hyprctl dispatch "hl.dsp.window.set_prop({ prop = \"opacity_inactive_override\", value = \"true\", window = \"$window\" })"
    hyprctl dispatch "hl.dsp.window.set_prop({ prop = \"opacity_inactive\", value = \"$value\", window = \"$window\" })"
}

if [ -f "$state_file" ]; then
    set_opacity "0.85"
    rm -f "$state_file"
else
    set_opacity "1.0"
    : > "$state_file"
fi
