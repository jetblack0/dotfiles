# ----------------------------------------------------------------------------
# winebox (wine + bubblewrap).
# ----------------------------------------------------------------------------
# The script itself is config/bin/linux/winebox, deployed to ~/.local/bin
# with the other scripts (core.nix). This module gives it the tools it calls.
{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    wineWow64Packages.waylandFull
    winetricks
    bubblewrap
    passt # pasta: the box's network with --net
    (callPackage ../packages/wl-sandbox.nix { })
  ];

  # environment.d can't add this on NixOS: uwsm re-imports the login
  # environment, which comes from here.
  environment.sessionVariables.XDG_DATA_DIRS = [ "$HOME/assets/state" ];
}
