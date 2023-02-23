#!/bin/sh

# Rofi calls the executable without arguments on startup. This should generate a list of options, separated by a newline (\n) (This can be changed by the script). If the user selects an option, rofi calls the executable with the text of that option as the first argument. If the script returns no entries, rofi quits.

emojiData="$HOME/.config/rofi/data/emojiData.txt"
 
if [ -z "$1" ]
then
	cat $emojiData
else
	# echo "$1" | awk '{printf $1}' | xclip -selection clipboard > /dev/null 2>&1
	echo "$1" | awk '{printf $1}' | wl-copy
	dunstify "$1 copied"
fi
