#!/usr/bin/env bash
if pgrep -x rofi >/dev/null; then
	pkill rofi
else
	rofi \
		-show drun \
		-scroll-method 0 \
		-terminal alacritty \
		-kb-cancel Escape 
fi

#		-theme "$HOME"/.config/rofi/config/rounded-dark-grey.rasi
