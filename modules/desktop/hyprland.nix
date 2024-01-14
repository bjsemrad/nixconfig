{ config, pkgs, ... }:
{
  programs.hyprland.enable = true;
  services.blueman.enable = true;

  services.xserver.displayManager.defaultSession = "hyprland";
  security.pam.services.swaylock = { };
  environment.systemPackages = with pkgs; [
    hyprpaper
    wl-clipboard
    brightnessctl
    wlogout    
    pavucontrol
    pamixer
    fuzzel
    cliphist
    swayidle
    networkmanagerapplet
    xfce.thunar
    xdg-desktop-portal-gtk
  ];
}
