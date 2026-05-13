# Changelog

## 1.0.0 Ember

- Built the ArchISO profile around COSMIC, XFCE Lite, Btrfs, PipeWire, zram, earlyoom, UFW, and AppArmor.
- Added Calamares configuration for Btrfs installs and post-install live-session cleanup.
- Added CinderOS Settings for installer access, hardware checks, memory profiles, services, security, sessions, games, backups, and appearance.
- Added command-line tools for memory profiles, security checks, Secure Boot preparation, sandbox helpers, Btrfs snapshots, session switching, daily-driver checks, update staging, and mirror refresh.
- Added Linux LTS packages as a fallback kernel alongside the default Linux Zen path.
- Kept NVIDIA module settings out of global boot defaults; hardware-specific NVIDIA settings are written only after detection.
- Added validation scripts for package placement, profile structure, security defaults, appearance assets, and high-risk configuration mistakes.
- Kept Docker, Bluetooth, printing, fwupd, SSH, USBGuard, ClamAV daemons, auditd, Flathub, and snapshot timers manual by default.
- Added QA, daily-driver, and release checklists plus a release-check script for repeatable pre-release validation.
