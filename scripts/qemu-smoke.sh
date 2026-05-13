#!/usr/bin/env bash
set -euo pipefail

iso="${1:-$HOME/cinderos-out/cinderos-1.0.0-x86_64.iso}"

if [[ ! -f "$iso" ]]; then
  echo "ISO not found: $iso" >&2
  exit 1
fi

if ! command -v qemu-system-x86_64 >/dev/null 2>&1; then
  echo "qemu-system-x86_64 is required." >&2
  exit 1
fi

qemu-system-x86_64 \
  -name CinderOS-Smoke \
  -m 4096 \
  -smp 4 \
  -cpu host \
  -enable-kvm \
  -vga virtio \
  -display gtk,gl=on \
  -device intel-hda \
  -device hda-duplex \
  -nic user,model=virtio-net-pci \
  -boot d \
  -cdrom "$iso"

