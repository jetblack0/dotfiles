# ----------------------------------------------------------------------------
# Gaming: steam, gamemode, mangohud, gamescope.
# ----------------------------------------------------------------------------
{ config, pkgs, ... }:

let
  username = config.core.username;
in
{
  # Steam
  # ---------------------------------------------
  # Besides the client, this turns on 32-bit graphics
  # (hardware.graphics.enable32Bit), the controller udev rules
  # (hardware.steam-hardware) and 32-bit PipeWire audio.
  programs.steam.enable = true;


  # gamemode
  # ---------------------------------------------
  # Start a game with `gamemoderun %command%`. Check it with `gamemoded -t`.
  programs.gamemode.enable = true;
  users.users.${username}.extraGroups = [ "gamemode" ];


  # gamescope
  # ---------------------------------------------
  programs.gamescope.enable = true;


  # Tools
  # ---------------------------------------------
  environment.systemPackages = with pkgs; [
    mangohud
    vulkan-tools
    heroic
  ];


  # NTSYNC
  # ---------------------------------------------
  # In-kernel Windows sync primitives; proton and wine use them by default
  # once /dev/ntsync exists. The zen kernel builds it in.
  boot.kernelModules = [ "ntsync" ];


  nixpkgs.config.allowUnfreePackages = [
    "steam"
    "steam-unwrapped"
  ];
}
