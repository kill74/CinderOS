# Known Issues

- Build and package verification require an Arch-based host.
- AUR packages must be built into a local repo before `mkarchiso`, or installed after setup with `paru`.
- Full install testing should cover live boot, Btrfs erase-disk install, manual partitioning, LUKS2, UEFI, BIOS, and installed login.
- AMD, Intel, and NVIDIA graphics paths need separate hardware checks.
- Daily-driver use should be limited to installs with tested backup, Linux LTS boot, first update, and rollback.
- NVIDIA installs need extra testing around kernel updates, suspend, and Wayland before daily use.
- Secure Boot enrollment and USBGuard enablement are manual steps.
