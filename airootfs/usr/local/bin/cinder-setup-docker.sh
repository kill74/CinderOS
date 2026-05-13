#!/usr/bin/env bash
set -euo pipefail

sudo systemctl enable --now docker.service
sudo usermod -aG docker "${USER}"

echo "Docker is enabled. Log out and back in for group changes to apply."

