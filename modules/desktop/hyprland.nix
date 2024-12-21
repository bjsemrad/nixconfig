{ pkgs, lib, inputs, ... }:
{
  programs.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.system}.hyprland;
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

  # programs.uwsm = {
  #   enable = true;
  #   waylandCompositors.hyprland = {
  #       binPath = "/run/current-system/sw/bin/Hyprland";
  #       comment = "Hyprland session managed bt uwsm";
  #       prettyName = "Hyprland";
  #   };
  # };

  security.pam.services.hyprlock = {};
  environment.systemPackages = with pkgs; [
    hyprpaper
    wf-recorder
    wl-clipboard
    brightnessctl
    wlogout
    pavucontrol
    pamixer
    fuzzel
    cliphist
    swayidle
    networkmanagerapplet
    xdg-desktop-portal-gtk
    grim
    slurp
    gojq
    adw-gtk3
    glib
    hyprpolkitagent
    inputs.hyprland-systeminfo.packages.${pkgs.system}.hyprsysteminfo
    gnome-firmware

  ];
}
