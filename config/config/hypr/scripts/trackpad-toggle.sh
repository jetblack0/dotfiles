#!/bin/sh
# Toggle every touchpad on this machine, without pinning a device name.
#
# Usage: ./trackpad-toggle.sh [toggle|on|off|init]     (default: toggle)
#
# Discovery is udev's ID_INPUT_TOUCHPAD tag, so it works for any touchpad on
# any laptop, device names like "synaptics-tm3276-022" never appear in the
# config.
#
# The result is written to $XDG_STATE_HOME/hypr/trackpad as on|off|none; the
# Noctalia bar widget renders that file, and "none" hides it entirely.

set -eu

state_dir="${XDG_STATE_HOME:-$HOME/.local/state}/hypr"
state_file="$state_dir/trackpad"

action=${1:-toggle}
case "$action" in
	toggle|on|off|init) ;;
	*) echo "usage: ${0##*/} [toggle|on|off|init]" >&2; exit 2 ;;
esac

notify() {
	command -v notify-send >/dev/null 2>&1 && notify-send "Trackpad" "$1" || true
}

# One libinput name per line. sysfs name lives beside the event node.
touchpads=$(
	for ev in /dev/input/event*; do
		[ -e "$ev" ] || continue
		udevadm info -q property -n "$ev" 2>/dev/null \
			| grep -qx 'ID_INPUT_TOUCHPAD=1' || continue
		cat "/sys/class/input/${ev##*/}/device/name" 2>/dev/null || true
	done | sort -u
)

mkdir -p "$state_dir"

if [ -z "$touchpads" ]; then
	echo "none" > "$state_file"
	[ "$action" = init ] || notify "no touchpad on this machine"
	exit 0
fi

recorded=$(cat "$state_file" 2>/dev/null || echo on)
case "$action" in
	toggle) [ "$recorded" = off ] && target=on || target=off ;;
	init)   [ "$recorded" = off ] && target=off || target=on ;;
	*)      target=$action ;;
esac

[ "$target" = on ] && enabled=true || enabled=false

printf '%s\n' "$touchpads" | while IFS= read -r name; do
	[ -n "$name" ] || continue
	hlname=$(printf '%s' "$name" | tr ' ,\n' '---' | tr '[:upper:]' '[:lower:]')
	hyprctl eval "hl.device({ name = \"$hlname\", enabled = $enabled })" >/dev/null
done

echo "$target" > "$state_file"
