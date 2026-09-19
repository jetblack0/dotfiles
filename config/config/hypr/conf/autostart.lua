-- Autostart
-----------------------------------------------
-- One-shot commands run once the compositor is up. Long-lived services belong
-- in hyprland-session.target.

hl.on("hyprland.start", function()
	hl.exec_cmd("noctalia")

	hl.exec_cmd("$HOME/.config/hypr/scripts/trackpad-toggle.sh init")

	-- cursor theme
	hl.exec_cmd("hyprctl setcursor capitaine-cursors 24")

	-- xwayland font dpi and rendering: rendered per host next to
	-- monitors.lua; absent when the host file sets no xwayland_dpi.
	-- The xrdb connection also wakes the lazy xwayland server up.
	hl.exec_cmd('f="${XDG_STATE_HOME:-$HOME/.local/state}/hypr/xresources"; [ -f "$f" ] && xrdb -merge "$f"')

	hl.exec_cmd('mkdir -p "${XAUTHORITY%/*}" && xauth -q generate "$DISPLAY" . trusted')

	-- gtk settings
	hl.exec_cmd("gsettings set org.gnome.desktop.interface icon-theme 'Tela-circle-black-dark'")
	hl.exec_cmd("gsettings set org.gnome.desktop.interface cursor-theme 'capitaine-cursors'")
	hl.exec_cmd("gsettings set org.gnome.desktop.interface cursor-size 24")
end)
