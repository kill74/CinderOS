# CinderOS Build Notes

## Hardware

The profile includes AMD, Intel, and NVIDIA userspace packages. NVIDIA support uses `nvidia-dkms` because the primary kernel is `linux-zen`.

Both `amd-ucode` and `intel-ucode` are included. The GRUB entries load both microcode images so the correct one can apply on matching hardware.

## Kernel Command Line

Default:

```text
quiet splash amd_pstate=active mitigations=auto threadirqs nohz=on rcu_nocbs=all nowatchdog
lsm=landlock,lockdown,yama,integrity,apparmor,bpf audit=1
```

For non-AMD systems, `amd_pstate=active` is harmless but unnecessary. If you decide to ship separate Intel and AMD boot entries later, split the command line in `grub/grub.cfg`.

## AUR and COSMIC

Current Arch Extra provides the COSMIC desktop packages used by this profile, so COSMIC stays in `packages.x86_64`. `packages.aur` is reserved for packages that still need a separate AUR build or post-install path.

If pacman cannot resolve COSMIC during `mkarchiso`, either:

1. Move COSMIC package names out of `packages.x86_64`.
2. Build them into a local custom repo.
3. Add that custom repo to `pacman.conf`.

## Calamares

The Calamares files now include a branded installer shell, slideshow, Btrfs mount profile, unpackfs config, display manager config, service enabling, and post-install cleanup. Before shipping an ISO, test installation paths for:

- Btrfs erase-disk install.
- Btrfs manual partitioning.
- LUKS2 encryption.
- Swapfile and zram choices.
- GRUB install on UEFI and BIOS.

## Live vs Installed Behavior

The live ISO auto-starts COSMIC as the `cinder` user so the user can immediately test hardware and launch the installer. During install, `shellprocess@cinderos-post` removes live-only installer launchers and passwordless sudo, then switches `greetd` to the installed greeter config.

## User Experience

The default environment is meant to feel complete on first boot:

- First-run welcome opens once per user.
- `cinder-control` opens CinderOS Settings for setup, memory, services, sessions, games, backups, and appearance.
- `cinder-tune` exposes performance, low-idle balanced, and quiet profiles.
- `cinder-memory` exposes zram, earlyoom, pressure, service status, and low-idle/gaming/dev memory presets.
- `cinder-security` exposes firewall, AppArmor, Secure Boot, LUKS, audit, scanner, USBGuard, SSH, and CVE status.
- `cinder-secureboot` guides sbctl key creation, signing, verification, and explicit enrollment.
- `cinder-sandbox` provides opt-in Firejail/Bubblewrap wrappers for selected apps.
- `cinder-session-mode` switches the default login between COSMIC and XFCE Lite.
- `cinder-hardware-setup` detects GPU vendors and writes only matching environment overrides.
- `cinder-snapshot` configures Snapper, snap-pac, grub-btrfs, btrfs-assistant, and btrfsmaintenance for optional Btrfs recovery.
- Kitty, starship, zoxide, eza, bat, btop, fastfetch, GTK dark settings, and user directories are preconfigured in `/etc/skel`.
- COSMIC portals, power profiles, switcheroo, PipeWire, NetworkManager, UFW, AppArmor, zram, and earlyoom are enabled.
- Docker, Bluetooth, printing, fwupd, Flatpak setup, SSH, USBGuard, ClamAV daemons, fail2ban, auditd, and snapshot timers are opt-in for lower idle RAM.

## Low-Idle RAM

CinderOS targets a 16 GB personal workstation that should stay light at idle:

- `/etc/systemd/zram-generator.conf` creates compressed zram swap with `zram-size = min(ram / 2, 8192)`.
- `/etc/default/earlyoom` protects the desktop from hard freezes without using systemd-oomd.
- `/etc/sysctl.d/80-cinderos-memory.conf` uses high zram-friendly swappiness, `page-cluster=0`, and lower VFS cache pressure.
- `/etc/systemd/system-preset/90-cinderos-low-idle.preset` records the intended enabled/disabled service policy.
- `/tmp` stays disk-backed by default so large builds, downloads, and game files do not eat RAM.

## Balanced Security

CinderOS security defaults block common workstation mistakes without turning the system into a brittle lab build:

- AppArmor is enabled by default through the kernel command line and `apparmor.service`.
- UFW is enabled with deny-incoming and allow-outgoing defaults.
- `/etc/sysctl.d/90-cinderos-hardening.conf` restricts dmesg, kernel pointer exposure, ptrace, unprivileged BPF, source routing, and ICMP redirects.
- OpenSSH is installed but disabled. `cinder-security ssh enable` starts SSH, enables fail2ban, and opens the firewall rule.
- USBGuard is installed but disabled. `cinder-security usb learn` writes a policy from currently connected trusted devices, and enabling it remains explicit.
- ClamAV and RKHunter are on-demand only through `cinder-security scan`.
- Secure Boot support is provided through `sbctl` and `cinder-secureboot`, but key enrollment is never run by build or install automation.

## Boot Branding

Plymouth uses the `cinderos` theme and mkinitcpio includes the `plymouth` hook. The installed system copies the GRUB theme to `/boot/grub/themes/cinderos` and sets `GRUB_THEME` during Calamares post-install.

After changing boot art on an installed system, run:

```bash
sudo plymouth-set-default-theme -R cinderos
sudo grub-mkconfig -o /boot/grub/grub.cfg
```

## QA Helpers

Use these on an Arch build host:

- `bash scripts/validate-profile.sh` for structure, live cleanup, branding assets, unsafe GPU overrides, and executable payload checks.
- `bash scripts/security-validate.sh` for security packages, boot parameters, opt-in services, and helper commands.
- `bash scripts/verify-arch-packages.sh` for package name resolution against pacman sync databases.
- `bash scripts/qemu-smoke.sh` after building the ISO.
