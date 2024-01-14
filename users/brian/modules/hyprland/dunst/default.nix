{
  services.dunst = {
    enable = true;
    configFile = ./dunstrc;

  };

  home.file =  {
    ".config/dunst/assets/brightness.svg".source = ./assets/brightness.svg;
    ".config/dunst/assets/volume-mute.png".source = ./assets/volume-mute.png;
    ".config/dunst/assets/volume.png".source = ./assets/volume.png;
  };
}
