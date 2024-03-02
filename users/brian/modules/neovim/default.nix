{ config, pkgs, ... }:
{
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    #  extraConfig = ":luafile ~/.config/nvim/lua/init.lua";
  };

  home.file."setup-nvchad.sh" = {
    source = ../../scripts/setup-neovim.sh;
    executable = true;
  };


  # xdg.configFile."nvim".source = pkgs.stdenv.mkDerivation {
  #   name = "NvChad";
  #   src = pkgs.fetchFromGitHub {
  #     owner = "NvChad";
  #     repo = "NvChad";
  #     rev = "refs/heads/v2.0";
  #     sha256 = "sha256-tKMvKdB3jPSvcyewaOe8oak3pXhjAcLyyxgGMiMeqeU=";
  #   };
  #   installPhase = ''
  #     mkdir -p $out
  #     cp -r ./* $out/
  #     cd $out/
  #     cp -r ${./custom} $out/lua/custom
  #   '';
  # };

  # home.file.".config/nvim" = {
  #   source = builtins.fetchGit {
  #     url = "https://github.com/NvChad/NvChad.git";
  #     rev = "bb87d70fd6dedce65c67a4390c9faecc55b0ed72"; #v2.0 # Specify the commit or tag you want to use
  #   };
  # };

  # home.file."nvchad-custom" = {
  #   source = builtins.fetchGit {
  #     url = "https://github.com/bjsemrad/nvchad-custom.git";
  #     #rev = "v2.0"; # Specify the commit or tag you want to use
  #   };
  # };

  # xdg.configFile."nvim/" = {
  #   source = (pkgs.callPackage ../../../../packages/nvchad { });
  # };
  # xdg.configFile.nvim = {
  #   source = ./nvim_config;
  #   recursive = true;
  # };
}
