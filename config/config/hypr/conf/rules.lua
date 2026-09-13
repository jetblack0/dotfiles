-- Window rules
-----------------------------------------------

hl.window_rule({
	match = { class = "swayimg" },
	float = true,
	size  = { "monitor_w*0.6", "monitor_h*0.7" },
	center = true,
})

hl.window_rule({
	match = { class = "zen", initial_title = "Library" },
	float = true,
	size  = { "monitor_w*0.55", "monitor_h*0.65" },
	center = true,
})
