{ pkgs, inputs, ... }:
{
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    package = inputs.neovim-flake.packages.${pkgs.system}.neovim; 
  };

  home.file."setup-neovim.sh" = {
    source = ../../scripts/setup-neovim.sh;
    executable = true;
  };
}
