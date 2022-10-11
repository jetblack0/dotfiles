#! /bin/sh

# ﯙ	github face this line doesn't show properly, deleted from data file
iconData="$HOME/.config/rofi/data/nerdIconData.txt"
if [ -z "$1" ]
then
	cat "$iconData"
else
	echo "$1" | awk '{printf $1}' | xclip -selection clipboard > /dev/null 2>&1
	notify-send "$1"
fi
