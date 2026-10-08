# ----------------------------------------------------------------------------
# Containers and virtual machines.
# ----------------------------------------------------------------------------
{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.virt;
  username = config.core.username;
in
{
  # per-host knobs
  # ---------------------------------------------
  options.virt.dockerGroup = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = ''
      Put the primary user in the docker group. Off by default.
    '';
  };

  options.virt.oemKey = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = ''
      Copy the firmware's windows licence table (MSDM) to
      /var/lib/libvirt/oem/MSDM, for a windows guest to activate with.
      Off by default: the windows vm lives on the data drive, not in the repo.
    '';
  };

  config = {
    # docker
    # ---------------------------------------------
    virtualisation.docker = {
      enable = true;
      enableOnBoot = false;
    };


    # libvirt
    # ---------------------------------------------
    virtualisation.libvirtd = {
      enable = true;
      qemu.runAsRoot = false;

      # emulated TPM 2.0, which windows 11 requires
      qemu.swtpm.enable = true;

      # virtiofsd, for virtiofs shared folders
      qemu.vhostUserPackages = [ pkgs.virtiofsd ];

      # resolve a running guest by its libvirt domain name
      nss.enableGuest = true;
    };
    programs.virt-manager.enable = true;

    # lets virt-manager hand a host usb device to a guest over spice
    virtualisation.spiceUSBRedirection.enable = true;

    # the module hardwires libvirtd into multi-user.target; libvirtd.socket
    # stays, so the first virsh or virt-manager call starts it
    systemd.services.libvirtd.wantedBy = lib.mkForce [ ];
    systemd.services.libvirt-guests.wantedBy = lib.mkForce [ "libvirtd.service" ];

    home-manager.users.${username}.dconf.settings."org/virt-manager/virt-manager/connections" = {
      uris = [ "qemu:///system" ];
      autoconnect = [ "qemu:///system" ];
    };


    # windows guests
    # ---------------------------------------------
    # The virtio driver iso, at the path the arch package uses, so a domain
    # xml can name it on both distros. pkgs.virtio-win is the unpacked iso;
    # its src is the iso itself
    systemd.tmpfiles.rules = [
      "L+ /var/lib/libvirt/images/virtio-win.iso - - - - ${pkgs.virtio-win.src}"
    ]
    # The laptop's windows licence lives in the firmware's MSDM acpi table.
    # Copy it where a guest's <acpi><table type='msdm'> can point at it
    ++ lib.optional cfg.oemKey
      "C /var/lib/libvirt/oem/MSDM 0644 root root - /sys/firmware/acpi/tables/MSDM";


    # users
    # ---------------------------------------------
    users.users.${username}.extraGroups = [ "libvirtd" ] ++ lib.optional cfg.dockerGroup "docker";


    # packages
    # ---------------------------------------------
    environment.systemPackages = with pkgs; [
      docker-compose
      tigervnc
      vagrant
      virt-viewer

      # builds the cloud-init seed for the qemu lab's arch guests; arch gets
      # it with virt-install
      xorriso
    ];

    nixpkgs.config.allowUnfreePackages = [ "vagrant" ];
  };
}
