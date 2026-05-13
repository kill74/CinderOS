# QA Checklist

- Boot the ISO with UEFI and BIOS where possible.
- Confirm the live user reaches the desktop.
- Open CinderOS Settings and check Start, Status, Appearance, Memory, Security, Session, Games, Backups, and About.
- Run a Btrfs erase-disk install.
- Test manual partitioning and LUKS2 before release.
- Confirm installed boot through GRUB and login through `greetd`.
- Confirm Linux LTS appears in GRUB and boots.
- Check AMD, Intel, and NVIDIA graphics paths separately.
- Run `cinder-doctor`, `sudo cinder-snapshot setup`, `sudo cinder-update`, and one rollback test in a VM.
- Confirm audio, networking, Steam, snapshots, shutdown, and reboot.
- Record skipped checks in `KNOWN_ISSUES.md`.
