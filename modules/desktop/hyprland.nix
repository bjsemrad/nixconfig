{ pkgs, inputs, ... }:
{
  programs.hyprland = {
    enable = true;
   # package = inputs.hyprland.packages.${pkgs.system}.hyprland;
  };
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
    grim
    slurp
    gojq
    adw-gtk3
  ];
}
