#!/bin/bash

STATE_FILE="/tmp/hypr_resize_state"

STATE=$(cat "$STATE_FILE" 2>/dev/null || echo 0)

SIZES=(25 50 75)

STATE=$(( (STATE + 1) % ${#SIZES[@]} ))

NEW_SIZE=${SIZES[$STATE]}
echo $NEW_SIZE

hyprctl dispatch resizeactive exact $NEW_SIZE% $NEW_SIZE%

echo $STATE > "$STATE_FILE"
