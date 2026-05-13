#!/usr/bin/env sh

export EDITOR="${EDITOR:-nvim}"
export VISUAL="${VISUAL:-code}"
export BROWSER="${BROWSER:-helium}"
export TERMINAL="${TERMINAL:-kitty}"
export XDG_CURRENT_DESKTOP="${XDG_CURRENT_DESKTOP:-COSMIC}"
export XDG_SESSION_DESKTOP="${XDG_SESSION_DESKTOP:-cosmic}"
export MOZ_ENABLE_WAYLAND=1
export QT_QPA_PLATFORM="${QT_QPA_PLATFORM:-wayland}"
export CLUTTER_BACKEND=wayland
export SDL_VIDEODRIVER=wayland
