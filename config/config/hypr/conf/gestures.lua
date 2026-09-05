-- Trackpad gestures
-----------------------------------------------
hl.gesture({ fingers = 3, direction = "swipe", action = "move" })
hl.gesture({ fingers = 4, direction = "horizontal", action = "workspace" })

-- two-finger pinch magnifies the screen around the cursor
-- hl.gesture({ fingers = 2, direction = "pinch", action = "cursor_zoom", zoom_level = 1, mode = "live" })

-- three fingers up + SUPER toggles fullscreen
-- hl.gesture({ fingers = 3, direction = "up", mods = "SUPER", action = "fullscreen" })
