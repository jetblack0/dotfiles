#!/bin/sh
# Swayimg key actions, invoked by init.lua as: sh actions.sh <action> <path>.

set -eu

action=${1:?usage: actions.sh <action> <path>}
path=${2:?usage: actions.sh <action> <path>}

abs=$(realpath -- "$path")
rel=$(realpath --relative-to="$PWD" -- "$path" 2>/dev/null || printf '%s' "$abs")
name=$(basename -- "$abs")

notify() {
	command -v notify-send >/dev/null 2>&1 && notify-send -a swayimg "$@" || true
}

case "$action" in
	wallpaper)
		noctalia msg wallpaper-set "$abs" && notify "Wallpaper set" "$name"
		;;
	copy-image)
		# wl-copy needs the mime type for images; file supplies it when
		# present, otherwise let wl-copy fall back to its own guess.
		mime=$(file -b --mime-type -- "$abs" 2>/dev/null || true)
		if [ -n "$mime" ]; then
			wl-copy --type "$mime" < "$abs"
		else
			wl-copy < "$abs"
		fi
		notify "Copied image" "$name"
		;;
	copy-abs)
		printf '%s' "$abs" | wl-copy && notify "Copied path" "$abs"
		;;
	copy-rel)
		printf '%s' "$rel" | wl-copy && notify "Copied path" "$rel"
		;;
	delete)
		rm -f -- "$abs" && notify "Deleted" "$name"
		;;
	*)
		printf 'unknown action: %s\n' "$action" >&2
		exit 2
		;;
esac
