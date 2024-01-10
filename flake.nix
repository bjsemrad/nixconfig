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
      homeConfigurations = {
        brian = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [ ./users/brian/home.nix ];
        };
      };
    };
}
