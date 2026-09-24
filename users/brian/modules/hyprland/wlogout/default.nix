{ pkgs, lib, ... }:
let
  # epochshell's matte-black theme (~/.config/epochshell/theme/themes/matte-black.toml), copied
  # by hand like hyprlock's: a theme switched in the shell does not reach here.
  theme = {
    background = "#121212";
    surfaceContainer = "#2a2a2a";
    surfaceText = "#bebebe";
    accent = "#61afef";
    fontFamily = "JetBrainsMono Nerd Font Propo";
  };

  # The icons ship in one colour for resting and another for focused (Catppuccin's text and base).
  # Recolour them to the theme at build time, keeping the shape and the alpha, so the originals
  # in ./images stay as they were.
  icons = [
    "lock"
    "logout"
    "power"
    "restart"
    "sleep"
  ];
  themedIcons =
    pkgs.runCommand "wlogout-icons" { nativeBuildInputs = [ pkgs.imagemagick ]; }
      ''
        mkdir -p $out
        for icon in ${lib.concatStringsSep " " icons}; do
          magick ${./images}/$icon.png -fill '${theme.surfaceText}' -colorize 100 $out/$icon.png
          magick ${./images}/$icon-hover.png -fill '${theme.background}' -colorize 100 $out/$icon-hover.png
        done
      '';
in
{
  programs.wlogout = {
    enable = true;
    layout = [
      {
        label = "lock";
        action = "hyprlock";
        text = "Lock";
        keybind = "l";
      }
      {
        label = "reboot";
        action = "systemctl reboot";
        text = "Reboot";
        keybind = "r";
      }
      {
        label = "shutdown";
        action = "systemctl poweroff";
        text = "Shutdown";
        keybind = "s";
      }
      {
        label = "logout";
        action = "~/.config/wmscripts/logout.sh";
        text = "Logout";
        keybind = "e";
      }
      {
        label = "suspend";
        action = "systemctl suspend";
        text = "Suspend";
        keybind = "u";
      }
    ];

    style = ''
        window {
          font-family: ${theme.fontFamily};
          font-size: 12pt;
          color: ${theme.surfaceText};
          background-color: alpha(${theme.background}, 0.85);
      }

      button {
          background-repeat: no-repeat;
          background-position: center;
          background-size: 20%;
          border: none;
          color: ${theme.surfaceText};
          text-shadow: none;
          background-color: transparent;
          margin: 5px;
          transition: box-shadow 0.2s ease-in-out, background-color 0.2s ease-in-out;
      }

      button:hover {
          background-color: alpha(${theme.surfaceContainer}, 0.7);
      }

      button:focus {
          background-color: ${theme.accent};
          color: ${theme.background};
          text-shadow: none;
      }

      #lock {
          background-image: image(url("./lock.png"));
      }
      #lock:focus {
          background-image: image(url("./lock-hover.png"));
      }

      #logout {
          background-image: image(url("./logout.png"));
      }
      #logout:focus {
          background-image: image(url("./logout-hover.png"));
      }

      #suspend {
          background-image: image(url("./sleep.png"));
      }
      #suspend:focus {
          background-image: image(url("./sleep-hover.png"));
      }

      #shutdown {
          background-image: image(url("./power.png"));
      }
      #shutdown:focus {
          background-image: image(url("./power-hover.png"));
      }

      #reboot {
          background-image: image(url("./restart.png"));
      }
      #reboot:focus {
          background-image: image(url("./restart-hover.png"));
      }
    '';
  };

  home.file = {
    ".config/wlogout/lock-hover.png".source = "${themedIcons}/lock-hover.png";
    ".config/wlogout/lock.png".source = "${themedIcons}/lock.png";
    ".config/wlogout/logout-hover.png".source = "${themedIcons}/logout-hover.png";
    ".config/wlogout/logout.png".source = "${themedIcons}/logout.png";
    ".config/wlogout/power-hover.png".source = "${themedIcons}/power-hover.png";
    ".config/wlogout/power.png".source = "${themedIcons}/power.png";
    ".config/wlogout/restart-hover.png".source = "${themedIcons}/restart-hover.png";
    ".config/wlogout/restart.png".source = "${themedIcons}/restart.png";
    ".config/wlogout/sleep-hover.png".source = "${themedIcons}/sleep-hover.png";
    ".config/wlogout/sleep.png".source = "${themedIcons}/sleep.png";
    ".config/wlogout/scripts/wlogout.sh".source = ./scripts/wlogout.sh;
  };
}
