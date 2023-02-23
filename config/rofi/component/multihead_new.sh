#!/bin/bash

# HACK: kinda hard to do, i give up
get_monitors() {
	while read -r monitor
	do
		if [ "$(cat "$monitor")" = "disconnected" ]
		then
			connected_monitor=$(echo "$monitor" | cut -d "/" -f 9 | cut -d "-" -f 2-)
			echo "$connected_monitor"
			connected_monitors+=("$connected_monitor")
		fi
	done <<< "$(find /sys/devices/pci0000:00/0000:00:01.0/0000:01:00.0/drm/card0 -type f -name "status")"

	for ((i = 0; i < ${#connected_monitors[@]}; i++)); do
		for ((j = $(( "$i" + 1 )); j < ${#connected_monitors[@]}; j++)); do
			echo "${connected_monitors[$i]} ${connected_monitors[$j]}"
		done
	done
}

set_monitors() {
	for monitor in $1
	do
		hyprctl keyword monitor "${monitor}",1920x1080@60
	done
}

get_monitors
# echo "${connected_monitors[@]}"

# if [ -z "$1" ]
# then
# 	echo
# fi


# find /sys/devices/pci0000:00/0000:00:01.0/0000:01:00.0/drm/card0 -type f -name "status" | while read -r line
# do
# 	cat "$line"
# done

