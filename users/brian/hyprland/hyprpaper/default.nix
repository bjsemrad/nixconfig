{ config, pkgs, ... }:

{
  home.file = {
    ".config/hypr/hyprpaper.conf".source = ./hyprpaper.conf;
    ".config/hypr/forrest.png".source = ../../wallpaper/forrest.png;
    ".config/hypr/small-memory.jpg".source = ../../wallpaper/small-memory.jpg;
  };
}
