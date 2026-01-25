{
  pkgs,
  lib,
  inputs,
  ...
}:
{
  programs.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    withUWSM = false;
  };

  services.blueman.enable = true;
  programs.thunar.enable = true;

  services.gvfs = {
    enable = true;
    package = lib.mkForce pkgs.gnome.gvfs;
  };

  # services.displayManager = {
  # defaultSession = "hyprland";
  # };
  qt.style = "adwaita-dark";
  security.polkit.enable = true;
  security.pam.services.hyprlock = { };
  environment.systemPackages = with pkgs; [
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
    inputs.hyprpwcenter.packages.${pkgs.stdenv.hostPlatform.system}.hyprpwcenter
    inputs.hyprland-systeminfo.packages.${pkgs.stdenv.hostPlatform.system}.hyprsysteminfo
    # inputs.hyprlauncher.packages.${pkgs.stdenv.hostPlatform.system}.hyprlauncher
    gnome-firmware
  ];
}
