# Import this file, from wherever you saved it, into your flake.
# Somewhere in your config...
#{
#  services.portainer-ce.enable = true;
#  services.portainer-ce.version = "latest";
#}

{ lib, config, pkgs, ... }:
with lib;
let
  cfg = config.services.portainer-ce;
in
{
  options.services.portainer-ce = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = ''
        If enabled, run portainer
      '';
    };
    version = mkOption {
      type = types.str;
      default = "latest";
      description = ''
        Sets the Portainer-ce container version. Defaults to latest.
      '';
    };
  };

  config = {
    virtualisation.oci-containers.containers.portainer-ce = mkIf cfg.enable {
      image = "portainer/portainer-ce:${cfg.version}";
      volumes = [
        "portainer_data:/data"
        "/var/run/docker.sock:/var/run/docker.sock"
        "/etc/localtime:/etc/localtime" # So logging matches local time.
      ];
      # Since this is a service you need to access, you must also open the ports on the container itself.
      ports = [
        "8000:8000"
        "9443:9443"
      ];
      autoStart = true;
      extraOptions = [
        "--pull=always"
        "--restart=unless-stopped"
        "--rm=false"
      ];
    };
    virtualisation.docker.enable = true;
    virtualisation.oci-containers.backend = "docker";
    networking.firewall.allowedTCPPorts = [ 9443 8000 ];
  };
}

