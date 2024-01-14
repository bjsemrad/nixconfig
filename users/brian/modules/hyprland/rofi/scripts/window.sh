#!/usr/bin/env bash
if pgrep -x rofi >/dev/null; then
	pkill rofi
else
     rofi -show window \
            -scroll-method 0 \
	       -kb-cancel Escape \
            -theme "$HOME"/.config/rofi/style.rasi 
fi