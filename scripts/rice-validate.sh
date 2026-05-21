#!/usr/bin/env bash
set -euo pipefail

profile_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

required=(
  "$profile_dir/airootfs/usr/local/bin/cinder-rice"
  "$profile_dir/airootfs/usr/share/applications/cinder-rice.desktop"
  "$profile_dir/airootfs/usr/share/cinderos/rice/palette.conf"
  "$profile_dir/airootfs/usr/share/cinderos/rice/cinderos-pixel.txt"
  "$profile_dir/airootfs/usr/share/backgrounds/cinderos/default.svg"
  "$profile_dir/airootfs/usr/share/backgrounds/cinderos/default.jpg"
  "$profile_dir/airootfs/usr/share/grub/themes/cinderos/background.jpg"
  "$profile_dir/airootfs/etc/calamares/branding/cinderos/cinderos-wallpaper.svg"
  "$profile_dir/airootfs/root/custom_files/usr/share/cosmic/com.system76.CosmicBackground/v1/all"
  "$profile_dir/airootfs/root/custom_files/usr/share/cosmic/com.system76.CosmicBackground/v1/backgrounds"
  "$profile_dir/airootfs/etc/skel/.config/kitty/kitty.conf"
  "$profile_dir/airootfs/etc/skel/.config/starship.toml"
  "$profile_dir/airootfs/etc/skel/.config/fastfetch/config.jsonc"
  "$profile_dir/airootfs/etc/skel/.config/btop/btop.conf"
  "$profile_dir/airootfs/etc/skel/.config/btop/themes/cinderos_ember.theme"
)

for path in "${required[@]}"; do
  if [[ ! -e "$path" ]]; then
    echo "Missing appearance file: $path" >&2
    exit 1
  fi
done

if ! grep -Fq 'name=polished-pixel-ember' "$profile_dir/airootfs/usr/share/cinderos/rice/palette.conf"; then
  echo "Appearance palette name is missing." >&2
  exit 1
fi

for color in '#151515' '#242424' '#f2e7d5' '#ff7a1a' '#ff9f3f'; do
  if ! grep -Rqs "$color" \
    "$profile_dir/airootfs/usr/share/cinderos/rice" \
    "$profile_dir/airootfs/usr/share/backgrounds/cinderos/default.svg" \
    "$profile_dir/airootfs/etc/skel/.config" \
    "$profile_dir/airootfs/etc/calamares/branding/cinderos"; then
    echo "Appearance color is not represented in default assets/configs: $color" >&2
    exit 1
  fi
done

if grep -RqsE '#(120f0d|160f0c|24130c|3a1b0c|e05a00|ffb15a|f5e3c8|f6e7d2)' \
  "$profile_dir/airootfs/usr/share/backgrounds/cinderos/default.svg" \
  "$profile_dir/airootfs/usr/share/pixmaps/cinderos-logo.svg" \
  "$profile_dir/airootfs/etc/calamares/branding/cinderos" \
  "$profile_dir/airootfs/etc/skel/.config"; then
  echo "Old brown Ember palette remains in appearance assets." >&2
  exit 1
fi

if ! grep -Fq 'source: Path("/usr/share/backgrounds/cinderos/default.jpg")' "$profile_dir/airootfs/root/custom_files/usr/share/cosmic/com.system76.CosmicBackground/v1/all"; then
  echo "COSMIC default wallpaper does not point at the CinderOS wallpaper." >&2
  exit 1
fi

if ! grep -Fq 'filter_method: Nearest' "$profile_dir/airootfs/root/custom_files/usr/share/cosmic/com.system76.CosmicBackground/v1/all"; then
  echo "COSMIC wallpaper should use nearest filtering for pixel art." >&2
  exit 1
fi

if ! grep -Fq 'palette = "cinder"' "$profile_dir/airootfs/etc/skel/.config/starship.toml"; then
  echo "Starship does not use the CinderOS palette." >&2
  exit 1
fi

if ! grep -Fq 'cinderos_ember' "$profile_dir/airootfs/etc/skel/.config/btop/btop.conf"; then
  echo "btop does not use the CinderOS theme." >&2
  exit 1
fi

if ! grep -Fq 'def appearance_page' "$profile_dir/airootfs/usr/local/bin/cinder-control"; then
  echo "CinderOS Settings is missing the Appearance page." >&2
  exit 1
fi

if ! grep -Fq 'self.add_alias("rice", "appearance")' "$profile_dir/airootfs/usr/local/bin/cinder-control"; then
  echo "CinderOS Settings does not keep --page rice compatible with Appearance." >&2
  exit 1
fi

if ! grep -Fq '["/usr/local/bin/cinder-rice"]' "$profile_dir/profiledef.sh"; then
  echo "cinder-rice is missing from profiledef file permissions." >&2
  exit 1
fi

if grep -Rqs 'cinder-rice' "$profile_dir/airootfs/etc/xdg/xfce4"; then
  echo "XFCE Lite should not receive COSMIC-specific rice hooks." >&2
  exit 1
fi

echo "CinderOS appearance assets look structurally valid."
