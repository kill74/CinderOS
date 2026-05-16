#!/usr/bin/env bash
set -euo pipefail

repo_dir="${CINDEROS_AUR_REPO:-$HOME/cinderos-aur-repo}"
package_list="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)/packages.aur"

mkdir -p "$repo_dir"

cat <<'MESSAGE'
AUR package steps:

1. Build packages from packages.aur in a clean chroot.
2. Copy built .pkg.tar.zst files into $CINDEROS_AUR_REPO.
3. Run: repo-add cinderos-aur.db.tar.gz *.pkg.tar.zst
4. Add that local or hosted repo to pacman.conf before running mkarchiso.

The script intentionally does not run arbitrary PKGBUILDs automatically.
MESSAGE

echo "AUR package list: $package_list"
echo "Repo directory: $repo_dir"
