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


-- Hidden windows
-----------------------------------------------
-- The focused monitor's regular workspace and its stash. While a special
-- workspace is shown, the monitor's active workspace is still the regular one.
local function stash()
	local monitor = hl.get_active_monitor()
	if monitor == nil or monitor.active_workspace == nil then
		return nil
	end
	local id = monitor.active_workspace.id
	return id, "special:hidden-" .. id
end

local function in_stash(window, name)
	local ws = window.workspace
	return ws ~= nil and ws.special and ws.name == name
end

local function stashed(name)
	local windows = {}
	for _, window in ipairs(hl.get_windows()) do
		if in_stash(window, name) then
			table.insert(windows, window)
		end
	end
	return windows
end

local function peeking(name)
	local shown = hl.get_active_special_workspace()
	return shown ~= nil and shown.name == name
end

-- toggle_special takes the name without the "special:" prefix.
local function toggle(name)
	hl.dispatch(hl.dsp.workspace.toggle_special(name:sub(#"special:" + 1)))
end

-- Close the peek once the stash is empty.
local function close_if_empty(name)
	if peeking(name) and #stashed(name) == 0 then
		toggle(name)
	end
end

-- Hide the active window in the current workspace's stash. While peeking,
-- the focused stashed window goes back to the workspace instead.
function M.hide()
	return function()
		local window = hl.get_active_window()
		local id, name = stash()
		if window == nil or id == nil then
			return
		end
		if in_stash(window, name) then
			hl.dispatch(hl.dsp.window.move({ workspace = id, follow = false, window = window }))
			close_if_empty(name)
		else
			hl.dispatch(hl.dsp.window.move({ workspace = name, follow = false, window = window }))
		end
	end
end

-- Bring every window in the current workspace's stash back. The windows are
-- picked by workspace name, so a stash that was never used matches nothing.
function M.restore()
	return function()
		local id, name = stash()
		if id == nil then
			return
		end
		for _, window in ipairs(stashed(name)) do
			hl.dispatch(hl.dsp.window.move({ workspace = id, follow = false, window = window }))
		end
		close_if_empty(name)
	end
end

-- Show or hide the current workspace's stash on top of it. An empty stash
-- has nothing to show, so it is not opened.
function M.peek()
	return function()
		local _, name = stash()
		if name == nil then
			return
		end
		if peeking(name) or #stashed(name) > 0 then
			toggle(name)
		end
	end
end

return M
