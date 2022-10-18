#! /bin/sh

iconData="$HOME/.config/rofi/data/nerdIconData.txt"
if [ -z "$1" ]
then
	cat "$iconData"
	# awk '$1 != "#" {print $0}' "$iconData"
else
	echo "$1" | awk '{printf $1}' | xclip -selection clipboard > /dev/null 2>&1
	notify-send "$1"
fi
