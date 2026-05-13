#!/usr/bin/env bash
set -euo pipefail

url="https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh"

if [[ "${1:-}" != "--yes" ]]; then
  cat <<'MESSAGE'
CinderOS will switch your shell to zsh and download the upstream Oh My Zsh installer.
Only continue if you trust the upstream project and your network connection.
MESSAGE
  printf 'Type ZSH to continue: '
  read -r answer
  if [[ "$answer" != "ZSH" ]]; then
    echo "Canceled."
    exit 1
  fi
fi

chsh -s /bin/zsh "${USER}"
tmp="$(mktemp)"
trap 'rm -f "$tmp"' EXIT
curl --fail --show-error --location --proto '=https' --tlsv1.2 "$url" -o "$tmp"
RUNZSH=no CHSH=no sh "$tmp" --unattended
