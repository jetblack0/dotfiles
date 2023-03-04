#!/bin/sh
# return {icon_middle_path, album_cover_path, visible}

get() {
	if [ "$(systemctl --user is-active mpd)" = "inactive" ] || [ -z "$(mpc current)" ]
	then
		visible=false
	else
		visible=true

		# TODO: handle other image format as well using globs
		album_cover_path=$(dirname "$music_directory/$(mpc current -f %file%)")/Artwork/Cover.jpg
		# echo "$album_cover_path"

		if [ ! -e "$album_cover_path" ]
		then
			album_cover_path="$fallback_album_path"
		fi

		if [ "$(mpc status | tail -n 2 | head -n 1 | awk '{print $1}' | tr -d '[]')" = "paused" ]
		then
			icon_middle_path="./images/icons/music/play.svg"
		else
			icon_middle_path="./images/icons/music/stop.svg"
		fi
	fi

	echo "{\"icon_middle_path\":\"${icon_middle_path}\",\"album_cover_path\":\"${album_cover_path}\",\"visible\":\"${visible}\"}"
}

music_directory="$HOME/Multimedia/Audio/Music/Artists"
fallback_album_path="/home/jetblack/Multimedia/Audio/Music/Artists/Astrud Gilberto/A Certain Smile, A Certrain Sadness 1967/Artwork/Cover.jpg"

REFRESH_RATE=1
while true
do
	get
	sleep $REFRESH_RATE
done

