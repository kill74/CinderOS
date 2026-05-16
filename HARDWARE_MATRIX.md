# Hardware Matrix

Keep this boring and honest. Only mark something as `Pass` after testing that exact ISO on that exact machine, with enough notes that you can repeat the test later.

## Status Legend

- `Not tested` - No result recorded yet.
- `Pass` - Tested successfully on the listed hardware and ISO.
- `Fail` - Tested and failed; add notes and link the useful logs or report.
- `Blocked` - Could not test because of missing hardware, build tools, firmware setup, or another prerequisite.
- `Partial` - Works with caveats; explain the caveat in Notes.

## Release Summary

| Graphics stack | Live boot | Install | Suspend | Wayland | Vulkan | Steam | Linux LTS boot | Rollback | Notes |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| AMD | Not tested | Not tested | Not tested | Not tested | Not tested | Not tested | Not tested | Not tested | Best first machine class for daily-driver testing. |
| Intel | Not tested | Not tested | Not tested | Not tested | Not tested | Not tested | Not tested | Not tested | Best first machine class for daily-driver testing. |
| NVIDIA | Not tested | Not tested | Not tested | Not tested | Not tested | Not tested | Not tested | Not tested | Needs extra Wayland, suspend, and kernel-update testing. |

## Minimum Daily-Driver Gate

Before replacing another OS on real hardware, get at least one AMD or Intel machine to this point:

- Live boot: `Pass`
- Btrfs install: `Pass`
- COSMIC Wayland login: `Pass`
- Vulkan tools: `Pass`
- Linux Zen boot: `Pass`
- Linux LTS boot: `Pass`
- Snapshot creation: `Pass`
- GRUB snapshot entry: `Pass`
- Rollback test in VM or spare disk: `Pass`
- First update through `sudo cinder-update`: `Pass`

Treat NVIDIA as experimental until suspend, Wayland, kernel updates, Vulkan, Steam, and LTS boot have all passed on NVIDIA hardware.

## Test Records

Copy this block for each machine you test.

```text
Date:
Tester:
ISO:
ISO SHA256:
Machine:
CPU:
GPU:
RAM:
Firmware mode: UEFI / BIOS
Storage:
Install type: live only / Btrfs erase disk / manual partitioning / LUKS2
Kernel tested: linux-zen / linux-lts

Results:
- Live boot:
- Installer:
- Installed boot:
- COSMIC Wayland:
- XFCE Lite:
- Suspend/resume:
- Vulkan:
- Steam:
- Linux LTS boot:
- Snapshot setup:
- GRUB snapshot entries:
- Rollback:
- First update:
- cinder-doctor:
- cinder-report save:
- cinder-control diagnostics report:

Notes:
Evidence:
```

## Test Commands

Run these during installed-system testing and paste the useful bits into the record.

```bash
cinder-control --page diagnostics
cinder-doctor
cinder-report save
sudo cinder-hardware-setup
cinder-memory status
cinder-security status
cinder-snapshot status
vulkaninfo --summary
steam
sudo cinder-snapshot setup
sudo cinder-snapshot create
cinder-snapshot list
sudo cinder-update
sudo grub-mkconfig -o /boot/grub/grub.cfg
```

For graphics identification:

```bash
lspci | grep -Ei 'vga|3d|display'
glxinfo -B 2>/dev/null || true
vulkaninfo --summary
```
