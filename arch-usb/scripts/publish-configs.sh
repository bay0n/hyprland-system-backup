#!/usr/bin/env bash
set -Eeuo pipefail

repo=${1:-}
script_dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
project_dir=$(cd -- "$script_dir/../.." && pwd)
if [[ ! $repo =~ ^[A-Za-z0-9_.-]+/[A-Za-z0-9_.-]+$ ]]; then
    printf 'Usage: %s OWNER/PRIVATE_REPO\n' "$0" >&2
    exit 2
fi

if ! command -v gh >/dev/null 2>&1 || ! gh auth status >/dev/null 2>&1; then
    printf 'Authenticate first with: gh auth login --hostname github.com\n' >&2
    exit 1
fi
if ! gh repo view "$repo" --json isPrivate --jq '.isPrivate' | grep -qx true; then
    printf 'Repository %s must exist and be private. Create an empty private repository first.\n' "$repo" >&2
    exit 1
fi

gh auth setup-git
cd "$project_dir"
"$script_dir/backup-home-state.sh"
if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    if [[ -d .git ]] && [[ -z $(find .git -mindepth 1 -print -quit 2>/dev/null) ]]; then
        chmod u+w .git
        rmdir .git
    fi
    git init -b main
fi

if git remote get-url origin >/dev/null 2>&1; then
    git remote set-url origin "https://github.com/$repo.git"
else
    git remote add origin "https://github.com/$repo.git"
fi

git add \
    .gitignore README.md \
    arch-usb backup dms scripts \
    hypridle.conf hyprland.lua hyprlock.conf hyprpaper.conf xdg-portal-init.sh
if ! git diff --cached --quiet; then
    if ! git config user.name >/dev/null; then
        read -r -p 'Git commit name: ' commit_name
        git config user.name "$commit_name"
    fi
    if ! git config user.email >/dev/null; then
        read -r -p 'Git commit email: ' commit_email
        git config user.email "$commit_email"
    fi
    git commit -m 'Add Hyprland configuration and Arch USB installer'
fi
git branch -M main
git push --set-upstream origin main
printf '\nPublished configs to https://github.com/%s\n' "$repo"
