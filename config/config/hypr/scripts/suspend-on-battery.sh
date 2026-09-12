#!/bin/sh
# Suspend but only on battery.
#
# Usage: ./suspend-on-battery.sh          suspend if on battery
#        ./suspend-on-battery.sh --check  print mains|battery|unknown, exit 0

set -eu

supplies=${POWER_SUPPLY_DIR:-/sys/class/power_supply}

power_state() {
	found=0
	for s in "$supplies"/*; do
		[ -r "$s/type" ] || continue
		[ "$(cat "$s/type")" = Mains ] || continue
		found=1
		[ "$(cat "$s/online" 2>/dev/null || echo 0)" = 1 ] && { echo mains; return; }
	done
	[ "$found" = 1 ] && echo battery || echo unknown
}

state=$(power_state)

if [ "${1:-}" = --check ]; then
	echo "$state"
	exit 0
fi

[ "$state" = battery ] || exit 0
exec systemctl suspend
