{
  pkgs,
  lib,
  inputs,
  ...
}:
let
  system = pkgs.stdenv.hostPlatform.system;
in
{
  programs.hyprland = {
    enable = true;
    # Hyprland's flake builds against its own pinned nixos-unstable (newer wayland-protocols etc.),
    # but that nixpkgs ships glaze 8 while Hyprland requires glaze 7.x; on a mismatch CMake falls
    # back to a git FetchContent that fails in the sandbox. glaze is header-only, so swap in
    # stable's 7.x (with the same overrides Hyprland's own overlay applies).
    package = inputs.hyprland.packages.${system}.hyprland.override {
      glaze-hyprland = pkgs.glaze.override {
        enableSSL = false;
        enableInterop = false;
      };
    };
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
