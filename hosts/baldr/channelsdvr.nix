# channels-dvr.nix
# Import this file into your flake, then configure in your configuration.nix:
# {
#   services.channels-dvr.enable = true;
# }

{
  lib,
  config,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.services.channels-dvr;
in
{
  options.services.channels-dvr = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "If enabled, run the containerized Channels DVR server linked to local USB and TrueNAS imports";
    };
    version = mkOption {
      type = types.str;
      default = "latest";
      description = "Channels DVR container image tag (e.g., 'latest' or 'tve')";
    };
    trueNasIp = mkOption {
      type = types.str;
      default = "10.0.10.8";
      description = "The IP address of your TrueNAS storage server";
    };
  };

  config = mkIf cfg.enable {
    # 1. System Prerequisites
    environment.systemPackages = with pkgs; [
      nfs-utils
      exfat # Core parsing engine for your USB storage filesystem
    ];

    # 2. Main Storage Mounts (Replaces old /etc/fstab configuration)
    fileSystems = {
      # Local 1TB USB Drive for active DVR workings and database backups
      "/mnt/dvr" = {
        device = "/dev/disk/by-uuid/DF77-7273";
        fsType = "exfat";
        options = [
          "defaults"
          "rw"
          "user"
          "umask=000"
          "exec"
          "nofail"
          "nonempty"
        ];
      };

      # Legacy Imports: TrueNAS Movies Pool
      "/shares/nasmovies" = {
        device = "${cfg.trueNasIp}:/mnt/tank/movies";
        fsType = "nfs";
        options = [
          "nfsvers=4"
          "noauto"
          "x-systemd.automount"
          "nofail"
        ];
      };

      # Legacy Imports: TrueNAS TV Shows Pool
      "/shares/tvnas" = {
        device = "${cfg.trueNasIp}:/mnt/tank/tvshows";
        fsType = "nfs";
        options = [
          "nfsvers=4"
          "noauto"
          "x-systemd.automount"
          "nofail"
        ];
      };

      # Legacy Imports: TrueNAS Downloads Pool (Pinchflat)
      "/shares/pinchflat/downloads" = {
        device = "${cfg.trueNasIp}:/mnt/tank/pinchflat/downloads";
        fsType = "nfs";
        options = [
          "nfsvers=4"
          "noauto"
          "x-systemd.automount"
          "nofail"
        ];
      };
    };

    # 3. Channels DVR Container Engine Definition
    virtualisation.oci-containers.containers.channels-dvr = {
      image = "fancybits/channels-dvr:${cfg.version}";
      autoStart = true;

      environment = {
        TZ = "America/Chicago"; # Configured for your local time zone scheduling accuracy
        LIBVA_DRIVER_NAME = "iHD";
      };
      devices = [
        "/dev/dri/card0:/dev/dri/card0"
        "/dev/dri/renderD128:/dev/dri/renderD128"
      ];

      # Maps your local 1TB drive as the active sandbox and nests network shares inside it
      volumes = [
        "/mnt/dvr/ChannelsDVR/Database:/channels-dvr/data" # Active database engine workspace mapping
        "/mnt/dvr/ChannelsDVR:/shares/DVR" # Primary recordings sandbox (Local 1TB)
        "/shares/nasmovies:/shares/Movies" # Nested network pool link
        "/shares/tvnas:/shares/TV" # Nested network pool link
        "/shares/pinchflat/downloads:/shares/YouTube" # Nested network pool link
      ];

      extraOptions = [
        "--network=host" # Crucial for Bonjour automatic Apple TV client discovery
        "--pull=always" # Pull updates automatically on container restarts
        "--stop-timeout=60" # Gracefully park application database logs before stopping
        # Passes the graphics hardware planes directly past container layers
      ];
    };

    systemd.services.docker-channels-dvr = {
      # Binds the container life cycle strictly to the physical hardware drive
      wants = [ "mnt-dvr.mount" ];
      after = [ "mnt-dvr.mount" ];
      requires = [ "mnt-dvr.mount" ]; # Prevents it from running if the mount ever drops

      # Forces systemd to automatically trigger this service during a standard system boot
      wantedBy = [ "multi-user.target" ];

      # AUTOMATIC RETRY LOGIC: If the USB drive is slow to wake up, retry every 10 seconds
      serviceConfig = {
        Restart = "on-failure";
        RestartSec = "10s";
      };
    };

    # 4. Global Core Container Backend Configurations
    virtualisation.docker.enable = true;
    virtualisation.oci-containers.backend = "docker";

    # 5. Host Intel N100 iGPU Video Drivers
    hardware.graphics = {
      enable = true;
      extraPackages = with pkgs; [
        intel-media-driver # Native hardware decoding for Intel N100 Quick Sync
        intel-vaapi-driver
      ];
    };

    # 6. Core Network Firewall Pass Rules
    networking.firewall = {
      allowedTCPPorts = [ 8089 ]; # Core Server Web Admin dashboard portal
      allowedUDPPorts = [ 5353 ]; # Bonjour Discovery protocol for local streaming appliances
    };
  };
}
