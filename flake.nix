{
  description = "NixOS Configuration";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";
    home-manager.url = "github:nix-community/home-manager/release-23.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    alacritty-theme.url = "github:alexghr/alacritty-theme.nix/2cd654fa494fc8ecb226ca1e7c5f91cf1cebbba9"; #pre 0.13 alacritty
  };
  outputs = { self, nixpkgs, home-manager, alacritty-theme, ... }:
    let
      system = "x86_64-linux";
      lib = nixpkgs.lib;
      pkgs = import nixpkgs { system = "${system}"; config.allowUnfree = true; };
    in
    {
      nixosConfigurations = {
        thor = lib.nixosSystem {
          inherit system; # Framework
          modules = [
            ./hosts/thor/configuration.nix
            ({ config, pkgs, ... }: {
              # install the overlay
              nixpkgs.overlays = [ alacritty-theme.overlays.default ];
            })
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.brian = import ./users/brian/home.nix;
            }
          ];
        };
      };

      #Moved to Home-manager module due to the NIX PKGS would not be in sync for the system utilities
     ##### TO SWAP TO NON STANDALONE
      ## Add the home-manager channel to the root user
      #Remove the home-manager channel from $user
      #Add home-manager to the imports in /etc/nixos/configuration.nix (See flake documentation_)
      #Move to module based configu.
      #sudo nixos-rebuild switch and hopefully everything works?
      # homeConfigurations = {
      #   brian = home-manager.lib.homeManagerConfiguration {
      #     inherit pkgs;
      #     modules = [
      #       ./users/brian/home.nix
      #       ({ config, pkgs, ... }: {
      #         # install the overlay
      #         nixpkgs.overlays = [ alacritty-theme.overlays.default ];
      #       })
      #     ];
      #   };
      # };
    };
}
