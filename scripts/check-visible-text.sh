#!/usr/bin/env bash
set -euo pipefail

profile_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

visible_paths=(
  "$profile_dir/README.md"
  "$profile_dir/CHANGELOG.md"
  "$profile_dir/DAILY_DRIVER.md"
  "$profile_dir/HARDWARE_MATRIX.md"
  "$profile_dir/KNOWN_ISSUES.md"
  "$profile_dir/QA_CHECKLIST.md"
  "$profile_dir/RELEASE.md"
  "$profile_dir/docs/VOICE.md"
  "$profile_dir/NOTES.md"
  "$profile_dir/efiboot"
  "$profile_dir/scripts/build-aur-repo.sh"
  "$profile_dir/scripts/release-evidence.sh"
  "$profile_dir/airootfs/usr/local/bin/cinder-control"
  "$profile_dir/airootfs/usr/local/bin/cinder-dev"
  "$profile_dir/airootfs/usr/local/bin/cinder-doctor"
  "$profile_dir/airootfs/usr/local/bin/cinder-game-check"
  "$profile_dir/airootfs/usr/local/bin/cinder-personal"
  "$profile_dir/airootfs/usr/local/bin/cinder-report"
  "$profile_dir/airootfs/usr/local/bin/cinder-welcome"
  "$profile_dir/airootfs/usr/share/applications"
  "$profile_dir/airootfs/etc/xdg/autostart/cinder-first-run.desktop"
  "$profile_dir/airootfs/etc/skel/Desktop/Install CinderOS.desktop"
  "$profile_dir/airootfs/etc/calamares/branding/cinderos"
  "$profile_dir/airootfs/usr/share/backgrounds/cinderos"
  "$profile_dir/airootfs/usr/share/cinderos/rice/cinderos-pixel.txt"
  "$profile_dir/airootfs/usr/share/plymouth/themes/cinderos"
  "$profile_dir/airootfs/usr/share/grub/themes/cinderos"
  "$profile_dir/airootfs/usr/share/doc/cinderos"
)

banned_pattern='generated from|generated ISO|provided JSON spec|scaffold|placeholder|stubs|evidence-based|current system state|report capture|readiness|tooling|workflow|Fast paths|Good first|worth checking|marked as passed|marked as daily-driver|Confirm |failure evidence|user state directory|target hardware path|target layout|Filesystem target|evidence file path|local status validation|expected to be active|default desktop expects|rollback expects|testers usually ask|timestamped report under|before calling|Game readiness|Save personal setup|Restore personal setup|Projects folder|Full-stack setup|Database status|Dev status|Optional setup helpers|modern experience|POLISHED PIXEL EMBER|READY TO IGNITE|EMBER INSTALLATION TERMINAL|Polished Pixel Ember|Retro Ember boot splash|select a boot profile|polished workstation|Game Friendly|Developer Comfortable|Hardware Ready|built into the base experience|modern shell defaults are waiting|Start hub|visual rice|rice controls|gaming setup|post-install helpers|CinderOS Control'

hits="$(grep -RInE "$banned_pattern" "${visible_paths[@]}" || true)"
if [[ -n "$hits" ]]; then
  echo "Visible text still has rough or over-marketed wording:" >&2
  echo "$hits" >&2
  exit 1
fi

echo "CinderOS visible text looks clean."
