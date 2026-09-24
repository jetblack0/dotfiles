-- Server mode -- shared state
-- ---------------------------------------------
-- server-mode.sh is the only writer: $XDG_RUNTIME_DIR/server-mode exists
-- while the inhibitor lock is held. tmpfs, so it is gone after a reboot.

local M = {}

local runtime = noctalia.getenv("XDG_RUNTIME_DIR") or ""
local home = noctalia.getenv("HOME") or ""

M.script = home .. "/.config/hypr/scripts/server-mode.sh"

function M.read()
	if runtime == "" then
		return false
	end
	return noctalia.readFile(runtime .. "/server-mode") ~= nil
end

return M
