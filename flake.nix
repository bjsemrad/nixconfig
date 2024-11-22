{
  description = "NixOS Configuration";
  inputs = {
    nixpkgs = {
      url = "github:NixOS/nixpkgs/nixos-24.11";
    };

    nixpkgs-unstable = {
      url = "github:NixOS/nixpkgs/nixos-unstable";
    };

    nixos-hardware = {
      url = "github:nixos/nixos-hardware";
    };

    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland = {
      type = "git"; 
      url = "https://github.com/hyprwm/Hyprland";
      submodules = true;
      ref = "refs/tags/v0.45.2";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
      inputs.hyprland.follows = "hyprland";
    };

    hyprland-systeminfo = {
      url = "github:hyprwm/hyprsysteminfo";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    
    hyprlock = {
      url = "github:hyprwm/hyprlock/v0.5.0";
    };

    hypridle = {
      url = "github:hyprwm/hypridle/v0.1.5";
    };

    alacritty-theme = {
      url = "github:alexghr/alacritty-theme.nix";#/2cd654fa494fc8ecb226ca1e7c5f91cf1cebbba9";
    }; 
    
    waybar = {
      type = "git";
      url = "https://github.com/Alexays/Waybar";
      ref = "refs/tags/0.11.0";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # neovim-flake = {
    #   url = "github:nix-community/neovim-nightly-overlay";
    #   inputs.nixpkgs.follows = "nixpkgs";
    #   inputs.neovim-src.url = "github:neovim/neovim/v0.10.2"; 
      # url = "github:neovim/neovim/v0.10.1?dir=contrib"; 
    # };

    # ags = {
    #   url = "github:Aylur/ags";#/v1.8.2";
    # };

    matugen = {
      url = "github:InioX/matugen?ref=v2.4.1";
    };

    # cosmic = {
    #   url = "github:lilyinstarlight/nixos-cosmic";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
    #
    # tailscale = {
      # url = "github:/tailscale/tailscale/v1.70.0";
      # inputs.nixpkgs.follows = "nixpkgs";
    # };

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
    , hyprland-systeminfo
    , waybar
    # , neovim-flake
    , matugen
    , nixpkgs-unstable
    # , cosmic
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
            # cosmic.nixosModules.default
            #nixos-hardware.nixosModules.common-gpu-intel
          ];
          specialArgs = { 
            inherit inputs; 
          };
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
