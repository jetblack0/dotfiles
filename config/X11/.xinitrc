#!/bin/sh

# why it doesn't use the variable that i set on ~/.zshenv file?
userresources=$HOME/.config/X11/.Xresources
usermodmap=$HOME/.config/X11/.Xmodmap
sysresources=/etc/X11/xinit/.Xresources
sysmodmap=/etc/X11/xinit/.Xmodmap

# merge in defaults and keymaps

if [ -f $sysresources ]; then







    xrdb -merge $sysresources

fi

if [ -f $sysmodmap ]; then
    xmodmap $sysmodmap
fi

if [ -f "$userresources" ]; then







    xrdb -merge "$userresources"

fi


# start some nice programs

if [ -d /etc/X11/xinit/xinitrc.d ] ; then
 for f in /etc/X11/xinit/xinitrc.d/?*.sh ; do
  [ -x "$f" ] && . "$f"
 done
 unset f
fi

# execute xmodmap only when no keyboard plugged
if [ -f "$usermodmap" ] && [ "$(find /dev/input/by-id -iname "*kbd*")" ]; then
    xmodmap "$usermodmap"
fi

picom -b &
feh --bg-fill --no-fehbg --randomize --recursive ~/Pictures/Wallpaper &
fcitx5 -d &

exec awesome
