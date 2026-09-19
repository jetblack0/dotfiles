# ----------------------------------------------------------------------------
# hosts/mac-vm -- Parallels test machine on the mac.
# ----------------------------------------------------------------------------
{ lib, config, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/core.nix
    ../../modules/desktop.nix
    ../../modules/zen.nix
    ../../modules/sing-box.nix
    # ../../modules/data.nix
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

  # 96 * scale
  desktop.xwaylandDpi = 154;
  desktop.lockscreenHeight = 1000;

  # the parallels virtual display advertises a bogus preferred mode
  # (1448x906, no EDID size); pin the greeter to the real panel
  programs.noctalia-greeter.settings.output = {
    width = 2560;
    height = 1600;
    scale = 1.6;
  };

  # VM-only: real gpus do scan-out correctly
  services.greetd.settings.default_session.command = lib.mkForce
    "env WLR_SCENE_DISABLE_DIRECT_SCANOUT=1 ${config.programs.noctalia-greeter.package}/bin/noctalia-greeter-session";


  # networking
  # ---------------------------------------------
  networking.hostName = "mac-vm";
  networking.useDHCP = false;


  # time
  # ---------------------------------------------
  time.timeZone = "Asia/Shanghai";


  # services
  # ---------------------------------------------
  core.sshAutostart = true;

  system.stateVersion = "26.05";
}
