{ config, inputs, ...}:
let
  hyprlock = inputs.hyprlock;
in 
{
  imports = [
    hyprlock.homeManagerModules.default
  ];

  programs.hyprlock = {
    enable = true;
    backgrounds = [{
      path = "/home/brian/.config/hypr/nix-purple.png";
    }];
    input_field = {
      placeholder_text = "Password....";
      size = {
          width = 200;
          height = 50;
      };
      outline_thickness = 3;
      halign = "center";
      valign = "bottom";
    };
  };
}
