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
#        ./screenshot.sh edit     select a region and open it in satty, which
#                                 saves to the same directory and copies on
#                                 its own save and copy buttons

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
		# frozen screen, so open panels survive the selection (region-grab.sh)
		tmp="$file.part"
		if ! "${0%/*}/region-grab.sh" >"$tmp"; then
			rm -f "$tmp"                     # cancelled selection -> stay silent
			exit 0
		fi
		mv "$tmp" "$file"
		;;
	edit)
		tmp=$(mktemp --suffix=.png)
		trap 'rm -f "$tmp"' EXIT
		if ! "${0%/*}/region-grab.sh" >"$tmp"; then
			exit 0                           # cancelled selection -> stay silent
		fi
		# opens on the blur tool for censoring; satty notifies on save/copy
		satty --filename "$tmp" --output-filename "$file" \
			--copy-command wl-copy --initial-tool blur --early-exit
		exit 0
		;;
	*)
		echo "usage: ${0##*/} full|region|edit" >&2
		exit 2
		;;
esac

wl-copy < "$file"
notify-send Screenshot "$file"
