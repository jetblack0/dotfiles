-- hide status bar
-- function Status:render() return {} end
--
-- local old_manager_render = Manager.render
-- function Manager:render(area)
-- 	return old_manager_render(self, ui.Rect { x = area.x, y = area.y, w = area.w, h = area.h + 1 })
-- end

require("session"):setup {
	sync_yanked = true,
}

-- rounded border. NOTE: run `ya pack -a yazi-rs/plugins#full-border` to install the plugin
require("full-border"):setup()

-- show more stuff in header
Header:children_add(function()
	if ya.target_family() ~= "unix" then
		return ui.Line {}
	end
	return ui.Span(" "):fg("gray"):bold(true)
	-- return ui.Span(ya.user_name() .. "@" .. ya.host_name() .. ":"):fg("blue")
end, 500, Header.LEFT)
