#!/usr/bin/env bash
# a script to accomplish awesomewm like workspace in hyprland, in order to make it work, you need to bind 1-10 workspaces on monitor 0, 11-20 to monitor 1 and so fourth
# return: an array of {workspace_id, color}
# $1: which monitor to draw this bar (start with 0)

# TODO: ugly af

##################################################### function declaration ################################################
set_color() {
	occupied_workspaces_color="#d79920"
	focused_workspaces_color="#d3859a"
	empty_workspaces_color="#7B9C98"
	# occupied_workspaces_color="occupied"
	# focused_workspaces_color="focused"
	# empty_workspaces_color="empty"

	if [ "$focused_workspace" -eq "$1" ]; then
		echo -n $focused_workspaces_color
		return
	fi

	if [ "${occupied_workspaces[$1]}" -eq 1 ]
	then
		if [ "$focused_workspace" -eq "$1" ]; then
			echo -n $focused_workspaces_color
		else
			echo -n $occupied_workspaces_color
		fi
	else
		echo -n $empty_workspaces_color
	fi 2> /dev/null
}

workspace_event_handler() {
	occupied_workspaces[$1]=$2
}

get_json() {
	echo -n '['

	start=$(( which_monitor * 10 + 1 ))
	end=$(( start + 10 ))

	for ((i = start; i < end; i++))
	do
		echo -n ''$([ $(( i % 10 )) -eq 1 ] || echo ,) '{ "number": "'"$i"'", "color": "'$(set_color "$i")'" }'
	  
	done

	echo ']'
}


##################################################### variables declaration #################################################
# key: workspace number, value: 1 means there are windows in this workspaces, anything else means this workspace is empty
declare -A occupied_workspaces
# for eww to draw different workspace widgets on different monitors
declare which_monitor="$1"

######################################################### initialize ########################################################
focused_workspace=$(hyprctl -j monitors | jaq -r '.[] | select(.focused == true) | .activeWorkspace.id')

while read -r workspace_id
do
	occupied_workspaces[$workspace_id]=1
done < <(hyprctl -j workspaces | gojq '.[] | select(.windows > 0) | .id')

get_json


##################################################### listen to events ######################################################
socat -u UNIX-CONNECT:/run/user/$UID/hypr/"$HYPRLAND_INSTANCE_SIGNATURE"/.socket2.sock - | while read -r line
do
	while read -r workspace_id
	do
		occupied_workspaces[$workspace_id]=0
	done < <(hyprctl -j workspaces | gojq '.[] | select(.windows == 0) | .id')

	while read -r workspace_id
	do
		occupied_workspaces[$workspace_id]=1
	done < <(hyprctl -j workspaces | gojq '.[] | select(.windows > 0) | .id')

	focused_workspace=$(hyprctl -j monitors | jaq -r '.[] | select(.focused == true) | .activeWorkspace.id')

	# NOTE: following lines are no longer usable after Hyprland version 0.42.0. Above is a quick fix
	# case ${line%>>*} in
	# "workspace")
	# 	focused_workspace=${line#*>>}
	# ;;
	# "focusedmon")
	# 	focused_workspace=${line#*,}
	# ;;
	# "createworkspace")
	# 	workspace_event_handler "${line#*>>}" 1
	# ;;
	# "destroyworkspace")
	# 	workspace_event_handler "${line#*>>}" 0
	# ;;
	# esac

	get_json
done
