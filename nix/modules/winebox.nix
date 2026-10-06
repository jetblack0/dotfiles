# ----------------------------------------------------------------------------
# winebox (wine + bubblewrap).
# ----------------------------------------------------------------------------
# The script itself is config/bin/linux/winebox, deployed to ~/.local/bin
# with the other scripts (core.nix). This module gives it the tools it calls.
{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    wineWow64Packages.stableFull # x11 and wayland drivers; waylandFull has no x11
    winetricks
    bubblewrap
    passt # pasta: the box's network with --net
    (callPackage ../packages/wl-sandbox.nix { })
  ];
}
