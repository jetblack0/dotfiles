# ----------------------------------------------------------------------------
# hosts/vm -- QEMU test machine.
# ----------------------------------------------------------------------------
{ lib, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/core.nix
  ];


  # users
  # ---------------------------------------------
  core.username = "kaicheng.qi";


  # networking
  # ---------------------------------------------
  networking.hostName = "vm-arm64";

  networking.useDHCP = false;
  systemd.network = {
    enable = true;
    networks."20-lan" = {
      matchConfig.Name = "en*";
      networkConfig = {
        DHCP = "ipv4";
        IPv6AcceptRA = true;
      };
      linkConfig.RequiredForOnline = "routable";
    };
  };


  # services
  # ---------------------------------------------
  services.qemuGuest.enable = true;

  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = lib.mkForce true;
  };

  system.stateVersion = "26.05";
}
