# Changelog

## 1.0.0 Ember

- Built the ArchISO profile around COSMIC, XFCE Lite, Btrfs, PipeWire, zram, earlyoom, UFW, and AppArmor.
- Added Calamares configuration for Btrfs installs and post-install live-session cleanup.
- Added CinderOS Settings and command-line tools for setup, memory, services, security, sessions, backups, games, appearance, daily-driver checks, and staged updates.
- Added Linux LTS packages as a fallback kernel alongside the default Linux Zen path.
- Kept NVIDIA module settings out of global boot defaults; hardware-specific NVIDIA settings are written only after detection.
- Added validation scripts for profile structure, security defaults, package placement, and appearance assets.
- Kept heavier services manual by default.
- Added QA, daily-driver, and release notes for repeatable validation.
