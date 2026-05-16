# QA Checklist

Use this before sharing an ISO.

## Live Boot

- Boot the ISO in QEMU with UEFI.
- Boot the ISO in QEMU with BIOS when possible.
- Save QEMU output with `scripts/qemu-smoke.sh --log "$HOME/cinderos-out/qemu-smoke.log"` when debugging boot issues.
- Reach the live desktop without manual login.
- Open CinderOS Settings from the first-run prompt.
- Make sure the installer launcher appears in the live session.
- Check networking and refresh mirrors.
- Check that audio devices appear through PipeWire.
- Shut down and reboot cleanly.

## Installer

- Run a Btrfs erase-disk install.
- Run a manual partitioning install.
- Run a LUKS2 encrypted install.
- Test swap choices: none, swapfile, partition, and zram where available.
- Boot the installed system through GRUB.
- Make sure GRUB shows Linux LTS after `sudo grub-mkconfig -o /boot/grub/grub.cfg`.
- Make sure live-only sudo and installer launchers are removed after install.
- Log in through `greetd`.

## CinderOS Settings

- Open Start, Status, System, Dev, Appearance, Memory, Services, Security, Session, Games, Backups, Diagnostics, and About.
- Check that `--page welcome`, `--page dev`, `--page games`, `--page appearance`, `--page rice`, `--page backups`, `--page snapshots`, and `--page diagnostics` open the right pages.
- Check that Status shows live/installed mode, session mode, memory, firewall/AppArmor, snapshots, root filesystem, root space, kernel, and zram.
- Check that Dev shows Node, Python, Docker, databases, Projects, and backup actions.
- Check that Games shows Steam/Proton, Performance, Overlays, Controllers, and Troubleshooting groups.
- Run the Diagnostics system check and save a report.
- Run `cinder-report save` and make sure it writes a dated report.
- Open terminal actions and make sure the output stays readable.

## Development And Games

- Run `cinder-dev status`.
- Run `cinder-dev db` and confirm PostgreSQL and Redis are not enabled by this command.
- Open the project folder from the Dev page.
- Run `cinder-personal save` and confirm the backup stays on this machine.
- Run `cinder-game-check`.
- Run the Vulkan and OpenGL quick checks on the Games page.
- Plug in a controller and rerun `cinder-game-check` when hardware is available.

## Hardware

- Record AMD, Intel, and NVIDIA results in `HARDWARE_MATRIX.md`.
- Run `sudo cinder-hardware-setup` on AMD graphics.
- Run `sudo cinder-hardware-setup` on Intel graphics.
- Run `sudo cinder-hardware-setup` on NVIDIA graphics.
- Make sure vendor-specific environment settings are only written for detected hardware.
- Run Vulkan tools on each graphics stack.
- Open Steam on each graphics stack you mark as `Pass`.
- Do not mark a graphics stack ready until suspend and resume work.

## Desktop

- Start COSMIC and check that it uses the CinderOS wallpaper.
- Select XFCE Lite through `cinder-session-mode lite`.
- Check Kitty, Starship, Fastfetch, btop, and GTK settings against the CinderOS appearance defaults.
- Open Steam.
- Make sure MangoHud, GameMode, Gamescope, GOverlay, and vkBasalt are installed or clearly reported as missing.

## Security And Backups

- Run `cinder-doctor`.
- Run `cinder-report save`.
- Run `cinder-security status`.
- Run `sudo cinder-security harden`.
- Make sure SSH and fail2ban stay off until enabled.
- Keep USBGuard off until a policy is reviewed and enabled.
- Run `sudo cinder-snapshot setup` on a Btrfs install.
- Create and list a manual snapshot.
- Make sure grub-btrfs entries appear after snapshot setup.
- Run `sudo cinder-update` after snapshot setup.
- Reboot into Linux Zen and Linux LTS.
- Test at least one rollback path in a VM.

## Daily Driver Gate

- Make sure an external backup exists.
- Boot restore media and make sure it can see the backup.
- Run the first installed update with `sudo cinder-update`.
- Leave no unresolved `cinder-doctor` warnings.

## Release Evidence

- Save the ISO filename, build date, package verification result, QEMU boot result, install result, and checksum in release notes.
- Run `scripts/release-evidence.sh` after the ISO exists.
- Update `HARDWARE_MATRIX.md` with hardware test status and evidence.
- Update `KNOWN_ISSUES.md` with anything still untested.
