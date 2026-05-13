#!/usr/bin/env bash
set -euo pipefail

work_dir="${CINDEROS_WORK_DIR:-/tmp/cinderos-work}"
resolved_work_dir="$(realpath -m "$work_dir")"

case "$resolved_work_dir" in
  /tmp/cinderos-work|/tmp/cinderos-work-*)
    ;;
  *)
    echo "Refusing to remove unsafe work directory: $resolved_work_dir" >&2
    echo "Use a path under /tmp/cinderos-work or /tmp/cinderos-work-*." >&2
    exit 1
    ;;
esac

if [[ ! -d "$resolved_work_dir" ]]; then
  echo "Build work directory does not exist: $resolved_work_dir"
  exit 0
fi

echo "Removing build work directory: $resolved_work_dir"
sudo rm -rf --one-file-system "$resolved_work_dir"
