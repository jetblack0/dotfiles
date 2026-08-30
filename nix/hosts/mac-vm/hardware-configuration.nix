# ----------------------------------------------------------------------------
# What nixos-generate-config emits for the parallels vm.
# ----------------------------------------------------------------------------
{ lib, ... }:

{
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.initrd.availableKernelModules = [
    "ehci_pci"
    "xhci_pci"
    "usbhid"
    "sr_mod"
  ];

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/c542200f-1351-42fe-8264-e2df5b626e46";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/FA66-02E4";
    fsType = "vfat";
    options = [
      "fmask=0022"
      "dmask=0022"
    ];
  };

  swapDevices = [
    { device = "/dev/disk/by-uuid/a4b931ff-811f-4a56-a2db-a821aecbfc51"; }
  ];

  nixpkgs.hostPlatform = lib.mkDefault "aarch64-linux";

  # parallels guest tools (unfree)
  hardware.parallels.enable = true;
  nixpkgs.config.allowUnfreePackages = [ "prl-tools" ];
}
