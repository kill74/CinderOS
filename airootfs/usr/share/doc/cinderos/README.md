# CinderOS

**An Arch Linux install image built for a trusted desktop workstation.**

CinderOS is an opinionated ArchISO profile designed around COSMIC, Btrfs, PipeWire, zram, AppArmor, full-stack development tools, gaming support, and a suite of maintenance commands. The goal is simple: an Arch install you can actually trust, with sensible defaults, recovery tools close at hand, and heavier services left off until they're needed.

⚠️ **Pre-Production**: Ready for build and VM testing. Not yet ready for production use on real hardware.

- **Version**: 1.0.0 "Ember"
- **Target Hardware**: AMD and Intel systems (safest for daily driver); NVIDIA packages included but experimental

## What's Inside

- **Desktop**: COSMIC Wayland as the primary desktop environment, with an XFCE Lite option available.
- **Core Technologies**: Btrfs filesystem with Snapper for automated snapshots and rollback, Linux Zen kernel, zram, and AppArmor.
- **Batteries Included**: 330+ pacman packages including a full development stack (Node, Python, Rust, Go) and gaming support (Steam, Proton, Wine, MangoHud).
- **Opt-In Philosophy**: Background services like Docker, databases, Bluetooth, and SSH are installed but disabled by default to keep idle RAM usage low.
- **CinderOS Toolkit**: 37 custom command-line tools (e.g., `cinder-doctor`, `cinder-update`, `cinder-snapshot`, `cinder-control`) for easy system management and diagnostics.

## Quick Start (Build & Test)

Build on an Arch-based host with `archiso` and `git`:

```bash
# Install dependencies
sudo pacman -Syu archiso git base-devel devtools qemu-full edk2-ovmf

# Validate profile
bash scripts/release-check.sh

# Build ISO (Output: $HOME/cinderos-out/cinderos-1.0.0-x86_64.iso)
bash scripts/build-iso.sh

# Smoke test (UEFI)
bash scripts/qemu-smoke.sh --firmware uefi
```

## Documentation Hub

For detailed information, please refer to our dedicated documentation files:

| Document | Purpose |
|----------|---------|
| [DAILY_DRIVER.md](DAILY_DRIVER.md) | Pre-production deployment checklist |
| [HARDWARE_MATRIX.md](HARDWARE_MATRIX.md) | AMD/Intel/NVIDIA test tracking |
| [KNOWN_ISSUES.md](KNOWN_ISSUES.md) | Open blockers and experimental features |
| [CHANGELOG.md](CHANGELOG.md) | Version history |
| [QA_CHECKLIST.md](QA_CHECKLIST.md) | Quality assurance procedures |
| [RELEASE.md](RELEASE.md) | Release process documentation |
| [NOTES.md](NOTES.md) | Developer notes and context |

## Repository Quick Reference

- `airootfs/` — Live ISO filesystem overlay (system configs, custom commands in `usr/local/bin/`)
- `scripts/` — Build and validation helper scripts
- `profiledef.sh` & `pacman.conf` — ArchISO profile metadata and package configurations
- `packages.x86_64` & `packages.aur` — Package manifests
