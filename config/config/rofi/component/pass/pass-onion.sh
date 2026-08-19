#!/bin/sh

base=${PASSWORD_STORE_DIR-~/.local/share/pass}
prefix="$base/links"
password_files=$(find "$prefix" -type f -name "*.gpg")
 
if [ -z "$1" ]
then
	printf '%s\n' "$password_files" | sed "s|$base/||;s|\.gpg$||"
else
	# echo "$1" | awk '{printf $1}' | xclip -selection clipboard > /dev/null 2>&1
	pass "$1" | wl-copy
	dunstify "$1 copied"
fi
