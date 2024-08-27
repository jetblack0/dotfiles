#!/bin/sh

base_dir="$HOME/Resources/media/pictures/wallpaper/landscape"
favorite="$base_dir"/nature/flowers.png

case "$1" in
	random)
		swww img "$(rg --files "$base_dir" | sort -R | tail -n 1)"
		;;
	favorite)
		swww img "$favorite"
		;;
esac

