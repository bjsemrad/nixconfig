{ pkgs, inputs, ... }:
let
  neovim-unwrapped = inputs.nixpkgs-unstable.legacyPackages.${pkgs.stdenv.hostPlatform.system}.neovim-unwrapped.overrideAttrs (old: {
    meta = old.meta or { } // {
      maintainers = [ ];
    };
  });
in
{

  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    package = neovim-unwrapped;
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
