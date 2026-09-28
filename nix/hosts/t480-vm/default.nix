# ----------------------------------------------------------------------------
# hosts/t480-vm -- nixos qemu vm on the t480.
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
      scale = 1.2;
    }
  ];

  desktop.xwaylandDpi = 115;
  desktop.lockscreenHeight = 900;

  programs.noctalia-greeter.settings.output = {
    width = 1920;
    height = 1080;
    scale = 1.2;
  };

  # VM-only: with 3d graphics (virgl) the greeter's hardware cursor shows
  # upside down. Draw the cursor in software instead.
  services.greetd.settings.default_session.command = lib.mkForce
    "env WLR_NO_HARDWARE_CURSORS=1 ${config.programs.noctalia-greeter.package}/bin/noctalia-greeter-session";


  # networking
  # ---------------------------------------------
  networking.hostName = "t480-vm";
  networking.useDHCP = false;


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
