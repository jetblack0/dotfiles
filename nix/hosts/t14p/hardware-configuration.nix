{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];

  # Unlike the VMs, real firmware may keep its own boot entries, so the
  # installer is allowed to write one.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.initrd.availableKernelModules = [ "xhci_pci" "thunderbolt" "nvme" "usb_storage" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  # Disks by label, set during the install:
  #   ESP        the boot partition
  #   cryptroot  the LUKS container on the system SSD
  #   root       the ext4 filesystem inside it
  fileSystems."/" =
    { device = "/dev/disk/by-label/root";
      fsType = "ext4";
    };

  boot.initrd.luks.devices."cryptroot".device = "/dev/disk/by-label/cryptroot";

  fileSystems."/boot" =
    { device = "/dev/disk/by-label/ESP";
      fsType = "vfat";
      options = [ "fmask=0077" "dmask=0077" ];
    };

  # The data drive (BC711)
  # ---------------------------------------------
  environment.etc."crypttab".text = ''
    cryptdata  /dev/disk/by-label/cryptdata  /etc/luks/lukskey-cryptdata  discard
  '';

  fileSystems."/home/${config.core.username}/assets" =
    { device = "/dev/disk/by-label/data";
      fsType = "ext4";
    };

  swapDevices = [ ];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.npu.enable = true;
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
