{ config, pkgs, lib, ... }:

{

  programs.alacritty.enable = true;
  programs.alacritty.settings = {
    window.opacity = lib.mkForce 0.95;
    font.size = 14.0;
  };
#   home.file = {
#     ".config/alacritty/.alacritty.toml".source = ./alacritty.toml;
#   };
}
