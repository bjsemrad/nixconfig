# /etc/nixos/homepage.nix
# Import this file into your flake, then configure in your configuration.nix:
# {
#   services.homepage.enable = true;
# }

{
  lib,
  config,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.services.homepage;
in
{
  options.services.homepage = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "If enabled, run the containerized Homepage dashboard linked to TrueNAS NFS";
    };
    version = mkOption {
      type = types.str;
      default = "latest";
      description = "Homepage container image tag";
    };
    trueNasIp = mkOption {
      type = types.str;
      default = "10.0.10.8";
      description = "The IP address of your TrueNAS SSD storage server";
    };
    trueNasPath = mkOption {
      type = types.str;
      default = "/mnt/ssd/dashboard";
      description = "The primary NFS export path on TrueNAS holding your configuration files";
    };
  };

  config = mkIf cfg.enable {
    # 1. System-wide Prerequisites for Network Shares
    environment.systemPackages = with pkgs; [ nfs-utils ];

    # 2. Main Storage Mounts (Following your strict automount pattern)
    fileSystems = {
      "/mnt/dashboard" = {
        device = "${cfg.trueNasIp}:${cfg.trueNasPath}";
        fsType = "nfs";
        options = [
          "nfsvers=4"
          "noauto"
          "x-systemd.automount"
          "nofail"
          "rw"
        ];
      };
    };

    # 3. Homepage Container Engine Definition
    virtualisation.oci-containers.containers.homepage = {
      image = "ghcr.io/gethomepage/homepage:${cfg.version}";
      autoStart = true;

      environment = {
        TZ = "America/Chicago";
        HOMEPAGE_ALLOWED_HOSTS = "*";
      };

      volumes = [
        "/mnt/dashboard:/app/config"
        "/var/run/docker.sock:/var/run/docker.sock:ro"
      ];

      ports = [
        "3000:3000"
      ];

      extraOptions = [
        "--pull=always"
        "--stop-timeout=60"
        "--user=0:0" # Operating as root matches your active system account profile
      ];
    };

    # 4. Force systemd to wait for physical storage before launching container
    systemd.services.docker-homepage = {
      wants = [ "mnt-dashboard.mount" ];
      after = [ "mnt-dashboard.mount" ];
      requires = [ "mnt-dashboard.mount" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        Restart = "on-failure";
        RestartSec = "10s";
      };
    };

    # 5. Global Core Container Backend Configurations
    virtualisation.docker.enable = true;
    virtualisation.oci-containers.backend = "docker";

    # 6. Core Network Firewall Pass Rules
    networking.firewall = {
      allowedTCPPorts = [
        3000 # Homepage unified web portal interface dashboard
      ];
    };
  };
}
