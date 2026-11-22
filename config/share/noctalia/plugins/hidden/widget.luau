-- Hidden windows -- bar widget
-- ---------------------------------------------
-- Lists the workspaces on this bar's monitor that have hidden windows, by
-- their Super+N number. A hidden window lives in the special workspace
-- "special:hidden-<id>", so noctalia's own workspaces widget shows <id> as
-- empty. Plugins can't read the compositor, so this polls hyprctl.
-- The tooltip names the hidden windows; a click goes to the next workspace
-- that has some.

-- workspaces.lua: each monitor owns ids monitor*10+1 .. monitor*10+10
local PER_MONITOR = 10
local PREFIX = "special:hidden-"

noctalia.setUpdateInterval(1000)

local output = ""
local shown = ""    -- what's drawn now, to skip redraws
local targets = {}  -- the workspace ids with hidden windows, in order
local current = 0   -- this monitor's active workspace id

local function decode(result)
	if result.exitCode ~= 0 then
		return nil
	end
	return noctalia.json.decode(result.stdout)
end

local function draw(numbers, lines)
	local key = table.concat(numbers, " ") .. "\n" .. table.concat(lines, "\n")
	if key == shown then
		return
	end
	shown = key
	barWidget.setVisible(#numbers > 0)
	if #numbers == 0 then
		return
	end
	barWidget.setGlyph("eye-off")
	barWidget.setText(table.concat(numbers, " "))
	barWidget.setTooltip(table.concat(lines, "\n") .. "\n\nClick: go to the next one")
end

-- clients + monitors -> this monitor's stashes, sorted by workspace
local function collect(clients, monitors)
	local monitor = nil
	for _, m in ipairs(monitors) do
		if m.name == output then
			monitor = m
		end
	end
	if monitor == nil then
		return {}, {}
	end
	current = monitor.activeWorkspace and monitor.activeWorkspace.id or 0
	local first = monitor.id * PER_MONITOR

	local byId = {}
	for _, c in ipairs(clients) do
		local name = c.workspace and c.workspace.name or ""
		-- a plain prefix check: "-" is special in Lua patterns
		local id = nil
		if name:sub(1, #PREFIX) == PREFIX then
			id = tonumber(name:sub(#PREFIX + 1))
		end
		if id ~= nil and id > first and id <= first + PER_MONITOR then
			byId[id] = byId[id] or {}
			-- the class is the program; the title is often just "zsh"
			local label = (c.class ~= "" and c.class) or c.title or "?"
			table.insert(byId[id], label)
		end
	end

	local ids = {}
	for id in pairs(byId) do
		table.insert(ids, id)
	end
	table.sort(ids)

	local numbers, lines = {}, {}
	for _, id in ipairs(ids) do
		local n = tostring(id - first)
		table.insert(numbers, n)
		table.insert(lines, n .. ": " .. table.concat(byId[id], ", "))
	end
	targets = ids
	return numbers, lines
end

function update()
	-- barWidget only answers in update(), not in the runAsync callbacks
	output = barWidget.outputName()
	noctalia.runAsync({ "hyprctl", "clients", "-j" }, function(clientsResult)
		local clients = decode(clientsResult)
		if clients == nil then
			return
		end
		noctalia.runAsync({ "hyprctl", "monitors", "-j" }, function(monitorsResult)
			local monitors = decode(monitorsResult)
			if monitors == nil then
				return
			end
			draw(collect(clients, monitors))
		end)
	end)
end

-- the first workspace with hidden windows after the active one, wrapping
function onClick()
	if #targets == 0 then
		return
	end
	local target = targets[1]
	for _, id in ipairs(targets) do
		if id > current then
			target = id
			break
		end
	end
	noctalia.runAsync({ "hyprctl", "dispatch", "hl.dsp.focus({ workspace = " .. target .. " })" })
end
