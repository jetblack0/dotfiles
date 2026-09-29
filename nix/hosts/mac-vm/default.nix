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
    ../../modules/input-method.nix
    ../../modules/sing-box.nix
    ../../modules/virt.nix
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

  # media widget cap, for a screen 1600 logical px wide; with a long window
  # class and a long song, about a fifth of the bar's left half stays free
  desktop.mediaMaxLength = 150;

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


  # virt
  # ---------------------------------------------
  virt.dockerGroup = true;


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
