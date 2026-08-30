-- Autostart
-----------------------------------------------
-- One-shot commands run once the compositor is up. Long-lived services belong
-- in hyprland-session.target.

hl.on("hyprland.start", function()
	hl.exec_cmd("noctalia")

	-- cursor theme
	hl.exec_cmd("hyprctl setcursor capitaine-cursors 24")

	-- gtk settings
	hl.exec_cmd("gsettings set org.gnome.desktop.interface icon-theme 'Tela-circle-black-dark'")
	hl.exec_cmd("gsettings set org.gnome.desktop.interface cursor-theme 'capitaine-cursors'")
	hl.exec_cmd("gsettings set org.gnome.desktop.interface cursor-size 24")
end)
