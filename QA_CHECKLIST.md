# QA Checklist

Use this checklist before calling an ISO ready for sharing.

## Live Boot

- Boot the ISO in QEMU with UEFI.
- Boot the ISO in QEMU with BIOS when possible.
- Confirm the live user reaches the desktop without manual login.
- Open CinderOS Settings from the first-run prompt.
- Confirm the installer launcher appears in the live session.
- Confirm networking works and mirrors can be refreshed.
- Confirm audio devices appear through PipeWire.
- Confirm shutdown and reboot complete cleanly.

## Installer

- Run a Btrfs erase-disk install.
- Run a manual partitioning install.
- Run a LUKS2 encrypted install.
- Test swap choices: none, swapfile, partition, and zram where available.
- Confirm the installed system boots through GRUB.
- Confirm GRUB exposes Linux LTS after `sudo grub-mkconfig -o /boot/grub/grub.cfg`.
- Confirm live-only sudo and installer launchers are removed after install.
- Confirm installed login uses `greetd`.

## CinderOS Settings

- Open Start, Status, System, Appearance, Memory, Services, Security, Session, Games, Backups, and About.
- Confirm `--page welcome`, `--page appearance`, `--page rice`, `--page backups`, and `--page snapshots` open the expected pages.
- Confirm Status shows live/installed mode, session mode, memory state, firewall/AppArmor state, and snapshot state.
- Confirm terminal actions open and leave readable output.

## Hardware

- Run `sudo cinder-hardware-setup` on AMD graphics.
- Run `sudo cinder-hardware-setup` on Intel graphics.
- Run `sudo cinder-hardware-setup` on NVIDIA graphics.
- Confirm vendor-specific environment settings are only written for detected hardware.
- Confirm Vulkan tools run on each graphics path.

## Desktop

- Confirm COSMIC starts and uses the CinderOS wallpaper.
- Confirm XFCE Lite can be selected through `cinder-session-mode lite`.
- Confirm Kitty, Starship, Fastfetch, btop, and GTK settings use the CinderOS appearance defaults.
- Confirm Steam opens.
- Confirm MangoHud and GameMode are installed.

## Security And Backups

- Run `cinder-doctor`.
- Run `cinder-security status`.
- Run `sudo cinder-security harden`.
- Confirm SSH and fail2ban stay off until enabled.
- Confirm USBGuard stays off until a policy is reviewed and enabled.
- Run `sudo cinder-snapshot setup` on a Btrfs install.
- Create and list a manual snapshot.
- Confirm grub-btrfs entries appear after snapshot setup.
- Run `sudo cinder-update` after snapshot setup.
- Reboot into Linux Zen and Linux LTS.
- Test at least one rollback path in a VM.

## Daily Driver Readiness

- Confirm an external backup exists.
- Confirm restore media boots and can see the backup.
- Confirm the first installed update was run with `sudo cinder-update`.
- Confirm `cinder-doctor` has no unresolved warnings.

## Release Evidence

- Save the ISO filename, build date, package verification result, QEMU boot result, install result, and checksum in release notes.
- Update `KNOWN_ISSUES.md` with anything still untested.
