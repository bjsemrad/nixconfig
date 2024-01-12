{ config, pkgs, ... }:
{
  programs.hyprland.enable = true;
  programs.waybar.enable = true;

  services.cliphist.enable = true;
  services.dunst.enable = true;
  services.swayidle.enable = true;

  environment.systemPackages = with pkgs; [
    hyprpaper
    wl-clipboard
    brightnessctl
    wlogout
    #rofi-wayland
    pavucontrol
    pamixer
    fuzzel
  ];
}