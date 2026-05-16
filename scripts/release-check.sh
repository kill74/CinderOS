#!/usr/bin/env bash
set -euo pipefail

profile_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

echo "== Bash syntax =="
checked=0
while IFS= read -r -d '' file; do
  first_line="$(head -n 1 "$file" 2>/dev/null || true)"
  if [[ "$first_line" != *bash* ]]; then
    continue
  fi

  bash -n "$file"
  checked=$((checked + 1))
done < <(
  find \
    "$profile_dir/scripts" \
    "$profile_dir/airootfs/usr/local/bin" \
    "$profile_dir/airootfs/root" \
    "$profile_dir/airootfs/etc/calamares/scripts" \
    -type f -print0
)
echo "Checked $checked Bash scripts."

echo
echo "== Python syntax =="
python_bin=""
if command -v python3 >/dev/null 2>&1; then
  python_bin="python3"
elif command -v python >/dev/null 2>&1; then
  python_bin="python"
fi

if [[ -n "$python_bin" ]]; then
  "$python_bin" - "$profile_dir/airootfs/usr/local/bin/cinder-control" <<'PY'
import ast
import pathlib
import sys

path = pathlib.Path(sys.argv[1])
ast.parse(path.read_text(encoding="utf-8"), filename=str(path))
print("cinder-control syntax OK")
PY
else
  echo "python is not available; skipping cinder-control AST check on this host."
fi

echo
echo "== Profile validation =="
bash "$profile_dir/scripts/validate-profile.sh"

echo
echo "== Code style =="
bash "$profile_dir/scripts/check-code-style.sh"

echo
echo "== Visible text =="
bash "$profile_dir/scripts/check-visible-text.sh"

echo
echo "== Daily driver guardrails =="
for tool in cinder-doctor cinder-report cinder-update; do
  if [[ ! -f "$profile_dir/airootfs/usr/local/bin/$tool" ]]; then
    echo "Missing daily-driver tool: $tool" >&2
    exit 1
  fi
done

for package in linux-lts linux-lts-headers; do
  if ! grep -Eq "^\s*${package}\s*$" "$profile_dir/packages.x86_64"; then
    echo "Missing daily-driver package: $package" >&2
    exit 1
  fi
done

if ! grep -Fq 'vmlinuz-linux-lts' "$profile_dir/grub/grub.cfg"; then
  echo "Live GRUB config is missing the Linux LTS fallback entry." >&2
  exit 1
fi

if grep -RqsE '^\s*(nvidia|nvidia_modeset|nvidia_uvm|nvidia_drm)\s*$' "$profile_dir/airootfs/etc/modules-load.d"; then
  echo "NVIDIA modules must not be globally loaded from modules-load.d." >&2
  exit 1
fi

if grep -Eq '^\s*MODULES=.*nvidia' "$profile_dir/airootfs/etc/mkinitcpio.conf.d/cinderos.conf"; then
  echo "NVIDIA modules must not be globally included in mkinitcpio defaults." >&2
  exit 1
fi

if [[ -e "$profile_dir/airootfs/etc/modprobe.d/nvidia.conf" ]]; then
  echo "NVIDIA modprobe settings must be written only after detected hardware setup." >&2
  exit 1
fi

echo "Daily-driver guardrails OK"

echo
echo "== Package verification =="
if command -v pacman >/dev/null 2>&1; then
  bash "$profile_dir/scripts/verify-arch-packages.sh"
else
  echo "pacman is not available; skipping package verification on this host."
fi

echo
echo "CinderOS release checks completed."
