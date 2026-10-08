-- Permissions
-----------------------------------------------
-- Hyprland asks (Deny / Allow once / Allow and remember) before a program
-- with no rule here captures the screen. Rules match the program's real
-- path: /usr/... on Arch, /nix/store/<hash>-<pkg>/... on NixOS.
-- Read once when Hyprland starts: a change needs a new login, not a reload.
-- The dialog is hyprland-dialog (hyprland-guiutils); without it Hyprland
-- skips the check and allows everything.
-- It can't catch a program that runs one of the tools below itself, nor
-- gpu-screen-recorder's KMS capture, which never asks the compositor.

hl.config({ ecosystem = { enforce_permissions = true } })

-- our own capture tools
for _, tool in ipairs({ "grim", "still", "hyprpicker" }) do
	hl.permission({
		binary = "(/usr|/nix/store/[^/]+)/bin/" .. tool,
		type = "screencopy",
		mode = "allow",
	})
end

-- screen sharing
hl.permission({
	binary = [[(/usr/lib|/nix/store/[^/]+/libexec)/\.?xdg-desktop-portal-hyprland(-wrapped)?]],
	type = "screencopy",
	mode = "allow",
})
