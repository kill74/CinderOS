# Release Steps

Run these steps on an Arch-based build host.

## 1. Check The Profile

```bash
bash scripts/release-check.sh
```

On Arch, this runs package verification through pacman. On other hosts, package verification is skipped with a message.

## 2. Build The ISO

```bash
bash scripts/clean-build.sh
bash scripts/build-iso.sh
```

Expected output path:

```text
$HOME/cinderos-out/cinderos-1.0.0-x86_64.iso
```

## 3. Boot Test

```bash
bash scripts/qemu-smoke.sh
```

Check live boot, first-run, networking, audio, CinderOS Settings, and the installer launcher.

## 4. Install Test

Run at least one full install in a VM:

- Btrfs erase-disk install.
- Installed boot through GRUB.
- Installed login through `greetd`.
- Live-only sudo and installer launchers removed.
- CinderOS Settings opens after install.
- `cinder-doctor` runs and the result is recorded.
- `sudo cinder-snapshot setup` creates a root Snapper config.
- A manual snapshot appears in `cinder-snapshot list`.
- `sudo cinder-update` completes.
- Linux Zen and Linux LTS both appear in GRUB after `sudo grub-mkconfig -o /boot/grub/grub.cfg`.

Record any skipped test in `KNOWN_ISSUES.md`.

## 5. Daily Driver Gate

Before replacing a working OS on real hardware:

- Test external backup and restore media.
- Complete the VM install path above.
- Confirm GRUB snapshot entries exist.
- Confirm Linux LTS boots.
- Test rollback in a VM.

Use `DAILY_DRIVER.md` as the full checklist.

## 6. Create Checksums

Do not commit generated ISO files or checksums unless intentionally publishing a release. For a local release folder:

```bash
cd "$HOME/cinderos-out"
sha256sum cinderos-1.0.0-x86_64.iso > cinderos-1.0.0-x86_64.iso.sha256
```

## 7. Final Notes

- Update `CHANGELOG.md`.
- Update `KNOWN_ISSUES.md`.
- Record package verification status.
- Record QEMU and install test results.
- Keep Secure Boot enrollment and USBGuard enablement documented as manual steps.
