-- Environment
-----------------------------------------------

-- gtk
hl.env("GDK_BACKEND", "wayland,x11")
hl.env("GTK_IM_MODULE", "wayland")

-- qt
hl.env("QT_QPA_PLATFORM", "wayland;xcb")

-- xdg and session
hl.env("XDG_CURRENT_DESKTOP", "Hyprland")
hl.env("XDG_SESSION_TYPE", "wayland")
hl.env("XDG_SESSION_DESKTOP", "Hyprland")

-- nudge programs onto wayland
hl.env("MOZ_ENABLE_WAYLAND", "1")
hl.env("ANKI_WAYLAND", "1")
hl.env("CLUTTER_BACKEND", "wayland")
