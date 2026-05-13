#!/usr/bin/env bash
set -euo pipefail

if ! command -v paru >/dev/null 2>&1; then
  echo "paru is required for proton-ge-custom. Install paru or prebuild proton-ge-custom first." >&2
  exit 1
fi

paru -S --noconfirm proton-ge-custom
mkdir -p "${HOME}/.steam/root/compatibilitytools.d"
ln -sfn /usr/share/steam/compatibilitytools.d/proton-ge-custom "${HOME}/.steam/root/compatibilitytools.d/proton-ge-custom"

