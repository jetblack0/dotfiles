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
    };
    programs.virt-manager.enable = true;

    # the module hardwires libvirtd into multi-user.target; libvirtd.socket
    # stays, so the first virsh or virt-manager call starts it
    systemd.services.libvirtd.wantedBy = lib.mkForce [ ];
    systemd.services.libvirt-guests.wantedBy = lib.mkForce [ "libvirtd.service" ];

    home-manager.users.${username}.dconf.settings."org/virt-manager/virt-manager/connections" = {
      uris = [ "qemu:///system" ];
      autoconnect = [ "qemu:///system" ];
    };


    # users
    # ---------------------------------------------
    users.users.${username}.extraGroups = [ "libvirtd" ] ++ lib.optional cfg.dockerGroup "docker";


    # packages
    # ---------------------------------------------
    environment.systemPackages = with pkgs; [
      docker-compose
      vagrant
    ];

    nixpkgs.config.allowUnfreePackages = [ "vagrant" ];
  };
}
