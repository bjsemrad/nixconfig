{
  config,
  inputs,
  pkgs,
  ...
}:
let
  # epochshell's matte-black theme (~/.config/epochshell/theme/themes/matte-black.toml), copied
  # by hand: a theme switched in the shell does not reach here until this is edited to match.
  theme = {
    surface = "rgb(1e1e1e)";
    surfaceText = "rgb(bebebe)";
    outline = "rgb(8a8a8a)";
    accent = "rgb(61afef)";
    orange = "rgb(d19a66)";
    red = "rgb(e06c75)";
    # Not set by the theme, so this is the shell's default from theme/Config.qml.
    fontFamily = "JetBrainsMono Nerd Font Propo";
  };
in
{
  home.file = {
    ".config/hypr/nix-logo.png".source = ./nixos-logo.png;
    ".config/hypr/tux-small.png".source = ./tux-small.png;
  };
  programs.hyprlock = {
    enable = true;
    package = inputs.hyprlock.packages.${pkgs.stdenv.hostPlatform.system}.hyprlock;
    settings = {
      background = [
        {
          path = config.wallpaper.current;
        }
      ];
      # No immediate_render: hyprlock waits for the wallpaper before it shows, so a large image
      # makes the lock appear a little later rather than popping in over a blank screen.
      auth = {
        fingerprint = {
          enabled = true;
        };
      };
      label = [
        {
          text = "cmd[update:1000] echo \"$(${pkgs.coreutils}/bin/date +'%I:%M %P')\"";
          color = theme.surfaceText;
          font_size = 64;
          position = "40, 10";
          font_family = theme.fontFamily;
          halign = "left";
          valign = "bottom";
        }
        {
          text = "cmd[update:43200000] echo \"$(${pkgs.coreutils}/bin/date +'%A, %B %d')\"";
          color = theme.surfaceText;
          font_size = 24;
          position = "40, 150";
          font_family = theme.fontFamily;
          halign = "left";
          valign = "bottom";
        }
      ];
      input-field = [
        {
          size = "250,60";
          font_family = theme.fontFamily;
          outline_thickness = 2;
          dots_size = 0.2; # Scale of input-field height, 0.2 - 0.8
          dots_spacing = 0.2; # Scale of dots' absolute size, 0.0 - 1.0
          dots_center = true;
          outer_color = theme.accent;
          inner_color = theme.surface;
          font_color = theme.surfaceText;
          # The theme keeps amber for "something to notice" and red for a failure, so checking and
          # caps lock are amber and only a wrong password is red.
          check_color = theme.orange;
          capslock_color = theme.orange;
          fail_color = theme.red;
          fade_on_empty = false;
          placeholder_text = "<i><span foreground=\"##8a8a8a\">Input Password...</span></i>";
          hide_input = false;
          halign = "center";
          valign = "center";
        }
      ];
    };
  };
}
