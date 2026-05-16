# Release Steps

Run these steps on an Arch-based build host.

## 1. Check The Profile

```bash
bash scripts/release-check.sh
```

On Arch, this runs package verification through pacman. On other hosts, package verification is skipped with a message.

Before the ISO exists, you can still start an evidence folder:

```bash
bash scripts/release-evidence.sh --allow-missing-iso
```

## 2. Build The ISO

```bash
bash scripts/clean-build.sh
bash scripts/build-iso.sh
```

ISO path:

```text
$HOME/cinderos-out/cinderos-1.0.0-x86_64.iso
```

## 3. Boot Test

```bash
bash scripts/qemu-smoke.sh --firmware uefi
bash scripts/qemu-smoke.sh --firmware bios
```

Check live boot, first-run, networking, audio, CinderOS Settings, and the installer launcher.

For install testing with a reusable VM disk:

```bash
bash scripts/qemu-smoke.sh --firmware uefi --disk "$HOME/cinderos-out/cinderos-test.qcow2"
```

## 4. Install Test

Run at least one full install in a VM:

- Btrfs erase-disk install.
- Installed boot through GRUB.
- Installed login through `greetd`.
- Live-only sudo and installer launchers removed.
- CinderOS Settings opens after install.
- `cinder-control --page dev` opens and shows the full-stack tools.
- `cinder-control --page games` opens and shows Steam/Proton checks.
- `cinder-doctor` runs and the result is saved.
- `cinder-dev status` runs without enabling Docker or databases.
- `cinder-game-check` records Steam, graphics, controller, and audio status.
- `cinder-personal save` writes a local backup folder.
- `sudo cinder-snapshot setup` creates a root Snapper config.
- A manual snapshot appears in `cinder-snapshot list`.
- `sudo cinder-update` completes.
- Linux Zen and Linux LTS both appear in GRUB after `sudo grub-mkconfig -o /boot/grub/grub.cfg`.

Record any skipped test in `KNOWN_ISSUES.md`.

## 5. Daily Driver Gate

Before replacing a working OS on real hardware:

- Test external backup and restore media.
- Complete the VM install path above.
- Record the graphics path in `HARDWARE_MATRIX.md`.
- Make sure GRUB snapshot entries exist.
- Boot Linux LTS.
- Test rollback in a VM.

Use `DAILY_DRIVER.md` for the longer list.

## 6. Create Checksums

Do not commit built ISO files or checksums unless intentionally publishing a release. For a local release folder:

```bash
cd "$HOME/cinderos-out"
sha256sum cinderos-1.0.0-x86_64.iso > cinderos-1.0.0-x86_64.iso.sha256
```

After the checksum is written, save the evidence file:

```bash
bash scripts/release-evidence.sh
```

## 7. Final Notes

- Update `CHANGELOG.md`.
- Update `KNOWN_ISSUES.md`.
- Update `HARDWARE_MATRIX.md`.
- Record package verification status.
- Record QEMU and install test results.
- Record the path printed by `scripts/release-evidence.sh`.
- Save `cinder-report save` output from the installed VM or test machine.
- Keep Secure Boot enrollment and USBGuard enablement documented as manual steps.
