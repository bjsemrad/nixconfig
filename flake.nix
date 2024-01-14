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

    alacritty-theme = {
      url = "github:alexghr/alacritty-theme.nix/2cd654fa494fc8ecb226ca1e7c5f91cf1cebbba9";
    }; #pre 0.13 alacritty
  };
  outputs =
    { self
    , nixpkgs
    , home-manager
    , nixos-hardware
    , alacritty-theme
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
      };
    };
}
