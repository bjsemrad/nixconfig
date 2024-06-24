{
  description = "NixOS Configuration";
  inputs = {
    nixpkgs = {
      url = "github:NixOS/nixpkgs/nixos-24.05";
    };

    nixos-hardware = {
      url = "github:nixos/nixos-hardware";
    };

    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland = {
      type = "git"; 
      url = "https://github.com/hyprwm/Hyprland?ref=v0.41.1";
      submodules = true;
    };

    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
      inputs.hyprland.follows = "hyprland";
    };
    
    /*Drop these and potentlly hyprland when we move to 24.05*/
    hyprlock = {
      url = "github:hyprwm/hyprlock/v0.3.0";
    };

    hypridle = {
      url = "github:hyprwm/hypridle/v0.1.2";
    };

    alacritty-theme = {
      url = "github:alexghr/alacritty-theme.nix";#/2cd654fa494fc8ecb226ca1e7c5f91cf1cebbba9";
    }; 
    
    waybar = {
      url = "github:Alexays/Waybar";
    };

    neovim-flake = { 
      url = "github:neovim/neovim/v0.10.0?dir=contrib"; 
    };

    ags = {
      url = "github:Aylur/ags/v1.8.2";
    };

    matugen = {
      url = "github:InioX/matugen?ref=v2.2.0";
    };

  };
  outputs =
    { self
    , nixpkgs
    , home-manager
    , nixos-hardware
    , alacritty-theme
    , hyprland
    , hypridle
    , hyprlock
    , waybar
    , neovim-flake
    , ags
    , matugen
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
            #nixos-hardware.nixosModules.common-gpu-intel
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
