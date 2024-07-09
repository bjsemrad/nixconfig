{ pkgs, ... }:
{
  # Enable the KDE Desktop Environment.
  #services.xserver.displayManager.sddm.enable = true;
  services.xserver.desktopManager.plasma6.enable = true;
  # or this for seahorse
  programs.ssh.askPassword = "${pkgs.gnome.seahorse}/libexec/seahorse/ssh-askpass";
  # Use this for the kssshaskpass
  #programs.ssh.askPassword =  "${pkgs.plasma5Packages.ksshaskpass}/bin/ksshaskpass";

  # services.xserver.displayManager.defaultSession = "plasmawayland";
  environment.plasma6.excludePackages = with pkgs.kdePackages; [
    oxygen
  ];

  #GTK themes are not applied in Wayland applications / Window Decorations missing / Cursor looks different
  programs.dconf.enable = true;

  qt = {
    enable = true;
    platformTheme = "gnome";
    style = "adwaita-dark";
  };

  # environment.systemPackages = with pkgs; [
  #   libsForQt5.qt5ct
  # ];

}
