#!/usr/bin/env bash
set -euo pipefail

profile_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
required=(
  "$profile_dir/profiledef.sh"
  "$profile_dir/packages.x86_64"
  "$profile_dir/packages.aur"
  "$profile_dir/CHANGELOG.md"
  "$profile_dir/DAILY_DRIVER.md"
  "$profile_dir/HARDWARE_MATRIX.md"
  "$profile_dir/KNOWN_ISSUES.md"
  "$profile_dir/QA_CHECKLIST.md"
  "$profile_dir/RELEASE.md"
  "$profile_dir/docs/VOICE.md"
  "$profile_dir/pacman.conf"
  "$profile_dir/scripts/check-code-style.sh"
  "$profile_dir/scripts/check-visible-text.sh"
  "$profile_dir/scripts/release-check.sh"
  "$profile_dir/scripts/release-evidence.sh"
  "$profile_dir/airootfs/root/customize_airootfs.sh"
  "$profile_dir/airootfs/etc/calamares/settings.conf"
  "$profile_dir/airootfs/etc/calamares/branding/cinderos/branding.desc"
  "$profile_dir/airootfs/etc/calamares/branding/cinderos/stylesheet.qss"
  "$profile_dir/airootfs/etc/calamares/branding/cinderos/show.qml"
  "$profile_dir/airootfs/etc/calamares/modules/mount.conf"
  "$profile_dir/airootfs/etc/calamares/modules/shellprocess-cinderos-post.conf"
  "$profile_dir/airootfs/etc/systemd/zram-generator.conf"
  "$profile_dir/airootfs/etc/default/earlyoom"
  "$profile_dir/airootfs/etc/sysctl.d/80-cinderos-memory.conf"
  "$profile_dir/airootfs/etc/sysctl.d/90-cinderos-hardening.conf"
  "$profile_dir/airootfs/etc/systemd/system-preset/90-cinderos-low-idle.preset"
  "$profile_dir/airootfs/etc/cinderos/session-mode"
  "$profile_dir/airootfs/root/custom_files/etc/xdg/xfce4/xfconf/xfce-perchannel-xml/xsettings.xml"
  "$profile_dir/airootfs/etc/xdg/xfce4/xfconf/xfce-perchannel-xml/xfwm4.xml"
  "$profile_dir/airootfs/usr/share/plymouth/themes/cinderos/cinderos.plymouth"
  "$profile_dir/airootfs/usr/share/grub/themes/cinderos/theme.txt"
  "$profile_dir/airootfs/usr/share/cinderos/rice/palette.conf"
  "$profile_dir/airootfs/usr/share/doc/cinderos/README.md"
  "$profile_dir/airootfs/usr/share/doc/cinderos/CHANGELOG.md"
  "$profile_dir/airootfs/usr/share/doc/cinderos/DAILY_DRIVER.md"
  "$profile_dir/airootfs/usr/share/doc/cinderos/HARDWARE_MATRIX.md"
  "$profile_dir/airootfs/usr/share/doc/cinderos/KNOWN_ISSUES.md"
  "$profile_dir/airootfs/usr/share/doc/cinderos/QA_CHECKLIST.md"
  "$profile_dir/airootfs/usr/share/doc/cinderos/RELEASE.md"
  "$profile_dir/airootfs/usr/share/doc/cinderos/VOICE.md"
  "$profile_dir/airootfs/root/custom_files/usr/share/cosmic/com.system76.CosmicBackground/v1/all"
)

for path in "${required[@]}"; do
  if [[ ! -e "$path" ]]; then
    echo "Missing required file: $path" >&2
    exit 1
  fi
done

if grep -Eq '^\s*(visual-studio-code-bin|helium-browser|opencode-bin|proton-ge-custom|heroic-games-launcher-bin|vkbasalt)\s*$' "$profile_dir/packages.x86_64"; then
  echo "AUR-only packages appear in packages.x86_64. Move them to packages.aur." >&2
  exit 1
fi

duplicates="$(grep -Ev '^\s*(#|$)' "$profile_dir/packages.x86_64" | sort | uniq -d)"
if [[ -n "$duplicates" ]]; then
  echo "Duplicate package entries found:" >&2
  echo "$duplicates" >&2
  exit 1
fi

expected_exec=(
  "usr/local/bin/cinder-control"
  "usr/local/bin/cinder-dev"
  "usr/local/bin/cinder-doctor"
  "usr/local/bin/cinder-enable-services.sh"
  "usr/local/bin/cinder-first-run"
  "usr/local/bin/cinder-greetd-session"
  "usr/local/bin/cinder-game-check"
  "usr/local/bin/cinder-hardware-setup"
  "usr/local/bin/cinder-install"
  "usr/local/bin/cinder-memory"
  "usr/local/bin/cinder-rice"
  "usr/local/bin/cinder-refresh-mirrors"
  "usr/local/bin/cinder-report"
  "usr/local/bin/cinder-personal"
  "usr/local/bin/cinder-sandbox"
  "usr/local/bin/cinder-secureboot"
  "usr/local/bin/cinder-security"
  "usr/local/bin/cinder-session-mode"
  "usr/local/bin/cinder-setup-flatpak.sh"
  "usr/local/bin/cinder-snapshot"
  "usr/local/bin/cinder-tune"
  "usr/local/bin/cinder-update"
  "usr/local/bin/cinder-welcome"
)

for rel in "${expected_exec[@]}"; do
  if [[ ! -f "$profile_dir/airootfs/$rel" ]]; then
    echo "Missing executable payload: airootfs/$rel" >&2
    exit 1
  fi

  if ! grep -Fq "[\"/$rel\"]" "$profile_dir/profiledef.sh"; then
    echo "Missing file_permissions entry for /$rel" >&2
    exit 1
  fi
done

branding_assets=(
  "cinderos-installer-logo.svg"
  "cinderos-banner.svg"
  "cinderos-welcome.svg"
  "cinderos-wallpaper.svg"
  "slides/slide-install.svg"
  "slides/slide-hardware.svg"
  "slides/slide-dev.svg"
  "slides/slide-gaming.svg"
)

for rel in "${branding_assets[@]}"; do
  if [[ ! -f "$profile_dir/airootfs/etc/calamares/branding/cinderos/$rel" ]]; then
    echo "Missing installer branding asset: $rel" >&2
    exit 1
  fi
done

cleanup_file="$profile_dir/airootfs/etc/calamares/modules/shellprocess-cinderos-post.conf"
for pattern in "00-cinderos-live" "cinder-install.desktop" "cinder-hardware-setup" "cinder-memory low-idle" "earlyoom" "greetd/config.installed.toml"; do
  if ! grep -Fq "$pattern" "$cleanup_file"; then
    echo "Post-install cleanup is missing expected rule containing: $pattern" >&2
    exit 1
  fi
done

for package in linux-lts linux-lts-headers zram-generator earlyoom stress-ng xfce4-session xfce4-panel xfdesktop xfwm4 apparmor firejail bubblewrap usbguard audit arch-audit lynis clamav rkhunter sbctl tpm2-tools openssh fail2ban; do
  if ! grep -Eq "^\s*${package}\s*$" "$profile_dir/packages.x86_64"; then
    echo "Expected package missing from packages.x86_64: $package" >&2
    exit 1
  fi
done

for package in nodejs npm pnpm python-pip python-pipx python-poetry rustup go jdk-openjdk sqlite postgresql redis direnv httpie hurl docker docker-compose docker-buildx; do
  if ! grep -Eq "^\s*${package}\s*$" "$profile_dir/packages.x86_64"; then
    echo "Expected dev package missing from packages.x86_64: $package" >&2
    exit 1
  fi
done

for package in steam gamemode mangohud gamescope goverlay mesa-utils vulkan-tools lib32-mesa lib32-vulkan-radeon; do
  if ! grep -Eq "^\s*${package}\s*$" "$profile_dir/packages.x86_64"; then
    echo "Expected game package missing from packages.x86_64: $package" >&2
    exit 1
  fi
done

if ! grep -Eq '^\s*vkbasalt\s*$' "$profile_dir/packages.aur"; then
  echo "Expected AUR package missing from packages.aur: vkbasalt" >&2
  exit 1
fi

if ! grep -Fq 'zram-size = min(ram / 2, 8192)' "$profile_dir/airootfs/etc/systemd/zram-generator.conf"; then
  echo "zram-generator.conf does not contain the expected low-idle zram size." >&2
  exit 1
fi

if ! grep -Fq 'exec cinder-control --page welcome' "$profile_dir/airootfs/usr/local/bin/cinder-first-run"; then
  echo "First-run launcher does not open the CinderOS Start page." >&2
  exit 1
fi

if ! grep -Fq 'Exec=cinder-control --page welcome' "$profile_dir/airootfs/usr/share/applications/cinder-welcome.desktop"; then
  echo "Welcome desktop entry does not open the CinderOS Start page." >&2
  exit 1
fi

if ! grep -Fq 'self.add_alias("rice", "appearance")' "$profile_dir/airootfs/usr/local/bin/cinder-control"; then
  echo "CinderOS Settings does not keep --page rice compatible with Appearance." >&2
  exit 1
fi

if ! grep -Fq 'self.add_page("status", "Status", self.status_page())' "$profile_dir/airootfs/usr/local/bin/cinder-control"; then
  echo "CinderOS Settings is missing the Status page." >&2
  exit 1
fi

if ! grep -Fq 'self.add_page("diagnostics", "Diagnostics", self.diagnostics_page())' "$profile_dir/airootfs/usr/local/bin/cinder-control"; then
  echo "CinderOS Settings is missing the Diagnostics page." >&2
  exit 1
fi

if ! grep -Fq 'self.add_page("dev", "Dev", self.dev_page())' "$profile_dir/airootfs/usr/local/bin/cinder-control"; then
  echo "CinderOS Settings is missing the Dev page." >&2
  exit 1
fi

if ! grep -Fq 'cinder-game-check' "$profile_dir/airootfs/usr/local/bin/cinder-control"; then
  echo "CinderOS Settings Games page is missing the game check action." >&2
  exit 1
fi

if ! grep -Fq 'cinder-personal save' "$profile_dir/airootfs/usr/local/bin/cinder-control"; then
  echo "CinderOS Settings Dev page is missing the personal save action." >&2
  exit 1
fi

for marker in "AMD" "Intel" "NVIDIA" "Linux LTS boot" "Rollback"; do
  if ! grep -Fq "$marker" "$profile_dir/HARDWARE_MATRIX.md"; then
    echo "Hardware matrix is missing expected marker: $marker" >&2
    exit 1
  fi
done

if ! grep -Fq 'Exec=cinder-control --page appearance' "$profile_dir/airootfs/usr/share/applications/cinder-rice.desktop"; then
  echo "Appearance desktop entry does not open the Appearance page." >&2
  exit 1
fi

if ! grep -Fq 'Exec=cinder-control --page backups' "$profile_dir/airootfs/usr/share/applications/cinder-snapshot.desktop"; then
  echo "Backups desktop entry does not open the Backups page." >&2
  exit 1
fi

if ! grep -Fq 'cinder-welcome commands' "$profile_dir/airootfs/usr/local/bin/cinder-welcome"; then
  echo "Terminal welcome is missing the full command reference entry point." >&2
  exit 1
fi

if ! grep -Fq 'cinder-report save' "$profile_dir/airootfs/usr/local/bin/cinder-control"; then
  echo "CinderOS Settings Diagnostics page does not use cinder-report." >&2
  exit 1
fi

if ! grep -Fq -- '--allow-missing-iso' "$profile_dir/scripts/release-evidence.sh"; then
  echo "release-evidence.sh is missing the pre-build evidence option." >&2
  exit 1
fi

if ! grep -Fq -- '--firmware' "$profile_dir/scripts/qemu-smoke.sh"; then
  echo "qemu-smoke.sh is missing firmware mode support." >&2
  exit 1
fi

if ! grep -Fq 'cinder-doctor' "$profile_dir/airootfs/usr/local/bin/cinder-control"; then
  echo "CinderOS Settings is missing the daily-driver check action." >&2
  exit 1
fi

if ! grep -Fq 'sudo cinder-update' "$profile_dir/airootfs/usr/local/bin/cinder-control"; then
  echo "CinderOS Settings is missing the update action." >&2
  exit 1
fi

bash "$profile_dir/scripts/check-visible-text.sh"

if ! grep -Fq 'swap-priority = 100' "$profile_dir/airootfs/etc/systemd/zram-generator.conf"; then
  echo "zram-generator.conf does not set zram swap priority to 100." >&2
  exit 1
fi

if ! grep -Fq 'EARLYOOM_ARGS=' "$profile_dir/airootfs/etc/default/earlyoom"; then
  echo "earlyoom defaults are missing EARLYOOM_ARGS." >&2
  exit 1
fi

for file in "$profile_dir/airootfs/root/customize_airootfs.sh" "$cleanup_file"; do
  if grep -Eq 'systemctl enable.*(docker|cups|bluetooth|fwupd|cinder-snapshot-setup|sshd|fail2ban|usbguard|clamav-daemon|clamav-freshclam)' "$file"; then
    echo "Heavy service is auto-enabled in low-idle path: $file" >&2
    exit 1
  fi
done

if ! grep -Fq 'lsm=landlock,lockdown,yama,integrity,apparmor,bpf audit=1' "$profile_dir/airootfs/etc/default/grub"; then
  echo "Installed GRUB defaults are missing AppArmor/audit boot parameters." >&2
  exit 1
fi

if ! grep -Fq 'lsm=landlock,lockdown,yama,integrity,apparmor,bpf audit=1' "$profile_dir/grub/grub.cfg"; then
  echo "Live GRUB config is missing AppArmor/audit boot parameters." >&2
  exit 1
fi

if ! grep -Fq 'vmlinuz-linux-lts' "$profile_dir/grub/grub.cfg"; then
  echo "Live GRUB config is missing the Linux LTS fallback entry." >&2
  exit 1
fi

if ! grep -Fq 'enable apparmor.service' "$profile_dir/airootfs/etc/systemd/system-preset/90-cinderos-low-idle.preset"; then
  echo "Low-idle preset does not enable AppArmor." >&2
  exit 1
fi

if grep -Fq 'cinder-snapshot setup' "$cleanup_file"; then
  echo "Snapshots are configured during install; they should be opt-in for low idle." >&2
  exit 1
fi

if grep -Fq 'cinder-setup-flatpak.sh --system' "$cleanup_file"; then
  echo "Flathub setup runs during install; it should be opt-in for low idle." >&2
  exit 1
fi

if grep -Rqs 'VK_ICD_FILENAMES=/usr/share/vulkan/icd.d/radeon_icd' "$profile_dir/airootfs/etc/environment" "$profile_dir/airootfs/etc/profile.d"; then
  echo "Unsafe global Radeon Vulkan ICD override found." >&2
  exit 1
fi

if grep -RqsE '^\s*(nvidia|nvidia_modeset|nvidia_uvm|nvidia_drm)\s*$' "$profile_dir/airootfs/etc/modules-load.d"; then
  echo "NVIDIA modules must not be globally loaded from modules-load.d." >&2
  exit 1
fi

if grep -Eq '^\s*MODULES=.*nvidia' "$profile_dir/airootfs/etc/mkinitcpio.conf.d/cinderos.conf"; then
  echo "NVIDIA modules must not be globally included in mkinitcpio defaults." >&2
  exit 1
fi

if [[ -e "$profile_dir/airootfs/etc/modprobe.d/nvidia.conf" ]]; then
  echo "NVIDIA modprobe settings must be written by cinder-hardware-setup only when NVIDIA hardware is detected." >&2
  exit 1
fi

if ! grep -Fq 'has_nvidia' "$profile_dir/airootfs/usr/local/bin/cinder-hardware-setup" || ! grep -Fq 'nvidia_drm modeset=1' "$profile_dir/airootfs/usr/local/bin/cinder-hardware-setup"; then
  echo "cinder-hardware-setup is missing the detected-NVIDIA setup path." >&2
  exit 1
fi

bash "$profile_dir/scripts/security-validate.sh"
bash "$profile_dir/scripts/rice-validate.sh"
bash "$profile_dir/scripts/audit-profile.sh"

echo "CinderOS profile looks structurally valid."
