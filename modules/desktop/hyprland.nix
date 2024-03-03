{ pkgs, inputs, ... }:
{
  programs.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.system}.hyprland;
  };
  services.blueman.enable = true;

  programs.thunar.enable = true;

  services.xserver.displayManager.defaultSession = "hyprland";
  security.pam.services.swaylock = { };
  security.pam.services.hyprlock = {};
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
    xdg-desktop-portal-gtk
    grim
    slurp
    gojq
    adw-gtk3
  ];
}
