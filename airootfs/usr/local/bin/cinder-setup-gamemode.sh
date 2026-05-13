#!/usr/bin/env bash
set -euo pipefail

if ! getent group gamemode >/dev/null; then
  sudo groupadd -r gamemode
fi

sudo usermod -aG gamemode "${USER}"
echo "GameMode group applied. Log out and back in for group changes to apply."

