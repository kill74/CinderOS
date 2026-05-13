#!/usr/bin/env bash
set -euo pipefail

profile_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
package_file="$profile_dir/packages.x86_64"

if ! command -v pacman >/dev/null 2>&1; then
  echo "pacman is not available on this host. Run this on an Arch based build machine." >&2
  exit 1
fi

mapfile -t packages < <(grep -Ev '^\s*(#|$)' "$package_file" | sort -u)

missing=()
for package in "${packages[@]}"; do
  if ! pacman -Si "$package" >/dev/null 2>&1; then
    missing+=("$package")
  fi
done

if (( ${#missing[@]} > 0 )); then
  echo "Packages missing from the configured pacman sync databases:" >&2
  printf '  %s\n' "${missing[@]}" >&2
  exit 1
fi

echo "All packages in packages.x86_64 are resolvable by pacman."

