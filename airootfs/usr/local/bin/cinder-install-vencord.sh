#!/usr/bin/env bash
set -euo pipefail

url="https://raw.githubusercontent.com/Vendicated/VencordInstaller/main/install.sh"

if [[ "${1:-}" != "--yes" ]]; then
  cat <<'MESSAGE'
CinderOS will download and run the upstream Vencord installer.
Only continue if you trust the upstream project and your network connection.
MESSAGE
  printf 'Type VENCORD to continue: '
  read -r answer
  if [[ "$answer" != "VENCORD" ]]; then
    echo "Canceled."
    exit 1
  fi
fi

tmp="$(mktemp)"
trap 'rm -f "$tmp"' EXIT
curl --fail --show-error --location --proto '=https' --tlsv1.2 "$url" -o "$tmp"
sh "$tmp"
