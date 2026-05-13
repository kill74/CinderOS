#!/usr/bin/env bash
set -euo pipefail

profile_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

if grep -Rqs 'Optional TrustAll' "$profile_dir/pacman.conf" "$profile_dir/airootfs/etc/pacman.conf"; then
  echo "Unsafe pacman SigLevel Optional TrustAll is active or documented in pacman configs." >&2
  exit 1
fi

if grep -RqsE 'sh -c "\$\(curl|curl .*\| *sh|curl .*\| *bash' "$profile_dir/airootfs/usr/local/bin" "$profile_dir/scripts"; then
  echo "Remote curl-to-shell installer pattern found." >&2
  exit 1
fi

for helper in "$profile_dir/airootfs/usr/local/bin/cinder-install-vencord.sh" "$profile_dir/airootfs/usr/local/bin/cinder-setup-zsh.sh"; do
  if ! grep -Fq "curl --fail --show-error --location --proto '=https' --tlsv1.2" "$helper"; then
    echo "Remote installer helper lacks hardened curl flags: $helper" >&2
    exit 1
  fi
  if ! grep -Fq 'Type ' "$helper"; then
    echo "Remote installer helper lacks explicit confirmation prompt: $helper" >&2
    exit 1
  fi
done

if ! grep -Fq 'Refusing to remove unsafe work directory' "$profile_dir/scripts/clean-build.sh"; then
  echo "clean-build.sh lacks destructive path guardrails." >&2
  exit 1
fi

passwordless_token="NO""PASSWD"
nopasswd_hits="$(grep -RIl "$passwordless_token" "$profile_dir" | grep -vF "$profile_dir/airootfs/etc/sudoers.d/00-cinderos-live" || true)"
if [[ -n "$nopasswd_hits" ]]; then
  echo "Passwordless sudo appears outside the live ISO sudoer:" >&2
  echo "$nopasswd_hits" >&2
  exit 1
fi

if grep -RqsE '(AKIA[0-9A-Z]{16}|ghp_[A-Za-z0-9_]{20,}|xox[baprs]-|BEGIN (RSA|OPENSSH|PRIVATE) KEY)' "$profile_dir"; then
  echo "Possible secret material found in repository files." >&2
  exit 1
fi

if grep -Rqs 'VK_ICD_FILENAMES=/usr/share/vulkan/icd.d/radeon_icd' "$profile_dir/airootfs/etc/environment" "$profile_dir/airootfs/etc/profile.d"; then
  echo "Unsafe global Radeon Vulkan ICD override found." >&2
  exit 1
fi

for file in "$profile_dir/airootfs/root/customize_airootfs.sh" "$profile_dir/airootfs/etc/calamares/modules/shellprocess-cinderos-post.conf"; do
  if grep -Eq 'systemctl enable.*(docker|cups|bluetooth|fwupd|sshd|fail2ban|usbguard|clamav-daemon|clamav-freshclam|auditd)' "$file"; then
    echo "Opt-in or heavy service is enabled in default install/live path: $file" >&2
    exit 1
  fi
done

echo "CinderOS senior audit checks passed."
