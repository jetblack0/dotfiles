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
    ../../modules/gaming.nix
    ../../modules/winebox.nix
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

  # Hand the laptop's windows licence to the windows vm.
  virt.oemKey = true;

  # Allow libvirt's qemu user to pass through user home.
  virt.homeAccess = true;


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
  desktop.recordingDirectory = "~/assets/media/vids/recording";
  desktop.inputDevices."tpps/2-synaptics-trackpoint".sensitivity = -0.5;
  desktop.inputDevices."elan06b0:00-04f3:3327-touchpad" = {
    sensitivity = -0.15;
    scroll_factor = 0.2;
  };
  desktop.inputDevices."logitech-g-pro--1".sensitivity = -1.0;

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

  boot.kernelParams = [
    "xe.enable_psr=0"
    "xe.enable_panel_replay=0"

    # FRED is the new way Panther Lake CPUs hand faults to the kernel. Before
    # Linux 7.2.8 it reports the wrong error code and instruction address
    # when a program runs a rejected INT instruction. Wine relies on that
    # for INT 0x2d, so Elden Ring (and some other Windows games) crash a
    # minute or two after launch. Turning FRED off brings back the old
    # mechanism. Games and graphics run the same; heavy disk, network and
    # database work is somewhat slower (Phoronix, "FRED Benchmarks On
    # Panther Lake").
    #
    # Solved in the current kernel: zen 7.2.11 has the fix.
    # "fred=off"
  ];


  # firmware
  # ---------------------------------------------
  services.fwupd.enable = true;


  # networking
  # ---------------------------------------------
  networking.hostName = "t14p";
  networking.domain   = "kaicheng.local";
  # no firewall
  networking.firewall.enable = false;

  # time
  # ---------------------------------------------
  time.timeZone = "Asia/Shanghai";

  system.stateVersion = "26.05";
}
