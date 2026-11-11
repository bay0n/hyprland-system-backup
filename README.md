# Hyprland config and Arch USB installer

This folder contains the current Hyprland setup and a reusable Arch Linux installer. The installer boots from an ArchISO USB with a black and mauve Catppuccin Mocha inspired dialog theme, lets you choose the target drive, asks you to set the `bayon` account password, offers an app checklist, and restores this repository into `~/.config/hypr`. It also restores the selected shell, Waybar, terminal, Rofi, and Waypaper configs; DankMaterialShell settings and plugin preferences; and the wallpaper library.

Hyprland settings live in `hyprland.lua`. The Lua files under `dms/` are generated and managed by DMS. `hypridle.conf`, `hyprlock.conf`, and `hyprpaper.conf` belong to those separate programs, which read their own config formats. The old alternate Hyprland configs are archived under `arch-usb/legacy/` and are not installed.

## Back up and publish this config to GitHub

1. Install and authenticate GitHub CLI: `sudo pacman -S github-cli && gh auth login`.
2. Create an **empty private repository** on GitHub.
3. From this folder, run `./arch-usb/scripts/publish-configs.sh OWNER/REPO`. It refreshes `backup/` from the current home directory, stages the Hyprland installer/config and selected home state, then pushes to the private repo.

The backup script excludes browser profiles, SSH keys, app databases, and general personal files. It strips credential-like fields from DMS plugin settings and removes inline API-token lines from `.bashrc`. Review `backup/` before publishing. Keep the repo private: wallpapers add around 160 MB. The installer later asks for a GitHub token with read access to this private repository; the token is held only in memory while the config is fetched.

The backup includes `~/.config/dms` preferences and plugin lockfile. DMS plugin code is fetched at the pinned revisions listed in that lockfile when DMS restores plugins. `dux-shell` is installed as the DMS shell package.

## Personal files to back up separately

Copy `Documents/`, `Pictures/` (outside `wallpapers/`), `Videos/`, `Music/`, project folders, game saves (`.minecraft`, `.factorio`, `.steam`, `Games/`), browser profiles, and any files in `Downloads/` that matter to an encrypted external drive. Do not put browser profiles, `.ssh`, `.gnupg`, `.config/gh`, `.codex`, or app data into this GitHub repo. Reinstall Flatpak apps and sign into apps again after setup; their local data is not part of this backup.

## Build the ISO

On Arch Linux, install ArchISO and build tools:

```sh
sudo pacman -S archiso sudo
./arch-usb/scripts/build-iso.sh
```

The image is written to `arch-usb/out/`. The profile uses ArchISO's releng profile and boots to the installer automatically on tty1. The installer requires UEFI boot, Secure Boot disabled, and internet access. It uses `iwctl` for Wi-Fi setup in the live environment and configures NetworkManager to use iwd in the installed system.

## Write the ISO to a USB drive

For Ventoy, copy the ISO file into the USB's large data partition; do not use an image writer, which would erase Ventoy. Boot the destination PC from that USB in UEFI mode and select the ISO in Ventoy's menu.

## Installation behavior

- Select the destination disk from a device list. The installer excludes removable disks such as the Ventoy USB and asks you to confirm the erase.
- Set and confirm the new `bayon` password.
- Choose apps for this PC from a categorized checklist. Hyprland's core desktop is installed automatically; the curated app catalog is based on applications found among this machine's explicitly installed packages and its Flatpak apps. Firefox, FireDragon, Steam, Zed, Spotify, Impala, and Bluetui are preselected and can be toggled for each install.
- Enter the private GitHub repository as `OWNER/REPO` and provide a read-only token. Neither password nor token is saved to the ISO.
- The target is partitioned with a 1 GiB EFI system partition and an ext4 root partition. It installs GRUB with the Matrix Morpheus theme from `Matrix-Morpheus-GRUB-Theme` and enables SDDM, NetworkManager, iwd, and Bluetooth.
- Mesa graphics support is installed by default. Intel, AMD, and NVIDIA GPUs are detected for their Vulkan drivers; NVIDIA uses the open kernel driver. Steam enables multilib and installs the matching 32-bit graphics libraries.

The installer log is available at `/tmp/arch-usb-installer.log` in the live session. If installation stops, the root shell remains available on tty1; rerun it with `arch-usb-installer` after fixing the reported issue.
