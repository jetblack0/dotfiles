#! /bin/bash

## This is a rofi script that i use these themes from: 
## Github: https://github.com/adi1090x/rofi
## Author : Aditya Shakya (adi1090x)

# I use it to select emoji, nerd font icon and colors that i use most. The last two are not done yet

# $1: type of this rofi popup
# $2: style of this rofi popup
# $3: color scheme of this rofi popup
# $4: font of this rofi popup
# $5: font size of this rofi popup
# for example: ./picker.sh 2 2 yousai Iosevka 15

makeColorAndFont() {
	colorFile="$rofiHome/theme/shared/colorAndfont.rasi"
	echo "@import \"$rofiHome/theme/shared/colors/$color.rasi\"" > "$colorFile"
	echo "* { font: \"$font $fontSize\"; }" >> "$colorFile"
}

rofiHome="$HOME/.config/rofi"

layout="$rofiHome/theme/picker/type-$1"
theme="$layout/style-$2.rasi"
color="$3"
font="$4"
fontSize="$5"

makeColorAndFont

emojiCmd="$rofiHome/component/emoji.sh"
nerdIconCmd="$rofiHome/component/nerdIcon.sh"

rofi -modi "emoji:$emojiCmd,nerd:$nerdIconCmd" -show emoji -theme "$theme"
