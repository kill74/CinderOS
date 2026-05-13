# Daily Driver Checklist

CinderOS can be used like a normal Arch workstation, but do not replace a working OS until recovery has been tested. The target path for this release is AMD or Intel graphics, Btrfs, snapshots, and normal `pacman` updates through `cinder-update`.

## Before Install

- Make an external backup of personal files.
- Boot the backup or restore media and confirm it can see the backup drive.
- Build and validate the ISO on an Arch host:

```bash
bash scripts/release-check.sh
bash scripts/verify-arch-packages.sh
```

- Run a VM install with Btrfs before installing on the real machine.
- Keep a second working USB installer or rescue ISO nearby.

## First Boot

Run these on the installed system before moving your main files over:

```bash
cinder-doctor
sudo cinder-hardware-setup
cinder-memory status
cinder-security status
```

Fix warnings from `cinder-doctor` before treating the install as trusted.

## Backups And Rollback

Set up snapshots and prove they are visible from the boot menu:

```bash
sudo cinder-snapshot setup
sudo cinder-snapshot create
cinder-snapshot list
sudo grub-mkconfig -o /boot/grub/grub.cfg
```

Reboot and confirm GRUB shows snapshot entries. Do a rollback test in a VM before relying on this path on the real machine.

## Kernel Fallback

The ISO includes `linux-zen` and `linux-lts`. After install:

```bash
pacman -Q linux-zen linux-lts
ls /boot/vmlinuz-linux-zen /boot/vmlinuz-linux-lts
sudo grub-mkconfig -o /boot/grub/grub.cfg
```

Reboot once into the default kernel and once into Linux LTS before calling the install ready.

## First Update

Run the first update through CinderOS:

```bash
sudo cinder-update
```

This creates a pre-update snapshot when Snapper is configured, runs `pacman -Syu`, rebuilds GRUB when available, and runs `cinder-doctor` afterward.

## Stop Criteria

Do not replace the current OS if any of these are still untested:

- External restore path.
- VM install.
- Btrfs snapshot creation.
- GRUB snapshot entries.
- Boot into Linux LTS.
- First update through `cinder-update`.
- Rollback path in a VM.
