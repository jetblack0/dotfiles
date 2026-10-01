# ----------------------------------------------------------------------------
# hosts/t14p/nvidia.nix -- RTX 5060.
# ----------------------------------------------------------------------------
# - PRIME offload: nvidia-offload gamemoderun mangohud %command%
# - modesetting: on by default for driver 535 and newer.
# - driver branch: `stable`, which is 595.71.05 on nixos-26.05. RTX 50 cards
#   need 570.86 or newer.
# - dynamic boost (nvidia-powerd): off. Turn on with
#   `hardware.nvidia.dynamicBoost.enable = true` if the laptop supports it.
{ ... }:

{
  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.graphics.enable = true;
  hardware.nvidia = {
    # The RTX 50 series (Blackwell) only works with NVIDIA's open kernel
    # module.
    open = true;

    # Save the card's memory across suspend, and power the card fully off
    # while nothing uses it.
    powerManagement.enable = true;
    powerManagement.finegrained = true;

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
