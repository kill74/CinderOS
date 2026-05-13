#!/usr/bin/env bash

iso_name="cinderos"
iso_label="CINDEROS_1_0_0"
iso_publisher="CinderOS Project"
iso_application="CinderOS Live/Installation Medium"
iso_version="1.0.0"
install_dir="arch"
buildmodes=('iso')
bootmodes=('bios.syslinux.mbr' 'bios.syslinux.eltorito' 'uefi-ia32.grub.esp' 'uefi-x64.grub.esp')
arch="x86_64"
pacman_conf="pacman.conf"

airootfs_image_type="squashfs"
airootfs_image_tool_options=('-comp' 'zstd' '-Xcompression-level' '19')

file_permissions=(
  ["/etc/shadow"]="0:0:400"
  ["/etc/gshadow"]="0:0:400"
  ["/etc/skel/Desktop/Install CinderOS.desktop"]="0:0:755"
  ["/etc/sudoers.d/00-cinderos-live"]="0:0:440"
  ["/root/customize_airootfs.sh"]="0:0:755"
  ["/etc/calamares/scripts/cinder-install"]="0:0:755"
  ["/usr/local/bin/cinder-enable-services.sh"]="0:0:755"
  ["/usr/local/bin/cinder-first-run"]="0:0:755"
  ["/usr/local/bin/cinder-greetd-session"]="0:0:755"
  ["/usr/local/bin/cinder-control"]="0:0:755"
  ["/usr/local/bin/cinder-doctor"]="0:0:755"
  ["/usr/local/bin/cinder-hardware-setup"]="0:0:755"
  ["/usr/local/bin/cinder-install"]="0:0:755"
  ["/usr/local/bin/cinder-install-vencord.sh"]="0:0:755"
  ["/usr/local/bin/cinder-memory"]="0:0:755"
  ["/usr/local/bin/cinder-rice"]="0:0:755"
  ["/usr/local/bin/cinder-refresh-mirrors"]="0:0:755"
  ["/usr/local/bin/cinder-session-mode"]="0:0:755"
  ["/usr/local/bin/cinder-sandbox"]="0:0:755"
  ["/usr/local/bin/cinder-secureboot"]="0:0:755"
  ["/usr/local/bin/cinder-security"]="0:0:755"
  ["/usr/local/bin/cinder-setup-docker.sh"]="0:0:755"
  ["/usr/local/bin/cinder-setup-gamemode.sh"]="0:0:755"
  ["/usr/local/bin/cinder-setup-flatpak.sh"]="0:0:755"
  ["/usr/local/bin/cinder-setup-proton.sh"]="0:0:755"
  ["/usr/local/bin/cinder-snapshot"]="0:0:755"
  ["/usr/local/bin/cinder-setup-zsh.sh"]="0:0:755"
  ["/usr/local/bin/cinder-tune"]="0:0:755"
  ["/usr/local/bin/cinder-update"]="0:0:755"
  ["/usr/local/bin/cinder-welcome"]="0:0:755"
)
