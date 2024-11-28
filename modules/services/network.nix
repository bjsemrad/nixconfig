{
  # Open ports in the firewall.
  networking.firewall = {
    # enable the firewall
    enable = true;
  };

  # Enable networking
  networking.networkmanager.enable = true;
  services.avahi.enable = true;
  services.avahi.nssmdns4 = true;
  services.avahi.openFirewall = true;

  services.resolved.enable = true;

}

