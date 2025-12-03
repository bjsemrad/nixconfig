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
    package = inputs.hyprlock.packages.${pkgs.system}.hyprlock;
    settings = {
      background = [
        {
          path = "/home/brian/.config/hypr/retropc.jpg";
          #color = "rgba(30,33,39, 1.0)"; #bgDark
          #blur_passes = 1;
          #contrast = 0.8916;
          #brightness = 0.8172;
          #vibrancy = 0.1696;
          #vibrancy_darkness = 0.0;
        }
      ];
      general = {
        # no_fade_in = false;
        # grace = 0;
        immediate_render = true;
        # disable_loading_bar = true;
        # enable_fingerprint = true;
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
      # image = [{
      #   path = "/home/brian/.config/hypr/tux-small.png";
      #   size = 50;
      #   border_color = "rgba(30,33,39, 1.0)";
      #   position = "0, 150";
      #   halign = "center";
      #   valign = "center";
      # }];
      input-field = [
        {
          size = "250,60";
          font_family = "JetBrainsMono Nerd Font";
          outline_thickness = 2;
          dots_size = 0.2; # Scale of input-field height, 0.2 - 0.8
          dots_spacing = 0.2; # Scale of dots' absolute size, 0.0 - 1.0
          dots_center = true;
          #          "$black" = "0xff0e1013";
          #        "$bgDark" = "0xff1E2127";
          # "$bg0" = "0xff1f2329";
          # "$bg1" = "0xff282c34";
          # "$bg2" = "0xff30363f";
          # "$bg3" = "0xff323641";
          # "$bg_d" = "0xff181b20";
          # "$bg_blue" = "0xff61afef";
          # "$bg_yellow" = "0xffe8c88c";
          # "$fg" = "0xffa0a8b7";
          #        "$fg_dark" = "0xffabb2bf";
          # "$purple" = "0xffbf68d9";
          # "$green" = "0xff8ebd6b";
          # "$orange" = "0xffcc9057";
          # "$blue" = "0xff4fa6ed";
          # "$yellow" = "0xffe2b86b";
          # "$cyan" = "0xff48b0bd";
          # "$red" = "0xffe55561";
          # "$grey" = "0xff535965";

          check_color = "rgba(204,144,87, 1.0)";
          outer_color = "rgba(191,104,217, 1.0)"; # purple
          inner_color = "rgba(30,33,39, 1.0)"; # bgDark
          font_color = "rgba(171,178,191, 1.0)"; # fg_dark
          fail_color = "rgba(229,85,97, 1.0)"; # red
          fade_on_empty = false;
          placeholder_text = "<i><span foreground=\"##abb2bf\">Input Password...</span></i>";
          hide_input = false;
          # position = "0, -120";
          halign = "center";
          valign = "center";
        }
      ];
    };
  };
}
