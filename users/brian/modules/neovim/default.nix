{ config, pkgs, inputs, ... }:
{
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    package = inputs.neovim-flake.packages.${pkgs.system}.neovim; 
  };

  home.file."setup-nvchad.sh" = {
    source = ../../scripts/setup-neovim.sh;
    executable = true;
  };
}
