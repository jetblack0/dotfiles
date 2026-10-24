# ----------------------------------------------------------------------------
# hosts/t14p/nvidia.nix -- RTX 5060.
# ----------------------------------------------------------------------------
# - PRIME offload: nvidia-offload gamemoderun mangohud %command%
# - modesetting: on by default for driver 535 and newer.
# - driver: pinned to 595.104.02, RTX 50 cards need 570.86 or newer.
{ config, ... }:

{
  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.graphics.enable = true;
  hardware.nvidia = {
    # The RTX 50 series (Blackwell) only works with NVIDIA's open kernel
    # module.
    open = true;

    # nixos-26.05's driver (595.71.05) doesn't build on Linux 7.2 or newer
    # (nixpkgs issue #554125), and the maintainers won't backport the fix.
    # This is unstable's production driver. Drop the pin once 26.05's own
    # driver builds with the zen kernel.
    package = config.boot.kernelPackages.nvidiaPackages.mkDriver {
      version = "595.104.02";
      sha256_64bit = "sha256-5CHCAuTHn1jDx/MWG75xRU67PYiTb4ggWg4yfNBMWco=";
      sha256_aarch64 = "sha256-PafStmwNMufeDp3VtpTGGCoW+53Gor/mieO1m1pI7gI=";
      openSha256 = "sha256-FWk5ra2yjz8VAxAA8GXrSoeBj/XC1BKvsKsBKR09joE=";
      settingsSha256 = "sha256-4Kxro6tvI5aX4nu2RspgyBsW+Jq3/VYjSAS5UGdzTCU=";
      persistencedSha256 = "sha256-JsMLPqJuZwAtHngsQODMsmgO7F2tVkQ2arc7fYa2bwo=";
    };

    # Save the card's memory across suspend, and power the card fully off
    # while nothing uses it.
    powerManagement.enable = true;
    powerManagement.finegrained = true;

    # Shift unused cpu power to the gpu (nvidia-powerd).
    dynamicBoost.enable = true;

    prime = {
      offload.enable = true;
      # installs the `nvidia-offload` wrapper
      offload.enableOffloadCmd = true;

      # 00:02.0  Intel Panther Lake graphics [8086:b0a0]
      intelBusId = "PCI:0@0:2:0";
      # 01:00.0  NVIDIA GB206M, GeForce RTX 5060 Laptop [10de:2d19]
      nvidiaBusId = "PCI:1@0:0:0";
    };
  };

  # the driver is unfree
  nixpkgs.config.allowUnfreePackages = [
    "nvidia-x11"
    "nvidia-settings"
  ];
}
