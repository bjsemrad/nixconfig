#!/usr/bin/env bash
if pgrep -x rofi >/dev/null; then
	pkill rofi
else
	rofi \
		-show drun \
		-scroll-method 0 \
		-terminal alacritty \
		-kb-cancel Escape \
		-theme "$HOME"/.config/rofi/style.rasi

fi