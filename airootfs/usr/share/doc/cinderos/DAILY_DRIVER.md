# Daily Driver Checklist

CinderOS is intended for a normal Arch-style workstation after recovery has been tested. For this release, the safest target is AMD or Intel graphics, Btrfs, Snapper, and updates through `cinder-update`.

Before replacing another OS:

- Make an external backup.
- Test the restore media.
- Complete a VM install with Btrfs.
- Keep a working live USB nearby.

On the installed system:

```bash
cinder-doctor
sudo cinder-hardware-setup
sudo cinder-snapshot setup
sudo cinder-snapshot create
cinder-snapshot list
sudo grub-mkconfig -o /boot/grub/grub.cfg
sudo cinder-update
```

Before trusting the install, confirm:

- `cinder-doctor` has no unresolved warnings.
- GRUB shows snapshot entries.
- The machine boots the default kernel.
- The machine boots Linux LTS.
- A rollback path has been tested in a VM.
