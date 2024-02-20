{ config, inputs, ...}:
let
  hyprlock = inputs.hyprlock;
in 
{
  imports = [
    hyprlock.homeManagerModules.default
  ];

  programs.hyprlock.enable = true;
}
