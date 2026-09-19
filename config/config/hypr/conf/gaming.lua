-- Gaming
-----------------------------------------------
-- Patterns are RE2, Hyprland matches them with RE2::FullMatch.
local games = {
	[[steam_app_\d+]],
}

for _, class in ipairs(games) do
	hl.window_rule({ match = { class = class }, content = "game" })
	hl.window_rule({ match = { class = class }, idle_inhibit = "fullscreen" })

	-- tearing.
	-- hl.window_rule({ match = { class = class }, immediate = true })

	-- locks the pointer to the game's monitor.
	-- hl.window_rule({ match = { class = class }, confine_pointer = true })
end


-- Steam windows
-----------------------------------------------
hl.window_rule({
	match = { class = "steam", initial_title = "Friends List" },
	float = true,
	min_size = { 460, 640 },
})
