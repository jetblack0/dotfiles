#!/usr/bin/env bash

base=${PASSWORD_STORE_DIR-~/.local/share/pass}
prefix="$base/keys"
password_files=$(find "$prefix" -type f -name "*.gpg")

if [ -z "$1" ]
then
	printf '%s\n' "$password_files" | sed "s|$base/||;s|\.gpg$||"
else
	pass "$1" | wl-copy
	dunstify -I ~/.config/dunst/images/icons/key.svg "Pass" "password $1 copied into clipboard"
fi
