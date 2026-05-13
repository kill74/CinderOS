# CinderOS

CinderOS 1.0.0 "Ember" is an Arch Linux ISO profile for personal gaming and development workstations.

It includes COSMIC, XFCE Lite, Btrfs, PipeWire, zram, earlyoom, UFW, AppArmor, Steam, Wine, Vulkan tooling, Linux LTS as a fallback kernel, and CinderOS maintenance commands. Docker, Bluetooth, printing, fwupd, SSH, USBGuard, ClamAV daemons, auditd, Flathub, and snapshot timers stay manual by default.

Useful commands:

```bash
cinder-control
cinder-welcome commands
cinder-doctor
sudo cinder-update
cinder-memory status
cinder-security status
cinder-snapshot setup
```

Release and QA notes are included in:

- `/usr/share/doc/cinderos/QA_CHECKLIST.md`
- `/usr/share/doc/cinderos/RELEASE.md`
- `/usr/share/doc/cinderos/DAILY_DRIVER.md`
