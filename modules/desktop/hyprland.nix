{ pkgs, lib, inputs, ... }: {
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

  services.displayManager = { defaultSession = "hyprland-uwsm"; };

  security.polkit.enable = true;

  security.pam.services.hyprlock = { };
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
    networkmanagerapplet
    xdg-desktop-portal-gtk
    grim
    slurp
    gojq
    adw-gtk3
    glib
    inputs.hyprland-systeminfo.packages.${pkgs.system}.hyprsysteminfo
    gnome-firmware
  ];
}
