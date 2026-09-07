# ----------------------------------------------------------------------------
# hosts/vm -- QEMU test machine.
# ----------------------------------------------------------------------------
{ lib, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/core.nix
    ../../modules/desktop.nix
    ../../modules/zen.nix
  ];


  # users
  # ---------------------------------------------
  core.username = "kaicheng.qi";


  # desktop
  # ---------------------------------------------
  desktop.monitors = [
    { output = "Virtual-1"; }
  ];


  # networking
  # ---------------------------------------------
  networking.hostName = "vm-arm64";
  networking.useDHCP = false;


  # services
  # ---------------------------------------------
  services.qemuGuest.enable = true;

  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = lib.mkForce true;
  };

  system.stateVersion = "26.05";
}
