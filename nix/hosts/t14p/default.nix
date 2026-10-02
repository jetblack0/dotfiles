# ----------------------------------------------------------------------------
# hosts/t14p: Core Ultra 7 356H, RTX 5060, 32 GB.
# ----------------------------------------------------------------------------
{ pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./nvidia.nix
    ../../modules/core.nix
    ../../modules/desktop.nix
    ../../modules/zen.nix
    ../../modules/input-method.nix
    ../../modules/sing-box.nix
    ../../modules/virt.nix
    ../../modules/data.nix
  ];


  # users
  # ---------------------------------------------
  core.username = "kaicheng.qi";


  # data drive
  # ---------------------------------------------
  data.enable = true;


  # proxy
  # ---------------------------------------------
  # Start the tun profile at boot.
  singBox.autostartProfiles = [ "tun" ];

  # Send all DNS to the tun.
  singBox.dnsOverride = true;


  # virtualisation
  # ---------------------------------------------
  virt.dockerGroup = true;


  # swap
  # ---------------------------------------------
  # Default: zstd, up to half the RAM, and nothing reserved until it's used,
  # no hibernation.
  zramSwap.enable = true;


  # desktop
  # ---------------------------------------------
  # 14.5" 3072x1920 panel, 120 Hz with variable refresh, about 250 ppi.
  desktop.monitors = [
    {
      output = "eDP-1";
      mode = "3072x1920@120";
      scale = 2;
    }
  ];

  # Xft.dpi for xwayland apps: 96 * scale.
  desktop.xwaylandDpi = 192;

  # logical height: 1920 / scale
  desktop.lockscreenHeight = 960;

  desktop.mediaMaxLength = 134;

  desktop.inputDevices."tpps/2-synaptics-trackpoint".sensitivity = -0.5;

  programs.noctalia-greeter.settings.output = {
    width = 3072;
    height = 1920;
    scale = 2;
  };


  # graphics
  # ---------------------------------------------
  # Intel's va-api driver, for hardware video decode and encode on the iGPU
  # (gpu-screen-recorder, mpv). mesa has none for Intel. Panther Lake needs
  # 25.2 or newer.
  hardware.graphics.extraPackages = [ pkgs.intel-media-driver ];


  # kernel
  # ---------------------------------------------
  boot.kernelPackages = pkgs.linuxPackages_zen;


  # networking
  # ---------------------------------------------
  networking.hostName = "t14p";
  networking.domain   = "kaicheng.local";


  # time
  # ---------------------------------------------
  time.timeZone = "Asia/Shanghai";

  system.stateVersion = "26.05";
}
