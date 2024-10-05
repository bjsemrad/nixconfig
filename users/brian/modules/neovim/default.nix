{ pkgs, inputs, ... }:
{
  # nixpkgs.overlays = [ 
  #   inputs.neovim-flake.overlays.default
  # ];

  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    package = inputs.nixpkgs-unstable.legacyPackages.${pkgs.system}.neovim-unwrapped;
    #package = inputs.neovim-flake.packages.${pkgs.system}.neovim; 
  };

  home.file."setup-neovim.sh" = {
    source = ../../scripts/setup-neovim.sh;
    executable = true;
  };
}
