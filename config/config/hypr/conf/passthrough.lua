-- Passthrough
-----------------------------------------------
-- Send all keys to the focused window instead of the host, for VMs and
-- games.
--
-- Super+Alt+Esc switches passthrough on for the focused window. It needs
-- a window: on an empty workspace it does nothing. The host then switches
-- to the "passthrough" submap. That submap has only one bind, so the host
-- ignores every other key and the window gets it.
--
-- Super+Alt+Esc again switches it off. Focusing another window (with the
-- mouse) or closing the window switches it off too.
--
-- The Super+Alt+Esc binds need dont_inhibit. Without it, a VM that has
-- grabbed the keyboard would swallow this key too, and there'd be no way
-- out.

local escape = "SUPER + ALT + escape"
local notify_tag = "$HOME/.config/hypr/scripts/notify-tag.sh"

-- the window that has passthrough, while it's on
local held = nil

local function notify(summary, body)
	hl.exec_cmd(string.format("%s passthrough show '%s' '%s'", notify_tag, summary, body or ""))
end

local function enter()
	local w = hl.get_active_window()
	if not w or not w.address then
		notify("Passthrough", "no window to send the keys to")
		return
	end
	held = w.address
	hl.dispatch(hl.dsp.submap("passthrough"))
	notify("Passthrough on", "Super+Alt+Esc hands the keys back")
end

local function leave()
	held = nil
	hl.dispatch(hl.dsp.submap("reset"))
	notify("Passthrough off")
end

hl.on("window.active", function(w)
	if held and not (w and w.address == held) then
		leave()
	end
end)

-- the last window on a workspace can close without focus moving anywhere
hl.on("window.close", function(w)
	if held and w and w.address == held then
		leave()
	end
end)

hl.bind(escape, enter, { description = "passthrough: all keys to the window", dont_inhibit = true })
hl.define_submap("passthrough", function()
	hl.bind(escape, leave, { description = "leave passthrough", dont_inhibit = true })
end)
