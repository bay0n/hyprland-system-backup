#!/bin/bash
set -u

sleep 1
for portal in hyprland gnome kde lxqt wlr; do
    pkill -x "xdg-desktop-portal-$portal" 2>/dev/null || true
done
pkill -x xdg-desktop-portal 2>/dev/null || true
sleep 1
[ -x /usr/lib/xdg-desktop-portal-hyprland ] && /usr/lib/xdg-desktop-portal-hyprland &
sleep 2
[ -x /usr/lib/xdg-desktop-portal ] && /usr/lib/xdg-desktop-portal &
