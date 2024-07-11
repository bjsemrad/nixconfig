{ config, inputs, pkgs, ... }:
{
  programs.hyprlock = {
    enable = true;
    package = inputs.hyprlock.packages.${pkgs.system}.hyprlock;
    settings = {
      background = [{
        path = "/home/brian/.config/hypr/fantasy-world.png";
        blur_passes = 1;
        contrast = 0.8916;
        brightness = 0.8172;
        vibrancy = 0.1696;
        vibrancy_darkness = 0.0;
      }];
      general = {
        no_fade_in = false;
        grace = 0;
        disable_loading_bar = true;
      };
      label = [{
        text = ""; #"cmd[update:1000] echo \"<b><big> $(${pkgs.coreutils}/bin/date +\"%r\") </big></b>\"";
        color = "rgb(200, 200, 200)";
        font_size = 64;
        position = {
          x = 0;
          y = 16;
        };
        halign = "center";
        valign = "center";
      }];
      input-field = [{
        size = {
          width = 250;
          height = 60;
        };
        outline_thickness = 2;
        dots_size = 0.2; # Scale of input-field height, 0.2 - 0.8
        dots_spacing = 0.2; # Scale of dots' absolute size, 0.0 - 1.0
        dots_center = true;
        outer_color = "rgba(0, 0, 0, 0)";
        inner_color = "rgba(0, 0, 0, 0.5)";
        font_color = "rgb(200, 200, 200)";
        fade_on_empty = false;
        placeholder_text = "<i><span foreground=\"##cdd6f4\">Input Password...</span></i>";
        hide_input = false;
        position = {
          x = 0;
          y = -120;
        };
        halign = "center";
        valign = "center";
      }];
    };
  };
}
