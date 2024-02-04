#!/usr/bin/env bash
if pgrep -x rofi >/dev/null; then
	pkill rofi
else
	selection=$(cliphist list |
		rofi \
			-dmenu \
			-scroll-method 0 \
			-kb-cancel Escape \
			-theme "$HOME"/.config/rofi/style.rasi)
	if [ $? -eq 0 ]; then
		echo "$selection" | cliphist decode | wl-copy
	fi
fi