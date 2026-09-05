#!/bin/sh
# One replaceable notification per tag.
#
# Usage: ./notify-tag.sh <tag> show [-t <ms>] <summary> [<body>]
#        ./notify-tag.sh <tag> close

set -eu

tag=${1:?usage: notify-tag.sh <tag> show|close ...}
action=${2:?usage: notify-tag.sh <tag> show|close ...}
shift 2

state_dir="${XDG_STATE_HOME:-$HOME/.local/state}/hypr"
id_file="$state_dir/notif-$tag"

old=""
if [ -r "$id_file" ]; then
	read -r old < "$id_file" || true
fi

case "$action" in
	show)
		command -v notify-send >/dev/null 2>&1 || exit 0

		t=1500
		if [ "${1:-}" = "-t" ]; then
			t=$2
			shift 2
		fi

		mkdir -p "$state_dir"
		if [ -n "$old" ]; then
			new=$(notify-send -a Hyprland -t "$t" -p -r "$old" "$@") || exit 0
		else
			new=$(notify-send -a Hyprland -t "$t" -p "$@") || exit 0
		fi
		printf '%s\n' "$new" > "$id_file"
		;;
	close)
		if [ -n "$old" ]; then
			busctl --user call org.freedesktop.Notifications \
				/org/freedesktop/Notifications org.freedesktop.Notifications \
				CloseNotification u "$old" >/dev/null 2>&1 || true
			rm -f "$id_file"
		fi
		;;
	*)
		printf 'usage: %s <tag> show [-t <ms>] <summary> [<body>] | <tag> close\n' "${0##*/}" >&2
		exit 2
		;;
esac
