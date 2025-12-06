{
  pkgs,
  lib,
  inputs,
  ...
}:
{
  programs.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.system}.hyprland;
    #portalPackage = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
    withUWSM = true;
  };
  services.blueman.enable = true;
  programs.thunar.enable = true;

  services.gvfs = {
    enable = true;
    package = lib.mkForce pkgs.gnome.gvfs;
  };

  services.displayManager = {
    defaultSession = "hyprland-uwsm";
  };
  qt.style = "adwaita-dark";
  security.polkit.enable = true;
  security.pam.services.hyprlock = { };
  environment.systemPackages = with pkgs; [
    hyprpaper
    hyprpicker
    wf-recorder
    wl-clipboard
    brightnessctl
    wlogout
    pavucontrol
    pamixer
    fuzzel
    cliphist
    networkmanagerapplet
    xdg-desktop-portal-gtk
    grim
    slurp
    gojq
    adw-gtk3
    glib
    kdePackages.qt6ct
    # hyprsysteminfo
    inputs.hyprpwcenter.packages.${stdenv.hostPlatform.system}.hyprpwcenter
    inputs.hyprland-systeminfo.packages.${stdenv.hostPlatform.system}.hyprsysteminfo
    inputs.hyprlauncher.packages.${pkgs.system}.hyprlauncher
    gnome-firmware
  ];
}
