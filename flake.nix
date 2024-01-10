{
  description = "NixOS Configuration";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";
    home-manager.url = "github:nix-community/home-manager/release-23.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };
  outputs = { self, nixpkgs, home-manager, ... }:
    let
      system = "x86_64-linux";
      lib = nixpkgs.lib;
      pkgs = import nixpkgs { system = "${system}"; config.allowUnfree = true; };
      #pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      nixosConfigurations = {
        thor = lib.nixosSystem {
          inherit system; # Framework
          modules = [ ./machines/thor/configuration.nix ];
        };
      };
      ##### TO SWAP TO NON STANDALONE
      ## Add the home-manager channel to the root user
      #Remove the home-manager channel from $user
      #Add home-manager to the imports in /etc/nixos/configuration.nix (See flake documentation_)
      #Move to module based configu.
      #sudo nixos-rebuild switch and hopefully everything works?
      homeConfigurations = {
        brian = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [ ./users/brian/home.nix ];
        };
      };
    };
}
