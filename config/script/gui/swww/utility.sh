#!/bin/sh

base_dir="$HOME/Resources/media/pictures/wallpaper/landscape"
favorite="$HOME/.config/hypr/paths/favorite-wall"
options="
--transition-type grow
--transition-fps 60
"

case "$1" in
	random)
		swww img $options "$(rg --files "$base_dir" | sort -R | tail -n 1)"
		;;
	favorite)
		swww img $options "$favorite"
		;;
esac

