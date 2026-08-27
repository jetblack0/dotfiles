# ----------------------------------------------------------------------------
# hosts/vm -- QEMU test machine.
# ----------------------------------------------------------------------------
{
  lib,
  username,
  ...
}:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/core.nix
  ];


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
