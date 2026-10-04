#!/usr/bin/env bash
# logout: exits the running compositor
#
# Detects the compositor by its own socket variables first, then XDG_CURRENT_DESKTOP: Hyprland
# keeps whatever XDG_CURRENT_DESKTOP it inherited, so that alone can name the wrong one.

set -euo pipefail

desktop="${XDG_CURRENT_DESKTOP:-}"
if [ -n "${HYPRLAND_INSTANCE_SIGNATURE:-}" ]; then
  desktop=Hyprland
elif [ -n "${NIRI_SOCKET:-}" ]; then
  desktop=niri
fi

case "$desktop" in
  *Hyprland*|*hyprland*)
    echo "Logging out of Hyprland..."
    hyprctl dispatch 'hl.dsp.exit()'
    # Hyprland leaves hyprland-session.target, and with it graphical-session.target, running
    # after it exits, so the next compositor's session never starts its services. Take it down.
    systemctl --user stop hyprland-session.target graphical-session.target || true
    ;;
  *Niri*|*niri*)
    echo "Logging out of Niri..."
    niri msg action quit
    ;;
  *Mango*|*mango*)
    echo "Logging out of MangoWC..."
    mmsg -d quit
    ;;
  *)
    echo "Unknown or unsupported desktop: ${XDG_CURRENT_DESKTOP:-<unset>}"
    exit 1
    ;;
esac
