{ config, pkgs, ... }:
{
  services.dunst = {
    enable = true;

  };

  home.file =  {
    ".config/dunst/dunstrc".source = ./dunstrc;
    ".config/assets/brightness.svg".source = ./assets/brightness.svg;
    ".config/assets/volume-mute.svg".source = ./assets/volume-mute.svg;
    ".config/assets/volume-mute.png".source = ./assets/volume-mute.png;
    ".config/assets/volume.svg".source = ./assets/volume.svg;
    ".config/assets/volume.png".source = ./assets/volume.png;
  };
}
