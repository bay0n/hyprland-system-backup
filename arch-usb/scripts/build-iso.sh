#!/usr/bin/env bash
set -Eeuo pipefail

script_dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
project_dir=$(cd -- "$script_dir/.." && pwd)
profile_dir="$project_dir/profile"
out_dir=${1:-"$project_dir/out"}
work_dir="${TMPDIR:-/tmp}/hyprarch-build-${UID}"

if [[ $EUID != 0 ]] && ! command -v sudo >/dev/null 2>&1; then
    printf 'Install archiso and sudo first: sudo pacman -S archiso sudo\n' >&2
    exit 1
fi
command -v mkarchiso >/dev/null 2>&1 || {
    printf 'mkarchiso is missing. Install archiso: sudo pacman -S archiso\n' >&2
    exit 1
}

mkdir -p "$out_dir" "$work_dir"
if [[ $EUID == 0 ]]; then
    mkarchiso -v -w "$work_dir" -o "$out_dir" "$profile_dir"
else
    sudo mkarchiso -v -w "$work_dir" -o "$out_dir" "$profile_dir"
    sudo chown -R "$(id -u):$(id -g)" "$out_dir"
fi
printf '\nISO image created in: %s\n' "$out_dir"
