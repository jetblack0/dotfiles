#!/bin/sh
# A script to launch hyprland on integrated, hybrid or nvidia gpu mode

# Usage:
# $1: nvidia or hybrid or integrated
# for example, ./hyprlandLauncher.sh nvidia

cd ~

export HYPRLAND_LOG_WLR=1

export XCURSOR_THEME=Catppuccin-Mocha-Light
export XCURSOR_SIZE=16

export QT_QPA_PLATFORM="wayland;xcb"
export QT_WAYLAND_DISABLE_WINDOWDECORATION=1
# export QT_AUTO_SCREEN_SCALE_FACTOR=1
export QT_SCALE_FACTOR=1.25
export GDK_DPI_SCALE=1.25
export XDG_CURRENT_DESKTOP=Hyprland
export XDG_SESSION_TYPE=wayland
export XDG_SESSION_DESKTOP=Hyprland

export MOZ_ENABLE_WAYLAND=1

# Tell some program to use wayland
export ANKI_WAYLAND=1

case "$1" in
	nvidia)
		export __GLX_VENDOR_LIBRARY_NAME=nvidia
		export GBM_BACKEND=nvidia-drm
		export WLR_NO_HARDWARE_CURSORS=1
		export LIBVA_DRIVER_NAME=nvidia
		sed -i -E 's/monitor=eDP-[0-9],1920x1080/monitor=eDP-1,1920x1080/g' ~/.config/hypr/hyprland.conf
		;;
	integrated)
		export __EGL_VENDOR_LIBRARY_FILENAMES=/usr/share/glvnd/egl_vendor.d/50_mesa.json
		sed -i -E 's/monitor=eDP-[0-9],1920x1080/monitor=eDP-2,1920x1080/g' ~/.config/hypr/hyprland.conf
		;;
	hybrid|*)
		sed -i -E 's/monitor=eDP-[0-9],1920x1080/monitor=eDP-2,1920x1080/g' ~/.config/hypr/hyprland.conf
		;;
esac

exec Hyprland
