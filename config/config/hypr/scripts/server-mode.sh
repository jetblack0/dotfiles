#!/bin/sh
# Server mode: keep the laptop running with the lid closed, never sleep.
#
# The whole mode is one logind inhibitor lock, held by a transient user unit:
# while `systemd-inhibit --what=sleep:handle-lid-switch` is alive, closing the
# lid does nothing and nothing can suspend. The unit and the state file (in
# $XDG_RUNTIME_DIR, a tmpfs) both die with the session, so the mode never
# survives a reboot or logout. The noctalia jetblack0/server plugin polls the
# state file for its bar icon and control-center tile.
#
# Usage: ./server-mode.sh [toggle|on|off|status]

set -eu

unit=server-mode
state="${XDG_RUNTIME_DIR:?}/server-mode"

active() { systemctl --user is-active --quiet "$unit"; }

# the lock is taken a moment after the unit starts; a polkit refusal makes
# systemd-inhibit exit at once, so wait for the lock itself, not the unit
holding() { systemd-inhibit --list --no-legend 2>/dev/null | grep -q "server mode"; }

on() {
	active || systemd-run --user --unit="$unit" --collect --quiet \
		systemd-inhibit --what=sleep:handle-lid-switch --mode=block \
		--who="server mode" --why="stays up with the lid closed" \
		sleep infinity
	i=0
	until holding; do
		i=$((i + 1))
		if [ "$i" -gt 20 ]; then
			systemctl --user stop "$unit" 2>/dev/null || true
			rm -f "$state"
			echo "server-mode: could not take the inhibitor lock" >&2
			exit 1
		fi
		sleep 0.1
	done
	echo on >"$state"
}

off() {
	systemctl --user stop "$unit" 2>/dev/null || true
	rm -f "$state"
}

case "${1:-toggle}" in
	on) on ;;
	off) off ;;
	toggle) if active; then off; else on; fi ;;
	status)
		# heal a stale file if the unit died behind our back
		if active; then echo on; else rm -f "$state"; echo off; fi
		;;
	*)
		echo "usage: server-mode.sh [toggle|on|off|status]" >&2
		exit 2
		;;
esac
