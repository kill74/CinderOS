# Release Steps

1. Run `bash scripts/release-check.sh` on the build host.
2. Build with `bash scripts/build-iso.sh`.
3. Boot the ISO with `bash scripts/qemu-smoke.sh`.
4. Run at least one full VM install.
5. Run `cinder-doctor`, `sudo cinder-snapshot setup`, `sudo cinder-update`, and `sudo grub-mkconfig -o /boot/grub/grub.cfg` in the installed VM.
6. Confirm Linux Zen, Linux LTS, and snapshot entries appear in GRUB.
7. Create a SHA256 checksum outside the repo:

```bash
cd "$HOME/cinderos-out"
sha256sum cinderos-1.0.0-x86_64.iso > cinderos-1.0.0-x86_64.iso.sha256
```

8. Update `CHANGELOG.md` and `KNOWN_ISSUES.md`.
