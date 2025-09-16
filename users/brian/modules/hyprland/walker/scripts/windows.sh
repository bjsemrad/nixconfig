#!/bin/bash
monitor_height=$(hyprctl monitors -j | jq -r '.[] | select(.focused == true) | .height')
menu_height=$((monitor_height * 40 / 100))

# Get selected entry from walker
selection=$(hyprctl clients -j | jq -r '.[] | "\(.title) [\(.class)]::\(.address)"' | walker --dmenu -w 800 -h "$menu_height" )

# Extract window ID from the selection
window_id=$(echo "$selection" | awk -F'::' '{print $2}')

# Focus the selected window
if [[ -n "$window_id" ]]; then
    hyprctl dispatch focuswindow address:$window_id
fi
