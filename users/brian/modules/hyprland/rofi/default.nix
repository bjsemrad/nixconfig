{ pkgs, ... }: {
  programs.rofi = {
    enable = true;
    package = pkgs.rofi;
  };

  home.file = {
    ".config/rofi/scripts/clipboard.sh".source = ./scripts/clipboard.sh;
    ".config/rofi/scripts/launcher.sh".source = ./scripts/launcher.sh;
    ".config/rofi/scripts/window.sh".source = ./scripts/window.sh;
    ".config/rofi/scripts/networkmanager.sh".source =
      ./scripts/networkmanager.sh;
    ".config/rofi/style.rasi".source = ./style.rasi;
    ".config/rofi/nmstyle.rasi".source = ./nmstyle.rasi;
    ".config/rofi/themes/colors.rasi".source = ./themes/colors.rasi;
  };
}
