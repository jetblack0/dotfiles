# ----------------------------------------------------------------------------
# hosts/mac-vm -- Parallels test machine on the mac.
# ----------------------------------------------------------------------------
{ ... }:

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
    {
      output = "Virtual-1";
      mode = "2560x1600@60";
      scale = 1.6;
    }
  ];


  # networking
  # ---------------------------------------------
  networking.hostName = "mac-vm";

  networking.useDHCP = false;
  systemd.network = {
    enable = true;
    networks."20-lan" = {
      matchConfig.Name = "en*";
      networkConfig = {
        DHCP = "ipv4";
        IPv6AcceptRA = true;
      };
      dhcpV4Config.ClientIdentifier = "mac";
      linkConfig.RequiredForOnline = "routable";
    };
  };


  # time
  # ---------------------------------------------
  time.timeZone = "Asia/Shanghai";


  # services
  # ---------------------------------------------
  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "yes";
      PasswordAuthentication = true;
    };
  };

  system.stateVersion = "26.05";
}
