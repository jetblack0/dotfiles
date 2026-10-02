-- Window rules
-----------------------------------------------

hl.window_rule({
	match = { class = "swayimg" },
	float = true,
	size  = { "monitor_w*0.6", "monitor_h*0.7" },
	center = true,
})

hl.window_rule({
	match = { class = [[zen(-beta)?]], initial_title = "Library" },
	float = true,
	size  = { "monitor_w*0.55", "monitor_h*0.65" },
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
