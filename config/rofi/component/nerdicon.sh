#!/bin/sh

# HACK: there are always some weird icons don't display properly

icon_data="$HOME/.config/rofi/data/nerdicon"
if [ -z "$1" ]
then
	cat "$icon_data"
	# awk '$1 != "#" {print $0}' "$iconData"
else
	# echo "$1" | awk '{printf $1}' | xclip -selection clipboard > /dev/null 2>&1
	echo "$1" | awk '{printf $1}' | wl-copy
	dunstify "$1"
fi
