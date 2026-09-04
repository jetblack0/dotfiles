{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # v5 is not in nixpkgs yet (its noctalia-shell is the retired v4)
    noctalia = {
      url = "github:noctalia-dev/noctalia-shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # the login greeter matching the shell; not in nixpkgs either
    noctalia-greeter = {
      url = "github:noctalia-dev/noctalia-greeter";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # zen is not in nixpkgs at all
    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        home-manager.follows = "home-manager";
      };
    };
  };

  outputs = { nixpkgs, ... } @ inputs:
  let
    mkHost = { system, hostDir, }: nixpkgs.lib.nixosSystem {
      inherit system;
      specialArgs = { inherit inputs; };
      modules = [
        inputs.home-manager.nixosModules.home-manager
        hostDir
      ];
    };
  in
  {
    nixosConfigurations = {
      vm-arm64 = mkHost {
        system = "aarch64-linux";
        hostDir = ./hosts/vm-arm;
      };
      mac-vm = mkHost {
        system = "aarch64-linux";
        hostDir = ./hosts/mac-vm;
      };
    };
  };
}
