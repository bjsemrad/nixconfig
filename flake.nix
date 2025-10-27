{
  description = "NixOS Configuration";
  inputs = {
    nixpkgs = { url = "github:NixOS/nixpkgs/nixos-25.05"; };

    nixpkgs-unstable = { url = "github:NixOS/nixpkgs/nixos-unstable"; };

    nixos-hardware = { url = "github:nixos/nixos-hardware"; };

    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland = {
      type = "git";
      url = "https://github.com/hyprwm/Hyprland";
      submodules = true;
      ref = "refs/tags/v0.51.1";
    };

    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins/v0.51.0";
      inputs.hyprland.follows = "hyprland";
    };

    hyprland-systeminfo = { url = "github:hyprwm/hyprsysteminfo/v0.1.3"; };

    hyprlock = { url = "github:hyprwm/hyprlock/v0.9.2"; };

    hypridle = { url = "github:hyprwm/hypridle/v0.1.7"; };

    hyprlauncher = { url = "github:hyprwm/hyprlauncher"; };

    #hyprpwcenter = { url = "github:hyprwm/hyprpwcenter"; };

    alacritty-theme = {
      url =
        "github:alexghr/alacritty-theme.nix"; # /2cd654fa494fc8ecb226ca1e7c5f91cf1cebbba9";
    };

    waybar = {
      type = "git";
      url = "https://github.com/Alexays/Waybar";
      ref = "refs/tags/0.14.0";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    niri = {
      type = "git";
      url = "https://github.com/YaLTeR/niri";
      ref = "refs/tags/v25.08";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    quickshell = {
      type = "git";
      url = "https://github.com/quickshell-mirror/quickshell";
      ref = "refs/tags/v0.2.0";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    tailscale = {
      type = "git";
      url = "https://github.com/tailscale/tailscale";
      ref = "refs/tags/v1.86.2";
    };

    elephant = {
      type = "git";
      url = "https://github.com/abenz1267/elephant";
      ref = "refs/tags/v2.1.0";
    };

    walker = {
      type = "git";
      url = "https://github.com/abenz1267/walker";
      ref = "refs/tags/v2.2.0";
      inputs.elephant.follows = "elephant";
      #      inputs.nixpkgs.follows = "nixpkgs";
    };

    ghostty = {
      type = "git";
      url = "https://github.com/ghostty-org/ghostty";
      ref = "refs/tags/v1.2.2";
    };

    matugen = { url = "github:InioX/matugen?ref=v2.4.1"; };
    nix-flatpak = { url = "github:gmodena/nix-flatpak/?ref=latest"; };

  };
  outputs = { self, nixpkgs, home-manager, nixos-hardware, alacritty-theme
    , hyprland, hypridle, hyprlock, hyprland-systeminfo, hyprlauncher, waybar
    , niri, matugen, nixpkgs-unstable, nix-flatpak, quickshell, tailscale
    , elephant, walker, ghostty, ... }@inputs:
    let
      system = "x86_64-linux";
      lib = nixpkgs.lib;
      pkgs = import nixpkgs {
        system = "${system}";
        config.allowUnfree = true;
      };
    in {
      nixosModules = import ./modules { lib = nixpkgs.lib; };
      nixosConfigurations = {
        thor = lib.nixosSystem {
          inherit system; # Framework
          modules = [
            ./hosts/thor/configuration.nix
            home-manager.nixosModules.home-manager
            nixos-hardware.nixosModules.framework-12th-gen-intel
          ];
          specialArgs = { inherit inputs; };
        };
        odin = lib.nixosSystem {
          inherit system; # Desktop
          modules = [
            ./hosts/odin/configuration.nix
            home-manager.nixosModules.home-manager
            nixos-hardware.nixosModules.common-cpu-amd
            nixos-hardware.nixosModules.common-hidpi
            nixos-hardware.nixosModules.common-pc-ssd
          ];
          specialArgs = { inherit inputs; };
        };
        tyr = lib.nixosSystem {
          inherit system; # Dashboard Server
          modules = [
            ./hosts/tyr/configuration.nix
            home-manager.nixosModules.home-manager
          ];
          specialArgs = { inherit inputs; };
        };
        yggdrasil = lib.nixosSystem {
          inherit system; # Nginx Proxy for internal
          modules = [
            ./hosts/yggdrasil/configuration.nix
            home-manager.nixosModules.home-manager
          ];
          specialArgs = { inherit inputs; };
        };

      };
    };
}
