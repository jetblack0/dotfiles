#! /bin/bash

# display all the layout on the rofi menu, i usually just use two monitors, need to change code if need more
getLayout() {
	for primary in "${monitors[@]}"; do
		echo "only $primary"
		for second in "${monitors[@]}"; do
			for direction in "${directions[@]}"; do
				if [ "$second" != "$primary" ]; then
					echo "$primary + $second ($direction)"
				fi
			done
		done
	done
}

# turn off other monitors when choose only mode
keepAlive() {
	for monitor in "${monitors[@]}"
	do
		if [ "$monitor" != "$1" ]
		then
			xrandr --output "$monitor" --off
		fi
	done
}

# I need to change the picom config when use external monitors because i'm in nvidia, you don't need this
tune() {
	echo "foo"
}

# get connected monitor
monitors=($(xrandr | tail -n +2 | awk '/^\S/ {print $0}' | awk '$2 == "connected" {print $1}'))
# directions for monitor layout (i don't use below)
directions=("right" "left" "above")


if [ -z "$1" ]
then
	getLayout
else
	options=(${1//[+()]/})

	if [ "${options[0]}" = only ]
	then
		keepAlive "${options[1]}"
		xrandr --output "${options[1]}" --auto
	else
		xrandr --output "${options[0]}" --auto --output "${options[1]}" --auto --"${options[2]}"-of "${options[0]}"
	fi
fi
