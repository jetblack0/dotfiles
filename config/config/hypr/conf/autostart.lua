-- Autostart
-----------------------------------------------
-- One-shot commands run once the compositor is up. Long-lived services belong
-- in hyprland-session.target.

hl.on("hyprland.start", function()
	hl.exec_cmd("noctalia")
end)
