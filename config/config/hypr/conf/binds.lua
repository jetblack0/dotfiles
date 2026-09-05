-- Keybindings
-----------------------------------------------

local workspaces = require("conf.workspaces")
local mainMod    = "SUPER"
local nograb = { dont_inhibit = true }

-- Layout-specific keys live in the active layout's conf/layouts/<name>.lua
local layout = require("conf.layout")


-- System
-----------------------------------------------
local media = { locked = true, repeating = true, dont_inhibit = true }

-- shell surfaces
hl.bind(mainMod .. " + SPACE", hl.dsp.exec_cmd("noctalia msg panel-toggle launcher"), nograb)
hl.bind(mainMod .. " + grave", hl.dsp.exec_cmd("noctalia msg panel-toggle session"), nograb)
hl.bind(mainMod .. " + N", hl.dsp.exec_cmd("noctalia msg panel-toggle control-center"), nograb)
hl.bind(mainMod .. " + V", hl.dsp.exec_cmd("noctalia msg panel-toggle clipboard"), nograb)
hl.bind(mainMod .. " + B", hl.dsp.exec_cmd("noctalia msg bar-toggle"), { description = "toggle the bar" })

-- window switcher: opens on the held SUPER, Tab advances (Shift+Tab back),
-- releasing SUPER commits.
hl.bind(mainMod .. " + Tab", hl.dsp.exec_cmd("noctalia msg window-switcher"), nograb)

-- session. lock is the only one bound directly; the rest live in the session
-- panel above
hl.bind(mainMod .. " + escape", hl.dsp.exec_cmd("noctalia msg session lock"))

-- notifications
hl.bind(mainMod .. " + C", hl.dsp.exec_cmd("noctalia msg notification-clear-active"), nograb)
hl.bind(mainMod .. " + SHIFT + C", hl.dsp.exec_cmd("noctalia msg notification-invoke-latest"), nograb)
-- do-not-disturb toggle. W mirrors his mac (option+w); SHIFT+N does the same
hl.bind(mainMod .. " + SHIFT + N", hl.dsp.exec_cmd("noctalia msg notification-dnd-toggle"), nograb)
hl.bind(mainMod .. " + W", hl.dsp.exec_cmd("noctalia msg notification-dnd-toggle"), nograb)

hl.bind("Print", hl.dsp.exec_cmd("noctalia msg screenshot-fullscreen"), nograb)
hl.bind(mainMod .. " + S", hl.dsp.exec_cmd("noctalia msg screenshot-region"), nograb)
hl.bind(mainMod .. " + SHIFT + S",
	hl.dsp.exec_cmd("grim -g \"$(slurp)\" - | wl-copy && notify-send Screenshot \"Copied to clipboard\""),
	nograb)

-- wallpapers
hl.bind(mainMod .. " + minus", hl.dsp.exec_cmd("noctalia msg wallpaper-random"), nograb)
hl.bind(mainMod .. " + equal", hl.dsp.exec_cmd("noctalia msg panel-toggle wallpaper"), nograb)

-- pass: the launcher's /pass dmenu entry lists the store, selection copies
hl.bind(mainMod .. " + SHIFT + P", hl.dsp.exec_cmd("noctalia msg panel-open launcher \"/pass \""), nograb)

-- screen pickers, both end up in the clipboard. X for "extract text";
-- O belongs to window.pin below
hl.bind(mainMod .. " + P", hl.dsp.exec_cmd("hyprpicker -a"), nograb)
hl.bind(mainMod .. " + X",
	hl.dsp.exec_cmd("grim -g \"$(slurp)\" - | tesseract stdin stdout | wl-copy && notify-send OCR \"Copied to clipboard\""),
	nograb)

-- cycle the hyprland animation set / layout
hl.bind(mainMod .. " + SHIFT + A", hl.dsp.exec_cmd("$HOME/.config/hypr/scripts/animation-switcher.sh --notify --next"), nograb)
hl.bind(mainMod .. " + SHIFT + SPACE", hl.dsp.exec_cmd("$HOME/.config/hypr/scripts/layout-switcher.sh --notify --next"), nograb)

-- night light toggle
hl.bind(mainMod .. " + SHIFT + Prior", hl.dsp.exec_cmd("noctalia msg nightlight-toggle"), nograb)

-- trackpad on/off.
hl.bind(mainMod .. " + T", hl.dsp.exec_cmd("$HOME/.config/hypr/scripts/trackpad-toggle.sh"), nograb)
hl.bind("XF86TouchpadToggle", hl.dsp.exec_cmd("$HOME/.config/hypr/scripts/trackpad-toggle.sh"), { locked = true, dont_inhibit = true })

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
hl.bind(mainMod .. " + F", hl.dsp.window.fullscreen(), nograb)
hl.bind(mainMod .. " + O", hl.dsp.window.pin(), nograb)

if layout.binds then
	layout.binds({ mod = mainMod, nograb = nograb })
end

hl.bind(mainMod .. " + SHIFT + E", hl.dsp.group.toggle(), nograb)
-- group cycling gave its keys to the window switcher; parked, not deleted
-- hl.bind(mainMod .. " + Tab", hl.dsp.group.next())
-- hl.bind(mainMod .. " + SHIFT + Tab", hl.dsp.group.prev())

-- resize submode
hl.bind(mainMod .. " + R", hl.dsp.submap("resize"))
hl.define_submap("resize", function()
	hl.bind("l", hl.dsp.window.resize({ x = 20, y = 0, relative = true }), { repeating = true })
	hl.bind("h", hl.dsp.window.resize({ x = -20, y = 0, relative = true }), { repeating = true })
	hl.bind("k", hl.dsp.window.resize({ x = 0, y = 20, relative = true }), { repeating = true })
	hl.bind("j", hl.dsp.window.resize({ x = 0, y = -20, relative = true }), { repeating = true })
	hl.bind("escape", hl.dsp.submap("reset"))
end)

-- directional-swap submode
hl.bind(mainMod .. " + A", hl.dsp.submap("swap"))
hl.define_submap("swap", function()
	hl.bind("h", hl.dsp.window.swap({ direction = "l" }))
	hl.bind("j", hl.dsp.window.swap({ direction = "d" }))
	hl.bind("k", hl.dsp.window.swap({ direction = "u" }))
	hl.bind("l", hl.dsp.window.swap({ direction = "r" }))
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
hl.bind(mainMod .. " + semicolon", hl.dsp.exec_cmd("zen-browser"), nograb)
