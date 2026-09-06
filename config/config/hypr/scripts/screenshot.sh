#!/bin/sh
# Screenshot to the directory recorded in the hypr state file, and notify with
# the saved path.
#
# The directory lives in $XDG_STATE_HOME/hypr/screenshot-dir, seeded once from
# the per-host screenshot variable (ansible screenshot_directory / nix
# desktop.screenshotDirectory) but a plain writable file. Empty or missing
# means the XDG Pictures directory.
#
# Usage: ./screenshot.sh full     capture all outputs
#        ./screenshot.sh region   select a region interactively

set -eu

mode=${1:-full}

state="${XDG_STATE_HOME:-$HOME/.local/state}/hypr/screenshot-dir"
dir=""
[ -r "$state" ] && read -r dir < "$state" || true
[ -n "$dir" ] || dir="${XDG_PICTURES_DIR:-$HOME/Pictures}"
case "$dir" in
	"~")   dir="$HOME" ;;
	"~/"*) dir="$HOME/${dir#\~/}" ;;
esac

mkdir -p "$dir"
file="$dir/screenshot_$(date +%Y%m%d_%H%M%S).png"

case "$mode" in
	full)
		grim "$file"
		;;
	region)
		region=$(slurp) || exit 0            # cancelled selection -> stay silent
		grim -g "$region" "$file"
		;;
	*)
		echo "usage: ${0##*/} full|region" >&2
		exit 2
		;;
esac

wl-copy < "$file"
notify-send Screenshot "$file"
