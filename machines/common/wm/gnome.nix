{ config, pkgs, ... }:
{
  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
  environment.gnome.excludePackages = with pkgs; [
    gnome.cheese
    gnome-photos
    gnome.gnome-music
    epiphany
    gnome-tour
    gnome.gnome-maps
  ];

  environment.systemPackages = with pkgs; [
        gnome-firmware
  ];
}
