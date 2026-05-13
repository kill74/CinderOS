#!/usr/bin/env bash
set -euo pipefail

profile_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

security_packages=(
  apparmor
  firejail
  bubblewrap
  usbguard
  audit
  arch-audit
  lynis
  clamav
  rkhunter
  sbctl
  tpm2-tools
  openssh
  fail2ban
)

security_commands=(
  cinder-security
  cinder-secureboot
  cinder-sandbox
)

for package in "${security_packages[@]}"; do
  if ! grep -Eq "^\s*${package}\s*$" "$profile_dir/packages.x86_64"; then
    echo "Missing security package: $package" >&2
    exit 1
  fi
done

for command in "${security_commands[@]}"; do
  if [[ ! -f "$profile_dir/airootfs/usr/local/bin/$command" ]]; then
    echo "Missing security command: $command" >&2
    exit 1
  fi

  if ! grep -Fq "[\"/usr/local/bin/$command\"]" "$profile_dir/profiledef.sh"; then
    echo "Missing file_permissions entry for /usr/local/bin/$command" >&2
    exit 1
  fi
done

if [[ ! -f "$profile_dir/airootfs/etc/sysctl.d/90-cinderos-hardening.conf" ]]; then
  echo "Missing balanced hardening sysctl config." >&2
  exit 1
fi

if [[ ! -f "$profile_dir/airootfs/etc/fail2ban/jail.d/cinderos-sshd.conf" ]]; then
  echo "Missing fail2ban SSH safe-mode jail." >&2
  exit 1
fi

if [[ ! -f "$profile_dir/airootfs/etc/ssh/sshd_config.d/10-cinderos-hardening.conf" ]]; then
  echo "Missing OpenSSH safe-mode hardening config." >&2
  exit 1
fi

if grep -Rqs 'Optional TrustAll' "$profile_dir/pacman.conf" "$profile_dir/airootfs/etc/pacman.conf"; then
  echo "Unsafe pacman TrustAll repo policy found." >&2
  exit 1
fi

for setting in kernel.kptr_restrict kernel.dmesg_restrict kernel.yama.ptrace_scope kernel.unprivileged_bpf_disabled net.core.bpf_jit_harden; do
  if ! grep -Eq "^\s*${setting}\s*=" "$profile_dir/airootfs/etc/sysctl.d/90-cinderos-hardening.conf"; then
    echo "Hardening sysctl missing: $setting" >&2
    exit 1
  fi
done

for file in "$profile_dir/airootfs/etc/default/grub" "$profile_dir/grub/grub.cfg"; do
  if ! grep -Fq 'lsm=landlock,lockdown,yama,integrity,apparmor,bpf audit=1' "$file"; then
    echo "Missing AppArmor/audit boot parameters in $file" >&2
    exit 1
  fi
done

for file in \
  "$profile_dir/airootfs/root/customize_airootfs.sh" \
  "$profile_dir/airootfs/etc/calamares/modules/shellprocess-cinderos-post.conf" \
  "$profile_dir/airootfs/etc/calamares/modules/services-systemd.conf" \
  "$profile_dir/airootfs/etc/systemd/system-preset/90-cinderos-low-idle.preset"; do
  if ! grep -Fq 'apparmor' "$file"; then
    echo "AppArmor service policy missing from $file" >&2
    exit 1
  fi
done

for file in "$profile_dir/airootfs/root/customize_airootfs.sh" "$profile_dir/airootfs/etc/calamares/modules/shellprocess-cinderos-post.conf"; do
  if grep -Eq 'systemctl enable.*(sshd|fail2ban|usbguard|clamav-daemon|clamav-freshclam|auditd)' "$file"; then
    echo "Opt-in security service is auto-enabled in $file" >&2
    exit 1
  fi
done

for service in sshd fail2ban usbguard clamav-daemon clamav-freshclam auditd; do
  if ! grep -Eq "(disable ${service}\.service|disable ${service}|${service})" "$profile_dir/airootfs/etc/systemd/system-preset/90-cinderos-low-idle.preset"; then
    echo "Low-idle preset does not explicitly keep $service opt-in." >&2
    exit 1
  fi
done

if grep -Rqs 'sbctl enroll-keys' \
  "$profile_dir/airootfs/root/customize_airootfs.sh" \
  "$profile_dir/airootfs/etc/calamares"; then
  echo "Secure Boot enrollment appears in build/install automation; it must remain explicit user action." >&2
  exit 1
fi

echo "CinderOS security profile looks structurally valid."
