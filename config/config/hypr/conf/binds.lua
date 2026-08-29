-- Keybindings
-----------------------------------------------

local workspaces = require("conf.workspaces")
local mainMod    = "SUPER"
local nograb = { dont_inhibit = true }


-- System
-----------------------------------------------
local media = { locked = true, repeating = true, dont_inhibit = true }

-- shell surfaces
hl.bind(mainMod .. " + SPACE", hl.dsp.exec_cmd("noctalia msg panel-toggle launcher"), nograb)
hl.bind(mainMod .. " + grave", hl.dsp.exec_cmd("noctalia msg panel-toggle session"), nograb)
hl.bind(mainMod .. " + N", hl.dsp.exec_cmd("noctalia msg panel-toggle control-center"), nograb)
hl.bind(mainMod .. " + V", hl.dsp.exec_cmd("noctalia msg panel-toggle clipboard"), nograb)
hl.bind(mainMod .. " + B", hl.dsp.exec_cmd("noctalia msg bar-toggle"), { description = "toggle the bar" })

-- session. lock is the only one bound directly; the rest live in the session
-- panel above
hl.bind(mainMod .. " + escape", hl.dsp.exec_cmd("noctalia msg session lock"))

-- notifications
hl.bind(mainMod .. " + C", hl.dsp.exec_cmd("noctalia msg notification-clear-active"), nograb)
hl.bind(mainMod .. " + SHIFT + C", hl.dsp.exec_cmd("noctalia msg notification-invoke-latest"), nograb)
hl.bind(mainMod .. " + SHIFT + N", hl.dsp.exec_cmd("noctalia msg notification-dnd-toggle"), nograb)

-- screenshots
hl.bind("Print", hl.dsp.exec_cmd("noctalia msg screenshot-fullscreen"), nograb)
hl.bind(mainMod .. " + S", hl.dsp.exec_cmd("noctalia msg screenshot-region"), nograb)

-- wallpapers
hl.bind(mainMod .. " + minus", hl.dsp.exec_cmd("noctalia msg wallpaper-random"), nograb)
hl.bind(mainMod .. " + equal", hl.dsp.exec_cmd("noctalia msg panel-toggle wallpaper"), nograb)

-- night light toggle
hl.bind(mainMod .. " + SHIFT + Prior", hl.dsp.exec_cmd("noctalia msg nightlight-toggle"), nograb)

-- volume and brightness
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("noctalia msg volume-up"), media)
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("noctalia msg volume-down"), media)
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("noctalia msg volume-mute"), { locked = true, dont_inhibit = true })
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("noctalia msg mic-mute"), { locked = true, dont_inhibit = true })
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("noctalia msg brightness-up"), media)
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("noctalia msg brightness-down"), media)
hl.bind(mainMod .. " + End", hl.dsp.exec_cmd("noctalia msg volume-up"), nograb)
hl.bind(mainMod .. " + Delete", hl.dsp.exec_cmd("noctalia msg volume-down"), nograb)
hl.bind(mainMod .. " + Home", hl.dsp.exec_cmd("noctalia msg volume-mute"), nograb)


-- Layout
-----------------------------------------------
hl.bind(mainMod .. " + Q", hl.dsp.window.close(), nograb)
hl.bind(mainMod .. " + slash", hl.dsp.window.float(), nograb)
hl.bind(mainMod .. " + J", hl.dsp.layout("cyclenext"), nograb)
hl.bind(mainMod .. " + K", hl.dsp.layout("cycleprev"), nograb)
hl.bind(mainMod .. " + F", hl.dsp.window.fullscreen(), nograb)
hl.bind(mainMod .. " + H", hl.dsp.focus({ direction = "l" }), nograb)
hl.bind(mainMod .. " + L", hl.dsp.focus({ direction = "r" }), nograb)
hl.bind(mainMod .. " + O", hl.dsp.window.pin(), nograb)
hl.bind(mainMod .. " + SHIFT + J", hl.dsp.layout("swapnext"), nograb)
hl.bind(mainMod .. " + SHIFT + K", hl.dsp.layout("swapprev"), nograb)

hl.bind(mainMod .. " + SHIFT + E", hl.dsp.group.toggle(), nograb)
hl.bind(mainMod .. " + Tab", hl.dsp.group.next())
hl.bind(mainMod .. " + SHIFT + Tab", hl.dsp.group.prev())

-- resize
hl.bind(mainMod .. " + A", hl.dsp.submap("resize"))
hl.define_submap("resize", function()
	hl.bind("l", hl.dsp.window.resize({ x = 20, y = 0, relative = true }), { repeating = true })
	hl.bind("h", hl.dsp.window.resize({ x = -20, y = 0, relative = true }), { repeating = true })
	hl.bind("k", hl.dsp.window.resize({ x = 0, y = 20, relative = true }), { repeating = true })
	hl.bind("j", hl.dsp.window.resize({ x = 0, y = -20, relative = true }), { repeating = true })
	hl.bind("escape", hl.dsp.submap("reset"))
end)


-- Workspaces
-----------------------------------------------
for n = 1, 10 do
	local key = n % 10
	hl.bind(mainMod .. " + " .. key, workspaces.focus(n), nograb)
	hl.bind(mainMod .. " + SHIFT + " .. key, workspaces.move(n, true), nograb)
	hl.bind(mainMod .. " + CTRL + SHIFT + " .. key, workspaces.move(n, false), nograb)
end

-- relative moves
hl.bind(mainMod .. " + SHIFT + H", workspaces.focus_relative(-1), nograb)
hl.bind(mainMod .. " + SHIFT + L", workspaces.focus_relative(1), nograb)
hl.bind(mainMod .. " + CTRL + H", workspaces.move_relative(-1, true), nograb)
hl.bind(mainMod .. " + CTRL + L", workspaces.move_relative(1, true), nograb)
hl.bind(mainMod .. " + CTRL + SHIFT + H", workspaces.move_relative(-1, false), nograb)
hl.bind(mainMod .. " + CTRL + SHIFT + L", workspaces.move_relative(1, false), nograb)

-- move/resize windows by dragging
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true, dont_inhibit = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true, dont_inhibit = true })

-- multi-monitor
hl.bind(mainMod .. " + CTRL + J", hl.dsp.focus({ monitor = "+1" }), nograb)
hl.bind(mainMod .. " + CTRL + K", hl.dsp.focus({ monitor = "-1" }), nograb)
hl.bind(mainMod .. " + SHIFT + O", hl.dsp.window.move({ monitor = "+1", follow = true }),
	{ description = "send window to the next monitor" })


-- Programs
-----------------------------------------------
hl.bind(mainMod .. " + Return", hl.dsp.exec_cmd("kitty"))
