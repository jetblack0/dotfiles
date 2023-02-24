#!/bin/sh
# return {percentage, icon_path}

get() {
	is_mute=$(pamixer --get-mute)
	percentage=$(pamixer --get-volume)

	if [ "$is_mute" = "true" ] || [ "$percentage" -eq 0 ]
	then
		icon_path="./images/icons/volume/volume_mute.svg"
	else
		icon_path="./images/icons/volume/volume_normal.svg"
	fi

	echo "{\"percentage\":\"$percentage\",\"icon_path\":\"$icon_path\"}"
}

get
pactl subscribe | rg --line-buffered "change" | while read -r _
do
	get
done
