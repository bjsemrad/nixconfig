#!/usr/bin/env bash
# logout: exits the compositor based on XDG_CURRENT_DESKTOP

set -euo pipefail

case "${XDG_CURRENT_DESKTOP:-}" in
  Hyprland|hyprland)
    echo "Logging out of Hyprland..."
    hyprctl dispatch exit
    ;;
  Niri|niri)
    echo "Logging out of Niri..."
    niri msg action quit
    ;;
  Mango|mango)
    echo "Logging out of MangoWC..."
    mmsg -d quit
    ;;
  *)
    echo "Unknown or unsupported desktop: ${XDG_CURRENT_DESKTOP:-<unset>}"
    exit 1
    ;;
esac
