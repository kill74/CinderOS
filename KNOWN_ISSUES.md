# Known Issues

These are the current checks to finish before treating an ISO as releasable.

## Build Host

- Build and package verification require an Arch-based host.
- `scripts/verify-arch-packages.sh` needs pacman sync databases and will not run on a Windows-only host.

## AUR Packages

- `packages.aur` is not consumed directly by `mkarchiso`.
- Build those packages in a clean chroot and serve them from a local repo, or install them after setup with `paru`.

## Install QA

Test these paths in a VM before publishing an ISO:

- Live boot to COSMIC.
- Btrfs erase-disk install.
- Manual partitioning.
- LUKS2 encryption.
- GRUB install on UEFI and BIOS.
- Installed login through `greetd`.
- Post-install cleanup of live-only sudo and installer launchers.
- First update through `sudo cinder-update`.
- Booting both Linux Zen and Linux LTS.
- Snapshot entries visible from GRUB after `sudo cinder-snapshot setup`.

## Hardware QA

- Test AMD, Intel, and NVIDIA graphics paths separately.
- Confirm `cinder-hardware-setup` does not write vendor-specific settings for hardware that is not present.
- Treat AMD and Intel graphics as the daily-driver target for this pass.
- NVIDIA installs need extra testing around kernel updates, suspend, and Wayland before daily use.

## Daily Driver QA

- External backup and restore media must be tested before replacing another OS.
- Rollback must be tested in a VM before relying on it on a real machine.
- `cinder-doctor` warnings should be resolved before moving personal files onto the install.

## Manual Security Steps

- Secure Boot key creation and enrollment are intentionally manual.
- USBGuard should not be enabled until its generated policy has been reviewed.
