#!/bin/sh
# $1: title, artists, album, return corresponding information

title() {
	mpc current -f %title%
}

album() {
	mpc current -f %album%
}

artists() {
	mpc current -f %artist%
}

init() {
	if [ "$(systemctl --user is-active mpd)" = "active" ] && [ -n "$(mpc current)" ]
	then
		case "$1" in
			"title") title ;;
			"album") album ;;
			"artists") artists ;;
		esac
	fi
}

REFRESH_RATE=1
while true
do
	init "$1"
	sleep $REFRESH_RATE
done

