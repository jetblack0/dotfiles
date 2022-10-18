---------------------------
-- Default awesome theme --
---------------------------

local theme_assets = require("beautiful.theme_assets")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi

local gfs = require("gears.filesystem")
local themes_path = gfs.get_themes_dir()
local shape = require("gears.shape")

local theme = {}

-- A bunch of color
local lightBlue = "#88a2b1"
local lightGreen = "#689d6a"

local layoutIconPath = "/home/jetblack/.config/awesome/images/wibar/layout/"

-- Iosevka Nerd Font 10
theme.font          = "Iosevka Nerd Font 10"

theme.bg_normal     = lightBlue --"#222222"
theme.bg_focus      = ""
theme.bg_urgent     = "#ff0000"
theme.bg_minimize   = "#444444"
-- theme.bg_systray    = theme.bg_normal

theme.fg_normal     = "black"
theme.fg_focus      = "#ebdbb2" --lightwhite
theme.fg_urgent     = "#ffffff"
theme.fg_minimize   = "#ffffff"

theme.useless_gap   = 5
theme.border_width  = 0
theme.border_normal = lightBlue
theme.border_focus  = "#535d6c"
theme.border_marked = "#91231c"

-- There are other variable sets
-- overriding the default one when
-- defined, the sets are:
-- taglist_[bg|fg]_[focus|urgent|occupied|empty|volatile]
-- tasklist_[bg|fg]_[focus|urgent]
-- titlebar_[bg|fg]_[normal|focus]
-- tooltip_[font|opacity|fg_color|bg_color|border_width|border_color]
-- mouse_finder_[color|timeout|animate_timeout|radius|factor]
-- prompt_[fg|bg|fg_cursor|bg_cursor|font]
-- hotkeys_[bg|fg|border_width|border_color|shape|opacity|modifiers_fg|label_bg|label_fg|group_margin|font|description_font]
-- Example:
--theme.taglist_bg_focus = "#ff0000"

-- {{{ Hotkeys help menu:
theme.hotkeys_bg = lightBlue
theme.hotkeys_fg = "black"
theme.hotkeys_description_font = "Iosevka Nerd Font"
theme.hotkeys_font = "CaskaydiaCove Nerd Font"
theme.hotkeys_opacity = 0.92
theme.hotkeys_modifiers_fg = "#d5c4a1" -- white
theme.hotkeys_label_bg = lightGreen
theme.hotkeys_label_fg = "black"
theme.hotkeys_group_margin = 30
-- }}}

-- {{{ Calendar
-- beautiful.calendar_[flag]_[property]=val
-- flag: year, month, yearheader, header, weekday, weeknumber, normal, focus
-- property: markup, fg_color, bg_color, shape, padding, border_width, border_color, opacity

theme.calendar_month_border_width = 5
theme.calendar_month_border_color = lightBlue
theme.calendar_focus_bg_color = lightGreen
theme.calendar_month_opacity = 0.92
-- theme.calendar_header_padding = 5
-- }}}

-- taglist:
theme.taglist_fg_empty = "#87af87"
theme.taglist_fg_occupied = "#d3859a"
theme.taglist_fg_focus = "#d79920"
theme.taglist_bg_focus = ""


-- Variables set for theming notifications:
-- notification_font
-- notification_[bg|fg]
-- notification_[width|height|margin]
-- notification_[border_color|border_width|shape|opacity]
-- theme.notification_margin = 5
theme.notification_bg = lightBlue
theme.notification_fg = "black"
theme.notification_border_color = lightBlue


-- Variables set for theming the menu:
-- menu_[bg|fg]_[normal|focus]
-- menu_[border_color|border_width]
-- theme.menu_bg_normal = "#88a2b1"
-- menu_[border_color|border_width]

-- theme.menu_submenu_icon = themes_path.."default/submenu.png"
theme.menu_submenu = ""
theme.menu_height = dpi(20)
theme.menu_width  = dpi(105)

-- You can add as many variables as
-- you wish and access them by using
-- beautiful.variable in your rc.lua
--theme.bg_widget = "#cc0000"


-- You can use your own layout icons like this:
--theme.layout_fairh = themes_path.."default/layouts/fairhw.png"
theme.layout_fairv = layoutIconPath .. "fair-outline.svg"
theme.layout_tile = layoutIconPath .. "tile.svg"
theme.layout_tilebottom = layoutIconPath .. "tileBottom-outline.svg"
theme.layout_dwindle = layoutIconPath .. "spiralDwindle-outline.svg"
theme.layout_magnifier = layoutIconPath .. "magnifier-outline.svg"

--[[ theme.layout_floating  = themes_path.."default/layouts/floatingw.png"
theme.layout_max = themes_path.."default/layouts/maxw.png"
theme.layout_fullscreen = themes_path.."default/layouts/fullscreenw.png"
theme.layout_tileleft   = themes_path.."default/layouts/tileleftw.png"
theme.layout_tiletop = themes_path.."default/layouts/tiletopw.png"
theme.layout_cornernw = themes_path.."default/layouts/cornernww.png"
theme.layout_cornerne = themes_path.."default/layouts/cornernew.png"
theme.layout_cornersw = themes_path.."default/layouts/cornersww.png"
theme.layout_cornerse = themes_path.."default/layouts/cornersew.png" --]]

-- Generate Awesome icon:
theme.awesome_icon = theme_assets.awesome_icon(
    theme.menu_height, theme.bg_focus, theme.fg_focus
)
-- Define the icon theme for application icons. If not set then the icons
-- from /usr/share/icons and /usr/share/icons/hicolor will be used.
theme.icon_theme = "/usr/share/icons/Papirus-Dark"

return theme

-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80
