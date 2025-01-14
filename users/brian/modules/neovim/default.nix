{ pkgs, inputs, ... }:
{

  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    package = inputs.nixpkgs-unstable.legacyPackages.${pkgs.system}.neovim-unwrapped;
  };

  home.packages = with pkgs; [
    luajitPackages.luarocks_bootstrap
    wget
    lua
  ];

  home.file."setup-neovim.sh" = {
    source = ../../scripts/setup-neovim.sh;
    executable = true;
  };
}
