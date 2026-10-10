-- rsync-paste
-- ---------------------------------------------
-- Paste the yanked files into the current directory with rsync instead of a
-- plain copy. A cut yank (d) removes each source file once it is copied.

-- .path, not tostring(): newer yazi yanks File objects, and tostring() of
-- one is "File: 0x…", which rsync takes for a remote host:path
local state = ya.sync(function()
	local files = {}
	for _, item in pairs(cx.yanked) do
		files[#files + 1] = tostring(item.path)
	end
	return files, cx.yanked.is_cut, tostring(cx.active.current.cwd.path)
end)

local function notify(content, level)
	ya.notify { title = "rsync-paste", content = content, timeout = 4, level = level or "info" }
end

return {
	entry = function()
		local files, cut, cwd = state()
		if #files == 0 then
			return notify("nothing yanked", "warn")
		end

		local args = { "--archive", "--human-readable", "--info=progress2" }
		if cut then
			args[#args + 1] = "--remove-source-files"
		end
		args[#args + 1] = "--"
		for _, f in ipairs(files) do
			args[#args + 1] = f
		end
		args[#args + 1] = cwd .. "/"

		-- hand the terminal to rsync so its progress shows
		local permit = ui.hide()
		local status, err = Command("rsync")
			:arg(args)
			:stdin(Command.INHERIT)
			:stdout(Command.INHERIT)
			:stderr(Command.INHERIT)
			:status()
		local ok = status and status.success
		if not ok then
			-- keep rsync's error on screen until it has been read
			Command("sh")
				:arg({ "-c", "printf '\\nrsync failed, press enter to go back '; read -r _" })
				:stdin(Command.INHERIT)
				:stdout(Command.INHERIT)
				:status()
		end
		permit:drop()

		if not ok then
			return notify(err and tostring(err) or "rsync failed", "error")
		end
		if cut then
			ya.emit("unyank", {})
		end
		notify(string.format("%s %d item(s)", cut and "moved" or "synced", #files))
	end,
}
