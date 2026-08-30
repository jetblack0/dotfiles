#!/bin/sh
# Swap one of the config's swappable sets.
#
# Usage: ./hypr-switch.sh <kind> [--list | --current | --next | <name>]
#        kind = theme | animation
#
# Both kinds work the same way: options are the *.lua files in a conf/
# directory, the choice is a name in $XDG_STATE_HOME/hypr/<kind>, and the Lua
# side reads that name on the next config load.
#
# theme-switcher.sh and animation-switcher.sh are one-line wrappers over this;
# the two kinds differ only in the three values resolved below.

set -eu

here=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)

kind=${1:-}
case "$kind" in
	theme)     dir="$here/../conf/themes";     default="rose-pine" ;;
	animation) dir="$here/../conf/animations"; default="macos" ;;
	*)
		printf 'usage: %s <theme|animation> [--list | --current | --next | <name>]\n' "${0##*/}" >&2
		exit 2
		;;
esac
shift

dir=$(CDPATH= cd -- "$dir" && pwd)
state_dir="${XDG_STATE_HOME:-$HOME/.local/state}/hypr"
state_file="$state_dir/$kind"

list() {
	for path in "$dir"/*.lua; do
		name=${path##*/}
		name=${name%.lua}
		if [ "$name" != "init" ]; then
			printf '%s\n' "$name"
		fi
	done
}

current() {
	name=""
	if [ -r "$state_file" ]; then
		read -r name < "$state_file" || true
	fi
	if [ -n "$name" ]; then
		printf '%s\n' "$name"
	else
		printf '%s\n' "$default"
	fi
}

next() {
	list | awk -v cur="$(current)" '
		{ names[NR] = $0 }
		END {
			if (NR == 0) exit 1
			for (i = 1; i <= NR; i++) if (names[i] == cur) { print names[i % NR + 1]; exit }
			print names[1]
		}'
}

set_to() {
	# Refuse an unknown name before touching anything.
	if ! list | grep -qxF "$1"; then
		printf 'no such %s: %s\n\navailable:\n' "$kind" "$1" >&2
		list | sed 's/^/  /' >&2
		exit 1
	fi

	mkdir -p "$state_dir"

	# Written via a temp file so an interrupted switch leaves the previous
	# choice in place rather than an empty or half-written name.
	tmp=$(mktemp "$state_dir/$kind.XXXXXX")
	printf '%s\n' "$1" > "$tmp"
	mv -f "$tmp" "$state_file"

	# Only the state file changed and it lives outside ~/.config/hypr, so
	# nothing hyprland watches was touched.
	if [ -n "${HYPRLAND_INSTANCE_SIGNATURE:-}" ]; then
		hyprctl -q reload
	fi

	printf '%s\n' "$1"
}

case "${1:---current}" in
	--list)    list ;;
	--current) current ;;
	--next)    set_to "$(next)" ;;
	-*)
		printf 'usage: %s %s [--list | --current | --next | <name>]\n' "${0##*/}" "$kind" >&2
		exit 2
		;;
	*) set_to "$1" ;;
esac
