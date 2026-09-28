#!/bin/sh
# Toggle the built-in touchpad, without pinning a device name. External
# touchpads are left alone. udev labels each touchpad internal or external
# in ID_INPUT_TOUCHPAD_INTEGRATION.
#
# Usage: ./trackpad-toggle.sh [toggle|on|off|init]     (default: toggle)

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
		props=$(udevadm info -q property -n "$ev" 2>/dev/null) || continue
		printf '%s\n' "$props" | grep -qx 'ID_INPUT_TOUCHPAD=1' || continue
		# Skip external touchpads rather than require internal ones. Only a
		# device with no bus goes unlabelled, and USB and bluetooth devices
		# always have one. So an unlabelled touchpad is almost surely
		# built-in, and requiring "internal" would drop it.
		printf '%s\n' "$props" | grep -qx 'ID_INPUT_TOUCHPAD_INTEGRATION=external' && continue
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
