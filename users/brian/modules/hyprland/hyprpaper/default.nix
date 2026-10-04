{
  config,
  inputs,
  pkgs,
  ...
}:
{
  services.hyprpaper = {
    enable = true;
    package = inputs.hyprpaper.packages.${pkgs.stdenv.hostPlatform.system}.hyprpaper;
    settings = {
      ipc = "on";
      splash = false;

      # preload = [
      #   "/home/brian/.config/wallpaper/leaves.png"
      #   "/home/brian/.config/wallpaper/retropc.jpg"
      #   "/home/brian/.config/wallpaper/sunset.jpg"
      #   "/home/brian/.config/wallpaper/shaded_landscape.png"
      #   "/home/brian/.config/wallpaper/water-drop.jpg"
      # ];
      wallpaper = [
        {
          monitor = "";
          path = config.wallpaper.current;
          # fit_mode = "fill";
        }
      ];
    };
  };
  home.file = {
    #".config/hypr/hyprpaper.conf".source = ./hyprpaper.conf;
    ".config/wallpaper/forrest.png".source = ../../../wallpaper/forrest.png;
    ".config/wallpaper/small-memory.jpg".source = ../../../wallpaper/small-memory.jpg;
    ".config/wallpaper/nix-purple.png".source = ../../../wallpaper/nix-purple.png;
    ".config/wallpaper/fetchnix.png".source = ../../../wallpaper/fetchnix.png;
    ".config/wallpaper/blue_purple_waves.jpg".source = ../../../wallpaper/blue_purple_waves.jpg;
    ".config/wallpaper/abstractglass.png".source = ../../../wallpaper/abstractglass.png;
    ".config/wallpaper/colorful-abstract.jpg".source = ../../../wallpaper/colorful-abstract.jpg;
    ".config/wallpaper/exploding.jpg".source = ../../../wallpaper/exploding.jpg;
    ".config/wallpaper/vibrant-colors.jpg".source = ../../../wallpaper/vibrant-colors.jpg;
    ".config/wallpaper/multicolored.jpg".source = ../../../wallpaper/multicolored.jpg;
    ".config/wallpaper/flowing-mountain.jpg".source = ../../../wallpaper/flowing-mountain.jpg;
    ".config/wallpaper/water-drop.jpg".source = ../../../wallpaper/water-drop.jpg;
    ".config/wallpaper/abstract-wavy-background.jpg".source =
      ../../../wallpaper/abstract-wavy-background.jpg;
    ".config/wallpaper/colorful-painting.jpg".source = ../../../wallpaper/colorful-painting.jpg;
    ".config/wallpaper/view-clear-water-motion.jpg".source = ../../../wallpaper/view-clear-water-motion.jpg;
    ".config/wallpaper/computer-chip-cpu.png".source = ../../../wallpaper/computer-chip-cpu.png;
    ".config/wallpaper/matrix.png".source = ../../../wallpaper/matrix.png;
    ".config/wallpaper/leaves.png".source = ../../../wallpaper/leaves.png;
    ".config/wallpaper/flower.png".source = ../../../wallpaper/flower.png;
    ".config/wallpaper/shaded_landscape.png".source = ../../../wallpaper/shaded_landscape.png;
    ".config/wallpaper/forest-mist.png".source = ../../../wallpaper/forest-mist.png;
    ".config/wallpaper/island-night-moon.png".source = ../../../wallpaper/island-night-moon.png;
    ".config/wallpaper/blue_night_moon_over_lake.png".source =
      ../../../wallpaper/blue_night_moon_over_lake.png;
    ".config/wallpaper/forest-landscape.png".source = ../../../wallpaper/forest-landscape.png;
    ".config/wallpaper/mountain-lake.png".source = ../../../wallpaper/mountain-lake.png;
    ".config/wallpaper/wallhaven3.png".source = ../../../wallpaper/wallhaven3.png;
    ".config/wallpaper/fantasy-world.png".source = ../../../wallpaper/fantasy_world.png;
    ".config/wallpaper/cosmic-light.jpg".source = ../../../wallpaper/cosmic-light.jpg;
    ".config/wallpaper/minimalpattern.png".source = ../../../wallpaper/minimalpattern.png;
    ".config/wallpaper/funicons.jpg".source = ../../../wallpaper/funicons.jpg;
    ".config/wallpaper/binary.jpg".source = ../../../wallpaper/binary.jpg;
    ".config/wallpaper/programmer.jpg".source = ../../../wallpaper/programmer.jpg;
    ".config/wallpaper/mountain.jpg".source = ../../../wallpaper/mountain.jpg;
    ".config/wallpaper/bluewaves.png".source = ../../../wallpaper/bluewaves.png;
    ".config/wallpaper/bluewave.png".source = ../../../wallpaper/bluewave.png;
    ".config/wallpaper/retropc.jpg".source = ../../../wallpaper/retropc.jpg;
    ".config/wallpaper/sunset.jpg".source = ../../../wallpaper/sunset.jpg;
  };
}
