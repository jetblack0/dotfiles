#!/usr/bin/env bash

# Description: a script that used with lf file manager to delete files in the cowsay way

# Usage: change the code inside your lfrc delete function to "/home/cowDelete.sh $fx", change the /home/cowDelete.sh to the path of this file

lightBlue='\033[1;34m'
lightPurple='\033[1;35m'
withoutColor='\033[0m'
bold=$(tput bold)
animal="small"
# clear

echo -e "\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n${lightPurple}"
for file in "$@"
do
	fileName=$(basename "$file")

	if [ -d "$file" ]
	then
		echo -e " $fileName  $(du -sh "$file" | awk '{print $1}')"
		continue
	fi

	case "${fileName##*.}" in
		sh) echo -e " $fileName  $(du -sh "$file" | awk '{print $1}')" ;;
		svg|png|jpg|JPG) echo -e " $fileName  $(du -sh "$file" | awk '{print $1}')" ;;
		*) echo -e " $fileName  $(du -sh "$file" | awk '{print $1}')" ;;
	esac
done | cowsay -f "$animal" -n

echo -e "${lightBlue}"
read -p "${bold}So you wanna delete them?[Y/n]: " ans
[ "$ans" = "Y" ] && 
	for file in "$@"
	do
		rm -rf "$file"
	done
