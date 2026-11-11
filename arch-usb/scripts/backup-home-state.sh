#!/usr/bin/env bash
set -Eeuo pipefail

project_dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/../.." && pwd)
backup_dir="$project_dir/backup"
source_home=${HOME:?HOME is not set}

rm -rf "$backup_dir/home-config" "$backup_dir/dms" "$backup_dir/wallpapers"
mkdir -p "$backup_dir/home-config" "$backup_dir/dms" "$backup_dir/wallpapers"

# Keep the personal shell setup and only the desktop apps used by this config.
for file in .bash_profile .profile .Xresources .gtkrc-2.0 .xprofile .fehbg .xbindkeysrc; do
    [[ -f "$source_home/$file" ]] && install -m 0644 "$source_home/$file" "$backup_dir/home-config/$file"
done
if [[ -f "$source_home/.bashrc" ]]; then
    # The current bashrc has inline API credentials; keep the aliases but strip those lines.
    sed -E '/(CODEX_AUTH_TOKEN|sk-proj-)/d' "$source_home/.bashrc" > "$backup_dir/home-config/.bashrc"
    chmod 0644 "$backup_dir/home-config/.bashrc"
fi
for dir in waybar kitty ghostty rofi waypaper; do
    [[ -d "$source_home/.config/$dir" ]] && cp -a "$source_home/.config/$dir" "$backup_dir/home-config/"
done

# DMS shell preferences, bar layout, plugin enablement/settings and plugin lockfile.
# Remove credential-like fields recursively before anything enters the repository.
for file in settings.json monitors.json plugin_settings.json plugins.lock.json clsettings.json; do
    [[ -f "$source_home/.config/dms/$file" ]] || continue
    jq 'walk(if type == "object" then with_entries(select(.key | test("(token|password|secret|api.?key|private.?key)"; "i") | not)) else . end)' \
        "$source_home/.config/dms/$file" > "$backup_dir/dms/$file"
done
find "$source_home/.config/dms/plugins" -maxdepth 1 -type f -name '*.meta' -exec cp -a -t "$backup_dir/dms" -- {} + 2>/dev/null || true

# Preserve every wallpaper and animated wallpaper in the configured library.
if [[ -d "$source_home/Pictures/wallpapers" ]]; then
    cp -a "$source_home/Pictures/wallpapers/." "$backup_dir/wallpapers/"
fi

printf 'Backed up desktop state to %s\n' "$backup_dir"
printf 'Review it before publishing: wallpaper library is large and the repo should be private.\n'
