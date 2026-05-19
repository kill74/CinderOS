#!/usr/bin/env bash
set -euo pipefail

profile_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
work_dir="${CINDEROS_WORK_DIR:-/tmp/cinderos-work}"
out_dir="${CINDEROS_OUT_DIR:-$HOME/cinderos-out}"

mkdir -p "$out_dir"

echo "Building CinderOS from: $profile_dir"
echo "Work directory: $work_dir"
echo "Output directory: $out_dir"

echo "Copying root documentation into the ISO payload..."
mkdir -p "$profile_dir/airootfs/usr/share/doc/cinderos"
cp "$profile_dir"/*.md "$profile_dir/airootfs/usr/share/doc/cinderos/" 2>/dev/null || true
cp "$profile_dir/docs"/*.md "$profile_dir/airootfs/usr/share/doc/cinderos/" 2>/dev/null || true

sudo mkarchiso -v -w "$work_dir" -o "$out_dir" "$profile_dir"

