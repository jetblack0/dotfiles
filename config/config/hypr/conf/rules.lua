-- Window rules
-----------------------------------------------

hl.window_rule({
	match = { class = "swayimg" },
	float = true,
	size  = { "monitor_w*0.6", "monitor_h*0.7" },
	center = true,
})

-- satty, the screenshot editor
hl.window_rule({
	match = { class = [[com\.gabm\.satty]] },
	float = true,
	size  = { "monitor_w*0.7", "monitor_h*0.8" },
	center = true,
})

hl.window_rule({
	match = { class = [[zen(-beta)?]], initial_title = "Library" },
	float = true,
	size  = { "monitor_w*0.55", "monitor_h*0.65" },
	center = true,
})

hl.window_rule({
	match = { class = "xdg-desktop-portal-gtk" },
	float = true,
	size  = { "monitor_w*0.6", "monitor_h*0.6" },
	center = true,
})

-- wine names a window's class after its program (notepad.exe), in both the
-- wayland and x11 modes; Windows programs expect to size their own windows
hl.window_rule({
	match = { class = [[(?i).*\.exe]] },
	float = true,
})

-- winebox --display private-x11: one fixed-size X desktop per box
hl.window_rule({
	match = { class = [[org\.freedesktop\.Xwayland]] },
	float = true,
	center = true,
})

-- touchpad scrolling in the terminal is slow at the global scroll_factor
hl.window_rule({
	match = { class = "kitty" },
	scroll_touchpad = 1.5,
})

hl.layer_rule({
	match = { namespace = "still|selection" },
	no_anim = true,
})
