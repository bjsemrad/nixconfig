{ pkgs, lib, ... }:
{
  # Enable the GNOME Desktop Environment.
  services.xserver.desktopManager.gnome.enable = true;
  services.xserver.displayManager.gdm.enable = true;
  services.gvfs = {
    enable = true;
    package = lib.mkForce pkgs.gnome.gvfs;
  };
  environment.gnome.excludePackages = with pkgs; [
    cheese
    gnome-photos
    gnome-music
    epiphany
    gnome-tour
    gnome-maps
    gnome-tweaks
    gnome-characters
  ];

  environment.systemPackages = with pkgs; [
    gnome-firmware
  ];
}
