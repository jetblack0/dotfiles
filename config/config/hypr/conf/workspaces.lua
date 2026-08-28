local PER_MONITOR = 10

local M = {}

local function group_start(monitor_id)
	return monitor_id * PER_MONITOR
end


-- Workspace rules
-----------------------------------------------
local function create_workspaces(monitor)
	for n = 1, PER_MONITOR do
		hl.workspace_rule({
			workspace  = tostring(group_start(monitor.id) + n),
			monitor    = monitor.name,
			default    = (n == 1),
			persistent = true,
		})
	end
end

for _, monitor in ipairs(hl.get_monitors()) do
	create_workspaces(monitor)
end
hl.on("monitor.added", create_workspaces)

hl.on("monitor.removed", function(monitor)
	local target = hl.get_active_monitor()
	if target == nil or target.id == monitor.id then
		return
	end
	local lost = group_start(monitor.id)
	for _, window in ipairs(hl.get_windows()) do
		local ws = window.workspace
		if ws ~= nil and not ws.special and ws.id > lost and ws.id <= lost + PER_MONITOR then
			hl.dispatch(hl.dsp.window.move({
				workspace = group_start(target.id) + (ws.id - lost),
				follow    = false,
				window    = window,
			}))
		end
	end
end)


-- Bind helpers
-----------------------------------------------
local function target_workspace(n)
	local monitor = hl.get_active_monitor()
	return group_start(monitor and monitor.id or 0) + n
end

-- The workspace delta steps away from the current one, clamped to the
-- focused monitor's group (walks into empty workspaces, like the old
-- plain +1/-1, but can no longer wander into another monitor's group).
local function relative_target(delta)
	local monitor = hl.get_active_monitor()
	if monitor == nil or monitor.active_workspace == nil then
		return nil
	end
	local start = group_start(monitor.id)
	local n = monitor.active_workspace.id - start
	if n < 1 or n > PER_MONITOR then
		return nil
	end
	return start + math.max(1, math.min(PER_MONITOR, n + delta))
end

-- SUPER+N: focus workspace n of the focused monitor.
function M.focus(n)
	return function()
		hl.dispatch(hl.dsp.focus({ workspace = target_workspace(n) }))
	end
end

-- Move the active window to workspace n of the focused monitor.
function M.move(n, follow)
	return function()
		hl.dispatch(hl.dsp.window.move({ workspace = target_workspace(n), follow = follow }))
	end
end

-- Focus the workspace delta steps away on the focused monitor.
function M.focus_relative(delta)
	return function()
		local target = relative_target(delta)
		if target then
			hl.dispatch(hl.dsp.focus({ workspace = target }))
		end
	end
end

-- Move the active window delta workspaces away on the focused monitor.
function M.move_relative(delta, follow)
	return function()
		local target = relative_target(delta)
		if target then
			hl.dispatch(hl.dsp.window.move({ workspace = target, follow = follow }))
		end
	end
end

return M
