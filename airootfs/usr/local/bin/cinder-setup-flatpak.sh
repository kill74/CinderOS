#!/usr/bin/env bash
set -euo pipefail

if ! command -v flatpak >/dev/null 2>&1; then
  echo "flatpak is not installed." >&2
  exit 1
fi

if [[ "${EUID}" -ne 0 && "${1:-}" == "--system" ]]; then
  exec sudo "$0" "$@"
fi

if [[ "${1:-}" == "--system" || "${EUID}" -eq 0 ]]; then
  flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
else
  flatpak remote-add --user --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
fi

echo "Flathub is configured."

