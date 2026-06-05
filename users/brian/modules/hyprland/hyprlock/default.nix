{
  config,
  inputs,
  pkgs,
  ...
}:
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
          path = "/home/brian/.config/hypr/retropc.jpg";
        }
      ];
      general = {
        immediate_render = true;
      };
      auth = {
        fingerprint = {
          enabled = true;
        };
      };
      label = [
        {
          text = "cmd[update:1000] echo \"$(${pkgs.coreutils}/bin/date +'%I:%M %P')\"";
          color = "rgba(171, 178, 191, 1)";
          font_size = 64;
          position = "40, 10";
          font_family = "JetBrainsMono Nerd Font";
          halign = "left";
          valign = "bottom";
        }
        {
          text = "cmd[update:43200000] echo \"$(${pkgs.coreutils}/bin/date +'%A, %B %d')\"";
          color = "rgba(171, 178, 191, 1)";
          font_size = 24;
          position = "40, 150";
          font_family = "JetBrainsMono Nerd Font";
          halign = "left";
          valign = "bottom";
        }
      ];
      input-field = [
        {
          size = "250,60";
          font_family = "JetBrainsMono Nerd Font";
          outline_thickness = 2;
          dots_size = 0.2; # Scale of input-field height, 0.2 - 0.8
          dots_spacing = 0.2; # Scale of dots' absolute size, 0.0 - 1.0
          dots_center = true;
          check_color = "rgba(204,144,87, 1.0)";
          outer_color = "rgba(191,104,217, 1.0)"; # purple
          inner_color = "rgba(30,33,39, 1.0)"; # bgDark
          font_color = "rgba(171,178,191, 1.0)"; # fg_dark
          fail_color = "rgba(229,85,97, 1.0)"; # red
          fade_on_empty = false;
          placeholder_text = "<i><span foreground=\"##abb2bf\">Input Password...</span></i>";
          hide_input = false;
          halign = "center";
          valign = "center";
        }
      ];
    };
  };
}
