# Changelog

## 1.0.0 Ember (Bugfix)

- Fixed: `cinder-hardware-setup --user` no longer crashes when NVIDIA is detected (tried to write to `/etc/` without root).
- Fixed: `cinder-control-center` now has `set -euo pipefail` for consistent error handling.
- Fixed: `cinder-clean` properly quotes orphan package list to avoid empty argument.
- Fixed: `cinder-restore` now uses the `root` Snapper config explicitly.

## 1.0.0 Ember

- Built the ArchISO profile around COSMIC, XFCE Lite, Btrfs, PipeWire, zram, earlyoom, UFW, and AppArmor.
- Added Calamares configuration for Btrfs installs and post-install live-session cleanup.
- Added CinderOS Settings for installer access, status badges, diagnostics, hardware checks, memory modes, services, security, sessions, games, backups, and appearance.
- Added a Dev page for full-stack tools, Docker, databases, project folders, and local personal backups.
- Expanded the Games page around Steam/Proton, GameMode, overlays, controllers, Vulkan/OpenGL checks, and audio status.
- Added command-line tools for memory modes, diagnostics reports, security checks, Secure Boot preparation, sandbox helpers, Btrfs snapshots, session switching, daily-driver checks, update staging, and mirror refresh.
- Added `cinder-dev`, `cinder-game-check`, and `cinder-personal` for coding checks, game checks, and local dotfile restore.
- Added a hardware matrix for AMD, Intel, and NVIDIA release evidence.
- Added release evidence capture and firmware-aware QEMU smoke options.
- Added Linux LTS packages as a fallback kernel alongside the default Linux Zen path.
- Kept NVIDIA module settings out of global boot defaults; hardware-specific NVIDIA settings are written only after detection.
- Added validation scripts for package placement, profile structure, security defaults, appearance assets, and high-risk configuration mistakes.
- Kept Docker, Bluetooth, printing, fwupd, SSH, USBGuard, ClamAV daemons, auditd, Flathub, and snapshot timers manual by default.
- Added QA, daily-driver, and release checklists plus a release-check script for repeatable pre-release validation.
