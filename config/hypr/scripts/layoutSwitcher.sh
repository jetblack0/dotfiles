#!/bin/sh
# cycle through hyprland master and dwindle layout (currently only these two are available)

# Usage: ./layoutSwitcher.sh

current_layout=$(hyprctl getoption general:layout | grep "str" | cut -d " " -f 2 | tr -d '"')


if [ "$current_layout" = "master" ]
then
	hyprctl keyword general:layout dwindle
else
	hyprctl keyword general:layout master
fi
