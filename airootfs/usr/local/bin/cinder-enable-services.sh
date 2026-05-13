#!/usr/bin/env bash
set -euo pipefail

profile="${1:-core}"

core_services=(
  NetworkManager
  systemd-resolved
  ufw
  apparmor
  upower
  seatd
  greetd
  systemd-timesyncd
  power-profiles-daemon
  switcheroo-control
  earlyoom
  cinder-hardware-setup
)

extra_services=(
  bluetooth
  docker
  cups
  fwupd
)

case "$profile" in
  core)
    services=("${core_services[@]}")
    ;;
  extras)
    services=("${extra_services[@]}")
    ;;
  all)
    services=("${core_services[@]}" "${extra_services[@]}")
    ;;
  *)
    echo "Usage: cinder-enable-services.sh [core|extras|all]" >&2
    exit 2
    ;;
esac

for service in "${services[@]}"; do
  sudo systemctl enable --now "$service.service" || true
done

sudo systemctl disable systemd-networkd.service || true
sudo systemctl mask systemd-rfkill.service systemd-rfkill.socket || true

if [[ "$profile" == "core" ]]; then
  sudo systemctl disable --now bluetooth.service docker.service cups.service fwupd.service systemd-oomd.service cinder-snapshot-setup.service sshd.service fail2ban.service usbguard.service clamav-daemon.service clamav-freshclam.service auditd.service || true
  sudo systemctl disable --now snapper-timeline.timer snapper-cleanup.timer snapper-boot.timer grub-btrfsd.service btrfsmaintenance-refresh.path || true
fi
