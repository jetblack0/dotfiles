# ----------------------------------------------------------------------------
# hosts/t14p-vm -- nixos qemu vm on the t14p.
# ----------------------------------------------------------------------------
{ lib, config, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/core.nix
    ../../modules/desktop.nix
    ../../modules/zen.nix
    ../../modules/input-method.nix
    ../../modules/sing-box.nix
    ../../modules/virt.nix
    ../../modules/gaming.nix
    ../../modules/winebox.nix
  ];


  # users
  # ---------------------------------------------
  core.username = "kaicheng.qi";


  # desktop
  # ---------------------------------------------
  desktop.monitors = [
    {
      output = "Virtual-1";
      mode = "preferred";
      scale = 2;
    }
  ];

  desktop.xwaylandDpi = 192;
  desktop.lockscreenHeight = 960;
  desktop.mediaMaxLength = 134;

  programs.noctalia-greeter.settings.output = {
    width = 3072;
    height = 1920;
    scale = 2;
  };

  services.greetd.settings.default_session.command = lib.mkForce
    "env WLR_NO_HARDWARE_CURSORS=1 ${config.programs.noctalia-greeter.package}/bin/noctalia-greeter-session";

  services.greetd.settings.initial_session = {
    command = "${config.programs.uwsm.package}/bin/uwsm start -e -D Hyprland hyprland.desktop";
    user = config.core.username;
  };


  # networking
  # ---------------------------------------------
  networking.hostName = "t14p-vm";
  networking.useDHCP = false;

  networking.firewall.checkReversePath = "loose";


  # time
  # ---------------------------------------------
  time.timeZone = "Asia/Shanghai";


  # services
  # ---------------------------------------------
  services.qemuGuest.enable = true;

  core.sshAutostart = true;
  services.openssh.settings.PermitRootLogin = lib.mkForce "prohibit-password";

  system.stateVersion = "26.05";
}
