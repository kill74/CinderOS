#!/usr/bin/env bash
set -euo pipefail

profile_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
iso="${CINDEROS_ISO:-$HOME/cinderos-out/cinderos-1.0.0-x86_64.iso}"
evidence_root="${CINDEROS_EVIDENCE_DIR:-$HOME/cinderos-out/evidence}"
allow_missing_iso=0

die() {
  echo "$*" >&2
  exit 1
}

usage() {
  cat <<'MESSAGE'
Usage:
  scripts/release-evidence.sh [--allow-missing-iso]

Environment:
  CINDEROS_ISO           ISO path to record
  CINDEROS_EVIDENCE_DIR  Directory where evidence folders are written
MESSAGE
}

usage_error() {
  echo "$*" >&2
  usage >&2
  exit 2
}

while (($# > 0)); do
  case "$1" in
    --allow-missing-iso)
      allow_missing_iso=1
      shift
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      usage_error "Unknown argument: $1"
      ;;
  esac
done

if [[ ! -f "$iso" && "$allow_missing_iso" -ne 1 ]]; then
  echo "ISO not found: $iso" >&2
  die "Build the ISO first, set CINDEROS_ISO, or pass --allow-missing-iso for a pre-build evidence run."
fi

timestamp="$(date +%Y%m%d-%H%M%S)"
evidence_dir="$evidence_root/cinderos-1.0.0-$timestamp"
release_check_log="$evidence_dir/release-check.log"
evidence_file="$evidence_dir/evidence.md"

mkdir -p "$evidence_dir"

release_check_exit=0
set +e
bash "$profile_dir/scripts/release-check.sh" >"$release_check_log" 2>&1
release_check_exit=$?
set -e

package_status="unknown"
if grep -Fq "All packages in packages.x86_64 are resolvable by pacman." "$release_check_log"; then
  package_status="passed"
elif grep -Fq "pacman is not available; skipping package verification" "$release_check_log"; then
  package_status="skipped: pacman unavailable"
elif grep -Fq "Packages missing from the configured pacman sync databases:" "$release_check_log"; then
  package_status="failed: missing packages"
fi

git_branch="unavailable"
git_commit="unavailable"
git_status="unavailable"
if command -v git >/dev/null 2>&1 && git -C "$profile_dir" rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  git_branch="$(git -C "$profile_dir" branch --show-current 2>/dev/null || true)"
  if [[ -z "$git_branch" ]]; then
    git_branch="detached"
  fi
  git_commit="$(git -C "$profile_dir" rev-parse --short HEAD 2>/dev/null || echo unavailable)"
  git_status="$(git -C "$profile_dir" status --short 2>/dev/null || true)"
  if [[ -z "$git_status" ]]; then
    git_status="clean"
  fi
fi

iso_status="missing"
iso_size="n/a"
iso_sha256="n/a"
if [[ -f "$iso" ]]; then
  iso_status="present"
  iso_size="$(stat -c '%s bytes' "$iso" 2>/dev/null || wc -c <"$iso")"
  if command -v sha256sum >/dev/null 2>&1; then
    iso_sha256="$(sha256sum "$iso" | awk '{ print $1 }')"
  else
    iso_sha256="sha256sum unavailable"
  fi
fi

cat >"$evidence_file" <<EOF
# CinderOS Release Evidence

## Build

- Created: $(date -Is 2>/dev/null || date)
- Host: $(hostname 2>/dev/null || echo unknown)
- Kernel: $(uname -srmo 2>/dev/null || uname -a)
- User: ${USER:-unknown}
- Repo: $profile_dir

## Git

- Branch: $git_branch
- Commit: $git_commit

\`\`\`text
$git_status
\`\`\`

## ISO

- Path: $iso
- Status: $iso_status
- Size: $iso_size
- SHA256: $iso_sha256

## Release Check

- Exit code: $release_check_exit
- Package verification: $package_status
- Log: $release_check_log

## QEMU

- UEFI boot:
- BIOS boot:
- QEMU command:
- Notes:

## Install

- Install type:
- Installed boot:
- Login:
- Live cleanup:
- Notes:

## Hardware

- Machine:
- CPU:
- GPU:
- RAM:
- Result in HARDWARE_MATRIX.md:

## Rollback

- Snapper setup:
- Manual snapshot:
- GRUB snapshot entries:
- Rollback tested:

## Cinder Report

- Command:
- Report path:
- Notes:
EOF

echo "Release evidence written to: $evidence_file"
exit "$release_check_exit"
