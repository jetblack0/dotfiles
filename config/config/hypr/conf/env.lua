-- Environment
-----------------------------------------------

-- gtk
hl.env("GDK_BACKEND", "wayland,x11")
-- breaks pinentry
-- hl.env("GTK_IM_MODULE", "wayland")

-- qt
hl.env("QT_QPA_PLATFORM", "wayland;xcb")

-- cursor
hl.env("XCURSOR_THEME", "capitaine-cursors")
hl.env("XCURSOR_SIZE", "24")

-- xdg and session
hl.env("XDG_CURRENT_DESKTOP", "Hyprland")
hl.env("XDG_SESSION_TYPE", "wayland")
hl.env("XDG_SESSION_DESKTOP", "Hyprland")

local runtime = os.getenv("XDG_RUNTIME_DIR")
local state = os.getenv("XDG_STATE_HOME") or (os.getenv("HOME") .. "/.local/state")
hl.env("XAUTHORITY", (runtime or (state .. "/hypr")) .. "/Xauthority")

-- nudge programs onto wayland
hl.env("MOZ_ENABLE_WAYLAND", "1")
hl.env("ANKI_WAYLAND", "1")
hl.env("CLUTTER_BACKEND", "wayland")
