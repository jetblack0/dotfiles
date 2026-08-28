-- Keybindings
-----------------------------------------------

local workspaces = require("conf.workspaces")
local mainMod    = "SUPER"
local nograb = { dont_inhibit = true }


-- System
-----------------------------------------------


-- Layout
-----------------------------------------------
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
