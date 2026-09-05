-- Keybindings
-----------------------------------------------

local workspaces = require("conf.workspaces")
local mainMod    = "SUPER"
local nograb = { dont_inhibit = true }

-- Layout-specific keys live in the active layout's conf/layouts/<name>.lua
local layout = require("conf.layout")

-- The descriptions feed hyprctl binds, which is what scripts/cheatsheet.sh
-- renders
local function d(text, opts)
	local t = {}
	if opts then
		for k, v in pairs(opts) do
			t[k] = v
		end
	end
	t.description = text
	return t
end


-- System
-----------------------------------------------
local media = { locked = true, repeating = true, dont_inhibit = true }

-- shell surfaces
hl.bind(mainMod .. " + SPACE", hl.dsp.exec_cmd("noctalia msg panel-toggle launcher"), d("launcher", nograb))
hl.bind(mainMod .. " + grave", hl.dsp.exec_cmd("noctalia msg panel-toggle session"), d("session menu", nograb))
hl.bind(mainMod .. " + N", hl.dsp.exec_cmd("noctalia msg panel-toggle control-center"), d("control center", nograb))
hl.bind(mainMod .. " + V", hl.dsp.exec_cmd("noctalia msg panel-toggle clipboard"), d("clipboard history", nograb))
hl.bind(mainMod .. " + B", hl.dsp.exec_cmd("noctalia msg bar-toggle"), d("toggle the bar"))

-- window switcher: opens on the held SUPER, Tab advances (Shift+Tab back),
-- releasing SUPER commits.
hl.bind(mainMod .. " + Tab", hl.dsp.exec_cmd("noctalia msg window-switcher"), d("window switcher", nograb))

-- session. lock is the only one bound directly; the rest live in the session
-- panel above
hl.bind(mainMod .. " + escape", hl.dsp.exec_cmd("noctalia msg session lock"), d("lock the session"))

-- notifications
hl.bind(mainMod .. " + C", hl.dsp.exec_cmd("noctalia msg notification-clear-active"), d("dismiss notifications", nograb))
hl.bind(mainMod .. " + SHIFT + C", hl.dsp.exec_cmd("noctalia msg notification-invoke-latest"), d("act on the latest notification", nograb))
-- do-not-disturb toggle. W mirrors his mac (option+w); SHIFT+N does the same
hl.bind(mainMod .. " + SHIFT + N", hl.dsp.exec_cmd("noctalia msg notification-dnd-toggle"), d("do not disturb", nograb))
hl.bind(mainMod .. " + W", hl.dsp.exec_cmd("noctalia msg notification-dnd-toggle"), d("do not disturb", nograb))

hl.bind("Print", hl.dsp.exec_cmd("noctalia msg screenshot-fullscreen"), d("screenshot the screen", nograb))
hl.bind(mainMod .. " + S", hl.dsp.exec_cmd("noctalia msg screenshot-region"), d("screenshot a region", nograb))
hl.bind(mainMod .. " + SHIFT + S",
	hl.dsp.exec_cmd("grim -g \"$(slurp)\" - | wl-copy && notify-send Screenshot \"Copied to clipboard\""),
	d("copy a region screenshot", nograb))

-- wallpapers
hl.bind(mainMod .. " + minus", hl.dsp.exec_cmd("noctalia msg wallpaper-random"), d("random wallpaper", nograb))
hl.bind(mainMod .. " + equal", hl.dsp.exec_cmd("noctalia msg panel-toggle wallpaper"), d("wallpaper picker", nograb))

-- pass: the launcher's /pass dmenu entry lists the store, selection copies
hl.bind(mainMod .. " + SHIFT + P", hl.dsp.exec_cmd("noctalia msg panel-open launcher \"/pass \""), d("password store", nograb))

-- screen pickers, both end up in the clipboard. X for "extract text";
-- O belongs to window.pin below
hl.bind(mainMod .. " + P", hl.dsp.exec_cmd("hyprpicker -a"), d("color picker", nograb))
hl.bind(mainMod .. " + X",
	hl.dsp.exec_cmd("grim -g \"$(slurp)\" - | tesseract stdin stdout | wl-copy && notify-send OCR \"Copied to clipboard\""),
	d("ocr a region to the clipboard", nograb))

-- cycle the hyprland animation set / layout
hl.bind(mainMod .. " + SHIFT + A", hl.dsp.exec_cmd("$HOME/.config/hypr/scripts/animation-switcher.sh --notify --next"), d("cycle the animation set", nograb))
hl.bind(mainMod .. " + SHIFT + SPACE", hl.dsp.exec_cmd("$HOME/.config/hypr/scripts/layout-switcher.sh --notify --next"), d("cycle the layout", nograb))

-- this list, searchable in the launcher
hl.bind(mainMod .. " + SHIFT + slash", hl.dsp.exec_cmd("$HOME/.config/hypr/scripts/cheatsheet.sh"), d("keybind cheatsheet", nograb))

-- night light toggle
hl.bind(mainMod .. " + SHIFT + Prior", hl.dsp.exec_cmd("noctalia msg nightlight-toggle"), d("night light", nograb))

-- trackpad on/off.
hl.bind(mainMod .. " + T", hl.dsp.exec_cmd("$HOME/.config/hypr/scripts/trackpad-toggle.sh"), d("toggle the trackpad", nograb))
hl.bind("XF86TouchpadToggle", hl.dsp.exec_cmd("$HOME/.config/hypr/scripts/trackpad-toggle.sh"), d("toggle the trackpad", { locked = true, dont_inhibit = true }))

-- volume and brightness
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("noctalia msg volume-up"), d("volume up", media))
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("noctalia msg volume-down"), d("volume down", media))
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("noctalia msg volume-mute"), d("mute", { locked = true, dont_inhibit = true }))
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("noctalia msg mic-mute"), d("mute the mic", { locked = true, dont_inhibit = true }))
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("noctalia msg brightness-up"), d("brightness up", media))
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("noctalia msg brightness-down"), d("brightness down", media))
hl.bind(mainMod .. " + End", hl.dsp.exec_cmd("noctalia msg volume-up"), d("volume up", nograb))
hl.bind(mainMod .. " + Delete", hl.dsp.exec_cmd("noctalia msg volume-down"), d("volume down", nograb))
hl.bind(mainMod .. " + Home", hl.dsp.exec_cmd("noctalia msg volume-mute"), d("mute", nograb))


-- Layout
-----------------------------------------------
hl.bind(mainMod .. " + Q", hl.dsp.window.close(), d("close the window", nograb))
hl.bind(mainMod .. " + slash", hl.dsp.window.float(), d("toggle floating", nograb))
hl.bind(mainMod .. " + F", hl.dsp.window.fullscreen(), d("fullscreen", nograb))
hl.bind(mainMod .. " + O", hl.dsp.window.pin(), d("pin the window", nograb))

if layout.binds then
	layout.binds({ mod = mainMod, nograb = nograb, d = d })
end

hl.bind(mainMod .. " + SHIFT + E", hl.dsp.group.toggle(), d("toggle grouping", nograb))
-- group cycling gave its keys to the window switcher; parked, not deleted
-- hl.bind(mainMod .. " + Tab", hl.dsp.group.next())
-- hl.bind(mainMod .. " + SHIFT + Tab", hl.dsp.group.prev())

local notify_tag = "$HOME/.config/hypr/scripts/notify-tag.sh"
local function submode(name, hint)
	return function()
		hl.dispatch(hl.dsp.submap(name))
		hl.exec_cmd(string.format("%s submode show -t 0 '%s submode' '%s'", notify_tag, name, hint))
	end
end
local function submode_leave()
	hl.dispatch(hl.dsp.submap("reset"))
	hl.exec_cmd(notify_tag .. " submode close")
end

-- resize submode
hl.bind(mainMod .. " + R", submode("resize", "hjkl resizes, esc leaves"), d("resize submode"))
hl.define_submap("resize", function()
	hl.bind("l", hl.dsp.window.resize({ x = 20, y = 0, relative = true }), d("wider", { repeating = true }))
	hl.bind("h", hl.dsp.window.resize({ x = -20, y = 0, relative = true }), d("narrower", { repeating = true }))
	hl.bind("k", hl.dsp.window.resize({ x = 0, y = 20, relative = true }), d("taller", { repeating = true }))
	hl.bind("j", hl.dsp.window.resize({ x = 0, y = -20, relative = true }), d("shorter", { repeating = true }))
	hl.bind("escape", submode_leave, d("leave the submode"))
end)

-- directional-swap submode
hl.bind(mainMod .. " + A", submode("swap", "hjkl throws the window, esc leaves"), d("swap submode"))
hl.define_submap("swap", function()
	hl.bind("h", hl.dsp.window.swap({ direction = "l" }), d("throw the window left"))
	hl.bind("j", hl.dsp.window.swap({ direction = "d" }), d("throw the window down"))
	hl.bind("k", hl.dsp.window.swap({ direction = "u" }), d("throw the window up"))
	hl.bind("l", hl.dsp.window.swap({ direction = "r" }), d("throw the window right"))
	hl.bind("escape", submode_leave, d("leave the submode"))
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
hl.bind(mainMod .. " + SHIFT + H", workspaces.focus_relative(-1), d("previous workspace", nograb))
hl.bind(mainMod .. " + SHIFT + L", workspaces.focus_relative(1), d("next workspace", nograb))
hl.bind(mainMod .. " + CTRL + H", workspaces.move_relative(-1, true), d("take the window a workspace left", nograb))
hl.bind(mainMod .. " + CTRL + L", workspaces.move_relative(1, true), d("take the window a workspace right", nograb))
hl.bind(mainMod .. " + CTRL + SHIFT + H", workspaces.move_relative(-1, false), d("send the window a workspace left", nograb))
hl.bind(mainMod .. " + CTRL + SHIFT + L", workspaces.move_relative(1, false), d("send the window a workspace right", nograb))

-- move/resize windows by dragging
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), d("drag the window", { mouse = true, dont_inhibit = true }))
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), d("drag-resize the window", { mouse = true, dont_inhibit = true }))

-- multi-monitor
hl.bind(mainMod .. " + CTRL + J", hl.dsp.focus({ monitor = "+1" }), d("focus the next monitor", nograb))
hl.bind(mainMod .. " + CTRL + K", hl.dsp.focus({ monitor = "-1" }), d("focus the previous monitor", nograb))
hl.bind(mainMod .. " + SHIFT + O", hl.dsp.window.move({ monitor = "+1", follow = true }),
	d("send window to the next monitor"))


-- Programs
-----------------------------------------------
hl.bind(mainMod .. " + Return", hl.dsp.exec_cmd("kitty"), d("terminal"))
hl.bind(mainMod .. " + semicolon", hl.dsp.exec_cmd("zen-browser"), d("browser", nograb))
