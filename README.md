# CinderOS

**An Arch Linux install image built for a trusted desktop workstation.**

CinderOS 1.0.0 "Ember" is an opinionated ArchISO profile designed around COSMIC, Btrfs, PipeWire, zram, AppArmor, full-stack development tools, gaming support, and a suite of maintenance commands. The goal is simple: an Arch install I can actually trust, with sensible defaults, recovery tools close at hand, and heavier services left off until they're needed.

## Status

⚠️ **Pre-Production**: Ready for build and VM testing. Not yet ready for production use on real hardware.

- **Version**: 1.0.0 "Ember"
- **Target Hardware**: AMD and Intel systems (safest for daily driver); NVIDIA packages included but experimental
- **Last Validated**: See [CHANGELOG.md](CHANGELOG.md)
- **Known Issues**: See [KNOWN_ISSUES.md](KNOWN_ISSUES.md)

**Before installing on real hardware**, complete the [daily-driver checklist](#daily-driver-checklist) and review [DAILY_DRIVER.md](DAILY_DRIVER.md), [QA_CHECKLIST.md](QA_CHECKLIST.md), and [HARDWARE_MATRIX.md](HARDWARE_MATRIX.md).

## Quick Start

### Build Requirements

Build on an Arch-based host with `archiso` and `git`:

```bash
sudo pacman -Syu archiso git
```

**Optional** — for AUR packages, ISO testing:

```bash
sudo pacman -S base-devel devtools qemu-full edk2-ovmf
```

### Build & Test

```bash
# Validate profile
bash scripts/release-check.sh

# Build ISO
bash scripts/build-iso.sh

# Smoke test (UEFI/BIOS)
bash scripts/qemu-smoke.sh --firmware uefi
bash scripts/qemu-smoke.sh --firmware bios
```

**Output**: `$HOME/cinderos-out/cinderos-1.0.0-x86_64.iso`

### What's Inside

- **330+ pacman packages** + **21 AUR packages**
- **37 custom CinderOS command-line tools** (`cinder-*` suite)
- Complete recovery and snapshot infrastructure
- Gaming, development, and system tooling ready out of the box

## Key Features

### Desktop & Sessions
- **COSMIC Wayland** as primary desktop environment
- **XFCE Lite** available as a lighter alternative
- greetd login manager with COSMIC Greeter (tuigreet fallback)

### Storage & Recovery
- **Btrfs filesystem** with Snapper snapshots
- Automatic snapshots on package updates (`snap-pac`)
- grub-btrfs to boot previous snapshots
- Btrfs Assistant GUI and maintenance tools
- Full rollback capabilities

### System Fundamentals
- **Kernel**: Linux Zen (default) + Linux LTS (fallback)
- **Audio**: PipeWire (with ALSA, Jack, Pulse compatibility)
- **Networking**: NetworkManager + IWD
- **Memory**: zram with zstd compression + earlyoom protection
- **Security**: AppArmor (enabled), UFW firewall, Audit framework
- **Power Management**: power-profiles-daemon + Switcheroo GPU control

### Development Stack
Node.js, npm, pnpm · Python (pip, pipx, poetry) · Rust (rustup) · Go · OpenJDK · Docker · PostgreSQL, Redis, SQLite

**Plus**: direnv, HTTPie, hurl, and other dev essentials.

### Gaming Support
Steam, Proton helpers, Wine, GameMode, MangoHud, Gamescope, GOverlay, Vulkan/OpenGL tools, 32-bit graphics libraries

### Terminal & CLI Excellence
Kitty · zsh + Starship prompt · zoxide · ripgrep, fd, fzf · bat · eza · btop, fastfetch · lazygit, GitHub CLI · tmux · Neovim

### System Administration
37 custom CinderOS commands for hardware setup, diagnostics, dev tools, gaming checks, snapshots, security, updates, memory, and more.

## Design Philosophy

Services opt-in, not enabled by default:
- Docker, PostgreSQL, Redis
- Bluetooth, CUPS printing
- SSH, fail2ban, USBGuard
- ClamAV, auditd, Snapper/Btrfs timers
- Flathub/Flatpak setup

Enable only what your machine actually needs.

## Who This Is For

- **Desktop users** wanting an Arch-based workstation with COSMIC by default
- **Developers and gamers** with AMD or Intel graphics
- **Users** who value Btrfs snapshots, AppArmor, UFW, zram, and system diagnostics from day one
- **People** who prefer explicit opt-in over hidden background services

**Note on NVIDIA**: AMD and Intel are safer first daily-driver choices. NVIDIA is experimental—needs testing around kernel updates, suspend, and Wayland stability.

## Off By Default

The following packages are installed but services are disabled:

```
Docker · PostgreSQL · Redis · Bluetooth · CUPS · fwupd · SSH/fail2ban
USBGuard · ClamAV · auditd · Snapper/Btrfs timers · Flathub
```

Enable from CinderOS Settings or via command-line tools as needed.

## Daily Driver Checklist

Before replacing your current OS:

```bash
cinder-doctor
sudo cinder-snapshot setup
sudo cinder-snapshot create
cinder-snapshot list
sudo cinder-update
sudo grub-mkconfig -o /boot/grub/grub.cfg
```

Then verify:
- External backup and restore media work
- VM install completes successfully
- GRUB shows snapshot entries
- Linux Zen boots
- Linux LTS boots
- Rollback path has been tested in a VM

## Useful Commands

### System & Diagnostics
```bash
cinder-control                    # Settings GUI
cinder-doctor                     # System health check
cinder-report save                # Generate diagnostics report
cinder-hardware-setup             # Detect and configure hardware
```

### Development & Gaming
```bash
cinder-dev status                 # Dev environment overview
cinder-dev db                     # Database status
cinder-game-check                 # Gaming hardware check
cinder-control --page dev         # Dev settings GUI
cinder-control --page games       # Gaming settings GUI
```

### Snapshots & Updates
```bash
sudo cinder-snapshot setup        # Initialize snapshots
sudo cinder-snapshot create       # Create manual snapshot
cinder-snapshot list              # List all snapshots
sudo cinder-update                # Safe update with snapshots
```

### Performance & Security
```bash
cinder-memory status              # Memory mode info
cinder-memory low-idle            # Switch to low-power mode
cinder-security status            # Security overview
sudo cinder-security harden       # Enable hardening
cinder-tune balanced              # Performance tuning
```

### Sessions & Appearance
```bash
cinder-session-mode cosmic        # Switch to COSMIC
cinder-session-mode lite          # Switch to XFCE Lite
cinder-control --page diagnostics # System diagnostics GUI
cinder-welcome commands           # Available commands
```

### Local Backups
```bash
cinder-personal save              # Backup dotfiles locally
```

## Build Details

### Direct ArchISO Command

```bash
sudo mkarchiso -v -w /tmp/cinderos-work -o "$HOME/cinderos-out" .
```

### Directories
- **Work**: `/tmp/cinderos-work`
- **Output**: `$HOME/cinderos-out`
- **Evidence**: `$HOME/cinderos-out/evidence/`

### Release Evidence

```bash
bash scripts/release-evidence.sh
bash scripts/release-evidence.sh --allow-missing-iso  # Before ISO exists
```

## AUR Packages

`packages.x86_64` lists pacman packages resolved during `mkarchiso`.

`packages.aur` lists AUR packages (VS Code, Zed, Helium, Proton GE, Bottles, Heroic, etc.) that must be:
1. Built separately in a clean chroot, or
2. Installed after setup using `paru`

## Repository Structure

```
├── README.md                      # This file
├── CHANGELOG.md                   # Version history
├── DAILY_DRIVER.md               # Pre-deployment checklist
├── KNOWN_ISSUES.md               # Open blockers
├── HARDWARE_MATRIX.md            # Hardware test tracking
├── QA_CHECKLIST.md               # Quality assurance steps
├── RELEASE.md                    # Release process
├── NOTES.md                      # Developer notes
│
├── docs/
│   └── VOICE.md                 # Writing style guide
│
├── scripts/                      # Build and validation
│   ├── release-check.sh          # Pre-release validation
│   ├── build-iso.sh              # Build ISO
│   ├── qemu-smoke.sh             # VM boot tests
│   └── (8+ other helpers)
│
├── airootfs/                     # Live ISO filesystem overlay
│   ├── etc/                      # System config
│   ├── root/                     # Customization script
│   └── usr/local/bin/            # 37 cinder-* commands
│
├── profiledef.sh                 # ArchISO profile metadata
├── packages.x86_64               # Pacman package manifest
├── packages.aur                  # AUR packages
├── pacman.conf                   # Build-time pacman config
└── grub/                         # Bootloader configuration
```

## Documentation Hub

| Document | Purpose |
|----------|---------|
| [CHANGELOG.md](CHANGELOG.md) | Version history and changes |
| [DAILY_DRIVER.md](DAILY_DRIVER.md) | Pre-production deployment checklist |
| [KNOWN_ISSUES.md](KNOWN_ISSUES.md) | Open gaps and experimental features |
| [HARDWARE_MATRIX.md](HARDWARE_MATRIX.md) | AMD/Intel/NVIDIA test tracking |
| [QA_CHECKLIST.md](QA_CHECKLIST.md) | Quality assurance procedures |
| [RELEASE.md](RELEASE.md) | Release process documentation |
| [NOTES.md](NOTES.md) | Developer notes and context |
| [docs/VOICE.md](docs/VOICE.md) | Writing style guide |

## Current Limitations

- AUR packages not installed by `mkarchiso` unless prebuilt into a custom repo
- Package verification requires Arch host with `pacman`
- Full install testing needs VM or physical hardware
- Secure Boot and USBGuard setup manual (keys/policies)
- NVIDIA still needs testing on real hardware (kernel updates, suspend, Wayland)
- All major features need hardware testing before production use

See [KNOWN_ISSUES.md](KNOWN_ISSUES.md) for detailed tracking.

## Live User

The live ISO creates a `cinder` user with passwordless sudo for testing and installation. Root login is locked.

Installed systems remove the live sudo rule and use normal privilege prompts.

## Configuration & Customization

**Key Configuration Files**:
- `profiledef.sh` — ArchISO profile settings, boot modes, compression
- `pacman.conf` — Build-time package manager config with multilib and CachyOS repos
- `cinderos.project.json` — Project metadata (kernels, desktops, paths, etc.)
- `docs/VOICE.md` — Writing guidelines for CinderOS documentation

## Contributing

Submit issues and pull requests via GitHub. Before contributing:
- Review [docs/VOICE.md](docs/VOICE.md) for writing style
- Run `bash scripts/release-check.sh` to validate changes
- Test your changes in a VM before proposing production changes

## License

See [LICENSE](LICENSE) (if present) or the original ArchISO license terms.

## Acknowledgments

CinderOS is built on [Arch Linux](https://archlinux.org) and [ArchISO](https://gitlab.archlinux.org/archlinux/archiso). Special thanks to the COSMIC, Btrfs, PipeWire, and AppArmor communities.
