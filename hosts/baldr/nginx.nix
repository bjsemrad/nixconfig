# nginx-proxy-manager.nix
# Import this file into your flake, then in your config:
#{
#  services.nginx-proxy-manager.enable = true;
#  services.nginx-proxy-manager.version = "2.15.1";
#}

{
  lib,
  config,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.services.nginx-proxy-manager;
in
{
  options.services.nginx-proxy-manager = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "If enabled, run NGINX Proxy Manager";
    };
    version = mkOption {
      type = types.str;
      default = "2.15.1";
      description = "NPM image tag";
    };
  };

  config = mkIf cfg.enable {
    virtualisation.oci-containers.containers.nginx-proxy-manager = {
      image = "jc21/nginx-proxy-manager:${cfg.version}";
      autoStart = true;
      environment = {
        TZ = "Etc/UTC";
      };
      volumes = [
        "/var/lib/npm/data:/data"
        "/var/lib/npm/letsencrypt:/etc/letsencrypt"
      ];
      ports = [
        "80:80"
        "443:443"
        "81:81"
      ];
      extraOptions = [
        "--pull=always"
        "--stop-timeout=60"
      ];
    };

    virtualisation.docker.enable = true;
    virtualisation.oci-containers.backend = "docker";

    networking.firewall.allowedTCPPorts = [
      80
      443
      81
    ];
  };
}
