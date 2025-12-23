{ config, pkgs, inputs, ... }: {

  services.tailscale = {
    enable = true;
    package = inputs.tailscale.packages.${pkgs.stdenv.hostPlatform.system}.tailscale;
  };

  networking.firewall = {
    # enable the firewall
    enable = true;

    # always allow traffic from your Tailscale network
    trustedInterfaces = [ "tailscale0" ];

    # allow the Tailscale UDP port through the firewall
    allowedUDPPorts = [ config.services.tailscale.port ];
  };

}

