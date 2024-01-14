#!/usr/bin/env bash
if pgrep -x rofi >/dev/null; then
	pkill rofi
else
    hyprctl clients | \
    awk '/title: ./ { gsub("\t*title: *", ""); print}' | \
     rofi -dmenu \
            -scroll-method 0 \
		    -kb-cancel Escape \
     | xargs -I{} hyprctl dispatch focuswindow "title:{}" 
fi

#-theme "$HOME"/.config/rofi/config/rounded-dark-grey.rasi \
 