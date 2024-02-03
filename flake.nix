{
  description = "NixOS Configuration";
  inputs = {
    nixpkgs = {
      url = "github:NixOS/nixpkgs/nixos-23.11";
    };

    nixos-hardware = {
      url = "github:nixos/nixos-hardware";
    };

    home-manager = {
      url = "github:nix-community/home-manager/release-23.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland = {
      url = "github:hyprwm/Hyprland/v0.34.0";
    };

    alacritty-theme = {
      url = "github:alexghr/alacritty-theme.nix/2cd654fa494fc8ecb226ca1e7c5f91cf1cebbba9";
    }; #pre 0.13 alacritty

    nix-colors.url = "github:misterio77/nix-colors";
  };
  outputs =
    { self
    , nixpkgs
    , home-manager
    , nixos-hardware
    , alacritty-theme
    ,hyprland
    ,nix-colors
    , ...
    } @ inputs:
    let
      system = "x86_64-linux";
      lib = nixpkgs.lib;
      pkgs = import nixpkgs { system = "${system}"; config.allowUnfree = true; };
    in
    {
      nixosModules = import ./modules { lib = nixpkgs.lib; };
      nixosConfigurations = {
        thor = lib.nixosSystem {
          inherit system; # Framework
          modules = [
            ./hosts/thor/configuration.nix
            home-manager.nixosModules.home-manager
            nixos-hardware.nixosModules.framework-12th-gen-intel
            nixos-hardware.nixosModules.common-gpu-intel
          ];
          specialArgs = { inherit inputs; };
        };
        odin = lib.nixosSystem {
          inherit system; #Desktop
          modules = [
            ./hosts/odin/configuration.nix
            home-manager.nixosModules.home-manager
            nixos-hardware.nixosModules.common-cpu-amd
            nixos-hardware.nixosModules.common-hidpi
            nixos-hardware.nixosModules.common-pc-ssd
          ];
          specialArgs = { inherit inputs; };
        };
        heimdall = lib.nixosSystem {
          inherit system; #Dashboard Server 
          modules = [
            ./hosts/heimdall/configuration.nix
            home-manager.nixosModules.home-manager
          ];
          specialArgs = { inherit inputs; };
        };
        loki = lib.nixosSystem {
          inherit system; #Croc/Wormhole Server 
          modules = [
            ./hosts/loki/configuration.nix
            home-manager.nixosModules.home-manager
          ];
          specialArgs = { inherit inputs; };
        };
      };
    };
}
