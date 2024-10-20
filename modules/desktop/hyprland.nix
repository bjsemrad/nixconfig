{ pkgs, inputs, ... }:
{
  programs.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.system}.hyprland;
  };
  services.blueman.enable = true;

  programs.thunar.enable = true;

  services.displayManager = {
    defaultSession = "hyprland";
  };

  security.pam.services.swaylock = { };
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
    rose-pine-gtk-theme
  ];
}
