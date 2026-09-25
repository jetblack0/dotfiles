-- Passthrough
-----------------------------------------------
-- Send all keys to VMs and games instead of the host.
--
-- When a window from the list below gets focus, the host switches to the
-- "passthrough" submap. That submap has only one bind, so the host ignores
-- every other key and the window gets it.
--
-- Focusing any other window switches back to normal.
-- Super+Alt+Esc switches passthrough off. On any other window, it
-- switches passthrough on.
--
-- The Super+Alt+Esc binds need dont_inhibit. Without it, a VM that has
-- grabbed the keyboard would swallow this key too, and there'd be no way
-- out.

-- Window classes that get passthrough (Lua patterns, whole class).
local capture = {
	"qemu%-system%-.+",
	"steam_app_%d+",
}

local escape = "SUPER + ALT + escape"
local notify_tag = "$HOME/.config/hypr/scripts/notify-tag.sh"

local function wants_keys(w)
	local class = w and w.class
	if not class then
		return false
	end
	for _, p in ipairs(capture) do
		if class:match("^" .. p .. "$") then
			return true
		end
	end
	return false
end

local function enter()
	hl.dispatch(hl.dsp.submap("passthrough"))
	hl.exec_cmd(notify_tag .. " passthrough show 'Passthrough on' 'Super+Alt+Esc hands the keys back'")
end

local function leave()
	hl.dispatch(hl.dsp.submap("reset"))
	hl.exec_cmd(notify_tag .. " passthrough show 'Passthrough off'")
end

hl.on("window.active", function(w)
	local on = hl.get_current_submap() == "passthrough"
	if wants_keys(w) then
		if not on then
			enter()
		end
	elseif on then
		leave()
	end
end)

hl.bind(escape, enter, { description = "passthrough: all keys to the window", dont_inhibit = true })
hl.define_submap("passthrough", function()
	hl.bind(escape, leave, { description = "leave passthrough", dont_inhibit = true })
end)
