-- Trackpad gestures
-----------------------------------------------
-- Three fingers belong to libinput's three-finger drag (drag_3fg in
-- options.lua).
-- drag on.
hl.gesture({ fingers = 4, direction = "horizontal", action = "workspace" })

-- A swipe that falls short snaps back. It commits once the fingers travel
-- distance * cancel_ratio (200 * 0.2 = 40px), or end faster than
-- min_speed_to_force. The defaults is (300, 0.5, 30).
hl.config({
	gestures = {
		workspace_swipe_distance = 200,
		workspace_swipe_cancel_ratio = 0.2,
		workspace_swipe_min_speed_to_force = 10,
	},
})

-- two-finger pinch magnifies the screen around the cursor
-- hl.gesture({ fingers = 2, direction = "pinch", action = "cursor_zoom", zoom_level = 1, mode = "live" })

-- three fingers up + SUPER toggles fullscreen
-- hl.gesture({ fingers = 3, direction = "up", mods = "SUPER", action = "fullscreen" })
