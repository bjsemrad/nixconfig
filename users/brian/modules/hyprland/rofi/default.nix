{
  programs.rofi = {
    enable = true;
  };

  home.file = {
    ".config/rofi/scripts/clipboard.sh".source = ./scripts/clipboard.sh;
    ".config/rofi/scripts/launcher.sh".source = ./scripts/launcher.sh;
    ".config/rofi/scripts/window.sh".source = ./scripts/window.sh;
  };
}
