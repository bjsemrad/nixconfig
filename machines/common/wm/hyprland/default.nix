{ config, pkgs, ... }:
{
  programs.hyprland.enable = true;

  environment.systemPackages = with pkgs; [
    hyprpaper
    wl-clipboard
    brightnessctl
    wlogout
    #rofi-wayland
    pavucontrol
    pamixer
    fuzzel
    cliphist
    dunst
    swayidle
  ];
}