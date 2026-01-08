{
  pkgs,
  lib,
  inputs,
  ...
}:
{
  programs.niri = {
    enable = true;
    package = inputs.niri.packages.${pkgs.system}.niri;
  };

  services.blueman.enable = true;
  programs.thunar.enable = true;

  # services.gvfs = {
  #   enable = true;
  #   package = lib.mkForce pkgs.gnome.gvfs;
  # };

  #  services.displayManager = { defaultSession = "niri"; };

  security.polkit.enable = true;

  security.pam.services.hyprlock = { };
  environment.systemPackages = with pkgs; [
    wf-recorder
    wl-clipboard
    brightnessctl
    wlogout
    pavucontrol
    pamixer
    cliphist
    xdg-desktop-portal-gtk
    grim
    slurp
    gojq
    adw-gtk3
    glib
    gnome-firmware
    xwayland-satellite
  ];
}
