{ pkgs, ... }:
{
  # Enable the KDE Desktop Environment.
  services.xserver.displayManager.sddm.enable = false;
  services.xserver.desktopManager.plasma5.enable = false;
 # services.xserver.displayManager.defaultSession = "plasmawayland";
  environment.plasma5.excludePackages = with pkgs.libsForQt5; [
    oxygen
  ];

  #GTK themes are not applied in Wayland applications / Window Decorations missing / Cursor looks different
  programs.dconf.enable = true;

  qt = {
    enable = true;
    platformTheme = "gnome";
    style = "adwaita-dark";
  };

  environment.systemPackages = with pkgs; [
    libsForQt5.qt5ct
  ];

}
