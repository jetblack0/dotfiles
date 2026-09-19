-- Swayimg
-- ---------------------------------------------

local helper = os.getenv("HOME") .. "/.config/swayimg/actions.sh"

-- single-quote a string for /bin/sh
local function shq(s)
	return "'" .. s:gsub("'", "'\\''") .. "'"
end

-- run actions.sh <name> <current image path>
local function action(name)
	return function()
		local img = swayimg.viewer.get_image()
		if not img then
			return
		end
		os.execute("sh " .. shq(helper) .. " " .. name .. " " .. shq(img.path) .. " >/dev/null 2>&1")
		if name == "delete" then
			swayimg.imagelist.remove(img.path)
		end
	end
end

swayimg.viewer.on_key("w", action("wallpaper"))          -- set as the noctalia wallpaper
swayimg.viewer.on_key("y", action("copy-image"))         -- copy the image itself to the clipboard
swayimg.viewer.on_key("p", action("copy-abs"))           -- copy the absolute path
swayimg.viewer.on_key("Shift+p", action("copy-rel"))     -- copy the path relative to $PWD
swayimg.viewer.on_key("Shift+Delete", action("delete"))  -- delete the file (plain Delete still just drops it from the list)


-- Adjustments
-- ---------------------------------------------

-- metadata overlay hidden on open; the stock `t` toggles it back on.
swayimg.text.visible = false

-- q quits, in both modes.
swayimg.viewer.on_key("q", function() swayimg.exit() end)
swayimg.gallery.on_key("q", function() swayimg.exit() end)

-- vi keys to pan the image
local function pan(dx, dy)
	return function()
		local p = swayimg.viewer.get_position()
		swayimg.viewer.set_abs_position(p.x + dx, p.y + dy)
	end
end
swayimg.viewer.on_key("h", pan(10, 0))
swayimg.viewer.on_key("l", pan(-10, 0))
swayimg.viewer.on_key("k", pan(0, 10))
swayimg.viewer.on_key("j", pan(0, -10))

-- vi keys to move the selection in the thumbnail gallery.
swayimg.gallery.on_key("h", function() swayimg.gallery.select("left") end)
swayimg.gallery.on_key("l", function() swayimg.gallery.select("right") end)
swayimg.gallery.on_key("k", function() swayimg.gallery.select("up") end)
swayimg.gallery.on_key("j", function() swayimg.gallery.select("down") end)
