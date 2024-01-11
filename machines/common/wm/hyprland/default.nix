{ config, pkgs, ... }:
{
  programs.hyprland.enable = true;
  programs.waybar.enable = true;

    environment.systemPackages = with pkgs; [
            hyprpaper
            swayidle
            dunst
            wl-clipboard
            brightnessctl
            rofi-wayland
            wlogout
  ];
}
