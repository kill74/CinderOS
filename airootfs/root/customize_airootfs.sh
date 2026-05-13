#!/usr/bin/env bash
set -euo pipefail

ln -sf /run/systemd/resolve/stub-resolv.conf /etc/resolv.conf || true

locale-gen
passwd -l root || true

for group in wheel gamemode docker video audio storage optical network; do
  if ! getent group "$group" >/dev/null; then
    groupadd -r "$group"
  fi
done

if ! id cinder >/dev/null 2>&1; then
  useradd -m -G wheel,gamemode,docker,video,audio,storage,optical,network -s /bin/bash cinder
fi

passwd -d cinder || true
chsh -s /bin/zsh cinder || true
chown -R cinder:cinder /home/cinder || true

for service in NetworkManager systemd-resolved ufw apparmor upower seatd greetd systemd-timesyncd power-profiles-daemon switcheroo-control earlyoom cinder-hardware-setup; do
  systemctl enable "$service.service" || true
done

for service in bluetooth docker cups fwupd systemd-oomd cinder-snapshot-setup sshd fail2ban usbguard clamav-daemon clamav-freshclam auditd; do
  systemctl disable "$service.service" || true
done

for timer in snapper-timeline snapper-cleanup snapper-boot btrfs-scrub@-; do
  systemctl disable "$timer.timer" || true
done

systemctl disable grub-btrfsd.service btrfsmaintenance-refresh.path || true
systemctl disable systemd-networkd.service || true
systemctl mask systemd-rfkill.service systemd-rfkill.socket || true

ufw default deny incoming || true
ufw default allow outgoing || true
ufw --force enable || true
sysctl --system || true
cinder-memory low-idle || true

printf 'CinderOS live image customization complete.\n'
