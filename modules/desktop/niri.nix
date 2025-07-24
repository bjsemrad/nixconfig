{ pkgs, lib, inputs, ... }: {
  programs.niri = {
    enable = true;
    #package = inputs.niri.packages.${pkgs.system}.niri;
  };

  programs.uwsm = {
    enable = true;
    waylandCompositors = {
      niri = {
        prettyName = "Niri";
        comment = "Niri compositor managed by UWSM";
        binPath = "/run/current-system/sw/bin/niri";
      };
    };
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
    fuzzel
    cliphist
    #networkmanagerapplet
    networkmanager_dmenu
    xdg-desktop-portal-gtk
    grim
    slurp
    gojq
    adw-gtk3
    glib
    gnome-firmware
  ];
}
