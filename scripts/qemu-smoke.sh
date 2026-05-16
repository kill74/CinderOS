#!/usr/bin/env bash
set -euo pipefail

iso="${CINDEROS_ISO:-$HOME/cinderos-out/cinderos-1.0.0-x86_64.iso}"
firmware="auto"
disk=""
disk_size="40G"
ram="4096"
smp="4"
display="gtk"
log_path=""

die() {
  echo "$*" >&2
  exit 1
}

usage() {
  cat <<'MESSAGE'
Usage:
  scripts/qemu-smoke.sh [options] [iso]

Options:
  --firmware auto|uefi|bios  Firmware mode (default: auto)
  --disk PATH                Attach or create a qcow2 VM disk
  --disk-size SIZE           Size for a new --disk image (default: 40G)
  --ram MB                   Guest memory in MB (default: 4096)
  --smp N                    Guest CPU count (default: 4)
  --display gtk|sdl|none     QEMU display backend (default: gtk)
  --log PATH                 Save QEMU stdout/stderr to a log file
  -h, --help                 Show this help
MESSAGE
}

usage_error() {
  echo "$*" >&2
  usage >&2
  exit 2
}

require_value() {
  local option="$1"
  local value="${2:-}"
  if [[ -z "$value" ]]; then
    usage_error "$option requires a value."
  fi
}

iso_set=0
while (($# > 0)); do
  case "$1" in
    --firmware)
      require_value "$1" "${2:-}"
      firmware="${2:-}"
      shift 2
      ;;
    --disk)
      require_value "$1" "${2:-}"
      disk="${2:-}"
      shift 2
      ;;
    --disk-size)
      require_value "$1" "${2:-}"
      disk_size="${2:-}"
      shift 2
      ;;
    --ram)
      require_value "$1" "${2:-}"
      ram="${2:-}"
      shift 2
      ;;
    --smp)
      require_value "$1" "${2:-}"
      smp="${2:-}"
      shift 2
      ;;
    --display)
      require_value "$1" "${2:-}"
      display="${2:-}"
      shift 2
      ;;
    --log)
      require_value "$1" "${2:-}"
      log_path="${2:-}"
      shift 2
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    --)
      shift
      break
      ;;
    -*)
      usage_error "Unknown option: $1"
      ;;
    *)
      if [[ "$iso_set" -eq 1 ]]; then
        usage_error "Only one ISO path can be provided."
      fi
      iso="$1"
      iso_set=1
      shift
      ;;
  esac
done

if (($# > 0)); then
  if [[ "$iso_set" -eq 1 || "$#" -gt 1 ]]; then
    usage_error "Only one ISO path can be provided."
  fi
  iso="$1"
fi

case "$firmware" in
  auto|uefi|bios) ;;
  *)
    usage_error "Invalid firmware mode: $firmware"
    ;;
esac

case "$display" in
  gtk|sdl|none) ;;
  *)
    usage_error "Invalid display mode: $display"
    ;;
esac

if [[ ! -f "$iso" ]]; then
  die "ISO not found: $iso"
fi

if ! command -v qemu-system-x86_64 >/dev/null 2>&1; then
  die "qemu-system-x86_64 is required."
fi

ovmf_code=""
ovmf_vars=""
find_ovmf() {
  local pair code vars
  local candidates=(
    "/usr/share/edk2-ovmf/x64/OVMF_CODE.fd|/usr/share/edk2-ovmf/x64/OVMF_VARS.fd"
    "/usr/share/edk2-ovmf/OVMF_CODE.fd|/usr/share/edk2-ovmf/OVMF_VARS.fd"
    "/usr/share/ovmf/x64/OVMF_CODE.fd|/usr/share/ovmf/x64/OVMF_VARS.fd"
    "/usr/share/OVMF/OVMF_CODE.fd|/usr/share/OVMF/OVMF_VARS.fd"
  )

  for pair in "${candidates[@]}"; do
    IFS='|' read -r code vars <<<"$pair"
    if [[ -f "$code" && -f "$vars" ]]; then
      ovmf_code="$code"
      ovmf_vars="$vars"
      return 0
    fi
  done

  return 1
}

if [[ "$firmware" == "auto" ]]; then
  if find_ovmf; then
    firmware="uefi"
  else
    firmware="bios"
  fi
elif [[ "$firmware" == "uefi" ]]; then
  if ! find_ovmf; then
    echo "UEFI requested, but OVMF firmware was not found." >&2
    die "Install edk2-ovmf or use --firmware bios."
  fi
fi

if [[ -n "$disk" && ! -f "$disk" ]]; then
  if ! command -v qemu-img >/dev/null 2>&1; then
    die "qemu-img is required to create disk images."
  fi
  mkdir -p "$(dirname "$disk")"
  qemu-img create -f qcow2 "$disk" "$disk_size"
fi

qemu_args=(
  -name CinderOS-Smoke
  -m "$ram"
  -smp "$smp"
  -vga virtio
  -device intel-hda
  -device hda-duplex
  -nic user,model=virtio-net-pci
  -boot d
  -cdrom "$iso"
)

if [[ -e /dev/kvm ]]; then
  qemu_args+=(-enable-kvm -cpu host)
else
  qemu_args+=(-cpu max)
fi

case "$display" in
  gtk)
    qemu_args+=(-display gtk,gl=on)
    ;;
  sdl)
    qemu_args+=(-display sdl)
    ;;
  none)
    qemu_args+=(-display none -serial mon:stdio)
    ;;
esac

ovmf_vars_runtime=""
if [[ "$firmware" == "uefi" ]]; then
  ovmf_vars_runtime="$(mktemp --tmpdir cinderos-ovmf-vars.XXXXXX.fd)"
  cp "$ovmf_vars" "$ovmf_vars_runtime"
  qemu_args+=(
    -drive "if=pflash,format=raw,readonly=on,file=$ovmf_code"
    -drive "if=pflash,format=raw,file=$ovmf_vars_runtime"
  )
fi

if [[ -n "$disk" ]]; then
  qemu_args+=(-drive "file=$disk,format=qcow2,if=virtio")
fi

echo "ISO: $iso"
echo "Firmware: $firmware"
echo "Display: $display"
echo "RAM: $ram MB"
echo "CPUs: $smp"
if [[ -n "$disk" ]]; then
  echo "Disk: $disk"
fi
if [[ -n "$log_path" ]]; then
  mkdir -p "$(dirname "$log_path")"
  echo "Log: $log_path"
fi
echo

cleanup() {
  if [[ -n "$ovmf_vars_runtime" ]]; then
    rm -f "$ovmf_vars_runtime"
  fi
}
trap cleanup EXIT

if [[ -n "$log_path" ]]; then
  qemu-system-x86_64 "${qemu_args[@]}" 2>&1 | tee "$log_path"
else
  qemu-system-x86_64 "${qemu_args[@]}"
fi
