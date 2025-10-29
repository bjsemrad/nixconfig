{ pkgs, lib, inputs, ... }: {

  imports = [ inputs.mangowm.nixosModules.mango ];

  programs.mango.enable = true;

  programs.uwsm = {
    enable = true;
    waylandCompositors = {
      mango = {
        prettyName = "Mango";
        comment = "Mango compositor managed by UWSM";
        binPath = "/run/current-system/sw/bin/mango";
      };
    };
  };

  services.blueman.enable = true;
  programs.thunar.enable = true;

  security.polkit.enable = true;

  security.pam.services.hyprlock = { };
  environment.systemPackages = with pkgs; [
    wf-recorder
    wl-clipboard
    brightnessctl
    wlogout
    pavucontrol
    pamixer
    fuzzel
    cliphist
    xdg-desktop-portal-gtk
    grim
    slurp
    gojq
    adw-gtk3
    glib
    gnome-firmware
  ];
}
