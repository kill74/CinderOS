# CinderOS

CinderOS 1.0.0 "Ember" is a personal Arch Linux ISO profile for a desktop workstation. It is built around COSMIC, Btrfs, PipeWire, zram, AppArmor, Steam/Wine tooling, and a small set of maintenance commands.

The goal is simple: a useful Arch-based install image with sane defaults, low idle noise, and recovery tools available before the system is trusted as a daily driver.

## Status

This repository is ready for build and VM testing. It is not something to install over a working OS until the checklist in [DAILY_DRIVER.md](DAILY_DRIVER.md) has been completed.

Current validation passes on this checkout:

```bash
bash scripts/release-check.sh
```

Package verification, ISO build, and install QA still need an Arch host with `pacman`, `archiso`, and QEMU.

## Who It Is For

- Desktop users who want an Arch-based workstation profile with COSMIC by default.
- Gaming and development machines with AMD or Intel graphics.
- Users who want Btrfs snapshots, AppArmor, UFW, zram, and basic system checks available from day one.
- People who prefer heavier services to be opt-in instead of running by default.

NVIDIA packages are included, but AMD and Intel are the main daily-driver target for this pass. NVIDIA installs need extra testing around kernel updates, suspend, and Wayland.

## What Is Included

- COSMIC Wayland session with XFCE Lite available as a lower-resource session.
- Linux Zen as the default kernel and Linux LTS as a fallback.
- Btrfs install layout, Snapper, grub-btrfs, Btrfs Assistant, and btrfsmaintenance.
- PipeWire, NetworkManager, UFW, AppArmor, zram, earlyoom, power profiles, and switcheroo.
- Steam, Wine, GameMode, MangoHud, Vulkan tools, and 32-bit graphics libraries.
- Kitty, zsh, starship, zoxide, eza, bat, ripgrep, fd, fzf, btop, fastfetch, lazygit, GitHub CLI, tmux, and Neovim.
- CinderOS Settings plus `cinder-*` maintenance commands for hardware checks, memory profiles, security checks, snapshots, updates, session choice, and appearance setup.

## Off By Default

These packages may be present, but their services are not enabled during the default install:

- Docker
- Bluetooth
- CUPS printing
- fwupd
- SSH and fail2ban
- USBGuard
- ClamAV daemons
- auditd
- Snapper timers and Btrfs maintenance timers
- Flathub setup

Enable only what the machine actually needs from CinderOS Settings or the matching command-line tool.

## Build Requirements

Build on an Arch-based host:

```bash
sudo pacman -Syu archiso git
```

Recommended for AUR package work:

```bash
sudo pacman -S base-devel devtools
```

Recommended for ISO smoke tests:

```bash
sudo pacman -S qemu-full edk2-ovmf
```

## Build

From this folder:

```bash
bash scripts/release-check.sh
bash scripts/build-iso.sh
```

The build script uses:

- Work directory: `/tmp/cinderos-work`
- Output directory: `$HOME/cinderos-out`
- ISO filename target: `cinderos-1.0.0-x86_64.iso`

Direct ArchISO command:

```bash
sudo mkarchiso -v -w /tmp/cinderos-work -o "$HOME/cinderos-out" .
```

After building:

```bash
bash scripts/qemu-smoke.sh
```

## Daily Driver Checklist

Before replacing another OS:

```bash
cinder-doctor
sudo cinder-snapshot setup
sudo cinder-snapshot create
cinder-snapshot list
sudo cinder-update
sudo grub-mkconfig -o /boot/grub/grub.cfg
```

Then confirm:

- External backup and restore media work.
- A VM install has completed.
- GRUB shows snapshot entries.
- Linux Zen boots.
- Linux LTS boots.
- A rollback path has been tested in a VM.

See [DAILY_DRIVER.md](DAILY_DRIVER.md), [QA_CHECKLIST.md](QA_CHECKLIST.md), and [RELEASE.md](RELEASE.md) before using it on real hardware.

## Useful Commands

```bash
cinder-control
cinder-welcome commands
cinder-doctor
sudo cinder-update
cinder-memory status
cinder-memory low-idle
cinder-security status
cinder-security harden
sudo cinder-snapshot setup
cinder-session-mode cosmic
cinder-session-mode lite
cinder-tune balanced
```

## AUR Packages

`packages.x86_64` contains packages that pacman can resolve during `mkarchiso`.

`packages.aur` lists packages that need a separate AUR flow, such as VS Code, Zed, Helium, Proton GE, Bottles, and Heroic. Build those packages in a clean chroot and expose them through a local repo, or install them after setup with `paru`.

## Current Limits

- Package verification must run on an Arch host with pacman.
- AUR packages are not installed by `mkarchiso` unless they are first built into a custom repo.
- Full install testing still needs a VM or physical machine.
- Daily-driver use still requires a tested external backup, restore media, first update, Linux LTS boot, and rollback path.
- Secure Boot tooling is included, but key creation and enrollment stay manual.
- USBGuard stays disabled until a policy is reviewed and enabled by the user.

Known gaps are tracked in [KNOWN_ISSUES.md](KNOWN_ISSUES.md).

## Repository Layout

- `profiledef.sh` - ArchISO profile metadata and build settings.
- `packages.x86_64` - pacman package list for the ISO.
- `packages.aur` - AUR package list to prebuild or install after setup.
- `pacman.conf` - build-time pacman config with multilib and CachyOS repos enabled.
- `airootfs/` - root filesystem overlay copied into the live ISO.
- `scripts/` - build, validation, package-check, and smoke-test helpers.
- `grub/` - live ISO GRUB configuration.
- `efiboot/` - notes for future EFI-specific boot work; GRUB is active today.

## Live User

The live ISO creates a `cinder` user with passwordless sudo for testing and installation. Root login is locked.

Installed systems remove the live sudo rule and use normal privilege prompts.
