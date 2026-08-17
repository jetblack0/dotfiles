-- Plugins
-- ---------------------------------------------
-- Bundled with yazi: remembers yanked files across instances.
require("session"):setup {
	sync_yanked = true,
}

-- `l` enters directories and opens files with one key.
require("smart-enter"):setup {
	open_multi = true,
}

-- Rounded border around every pane.
-- ya pkg add yazi-rs/plugins:full-border
require("full-border"):setup()
-- ---------------------------------------------


-- Header
-- ---------------------------------------------
Header:children_add(function()
	return ui.Span("󱙝  "):fg("gray"):bold(true)
end, 500, Header.LEFT)
-- ---------------------------------------------
