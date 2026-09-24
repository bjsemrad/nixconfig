# mlbserver.nix
# Import this file into your flake, then configure in your configuration.nix:
# {
#   services.mlbserver.enable = true;
# }
#
# Credentials come from sops (secrets.yaml keys mlbserver_account_username /
# mlbserver_account_password) and are rendered into an env file under
# /run/secrets/rendered, so they never land in the world-readable Nix store.

{
  lib,
  config,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.services.mlbserver;
in
{
  options.services.mlbserver = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "If enabled, run the containerized mlbserver MLB.tv streaming proxy";
    };
    version = mkOption {
      type = types.str;
      default = "latest";
      description = "mlbserver container image tag";
    };
    dataDir = mkOption {
      type = types.str;
      default = "/var/lib/mlbserver";
      description = "Host directory holding the mlbserver data directory (cache, sessions, multiview state)";
    };
    port = mkOption {
      type = types.port;
      default = 8070;
      description = "Host port published for the mlbserver web interface (the container listens on 9999)";
    };
    favTeams = mkOption {
      type = types.str;
      default = "MIL";
      description = "Comma-separated list of favorite team abbreviations";
    };
    timeZone = mkOption {
      type = types.str;
      default = "America/Chicago";
      description = "Time zone used inside the container for game scheduling accuracy";
    };
  };

  config = mkIf cfg.enable {
    # 1. Persistent state directory backing the container volume
    systemd.tmpfiles.rules = [
      "d ${cfg.dataDir} 0755 root root - -"
    ];

    # 2. MLB.tv Account Credentials (decrypted at activation, never in /nix/store)
    sops.secrets.mlbserver_account_username = { };
    sops.secrets.mlbserver_account_password = { };

    sops.templates."mlbserver.env" = {
      # Rendered to /run/secrets/rendered/mlbserver.env, mode 0400 root:root.
      # Plain key=value only: docker --env-file does no quoting or expansion.
      content = ''
        account_username=${config.sops.placeholder.mlbserver_account_username}
        account_password=${config.sops.placeholder.mlbserver_account_password}
      '';
      # Pick up rotated credentials on the next rebuild without a manual restart
      restartUnits = [ "docker-mlbserver.service" ];
    };

    # 3. mlbserver Container Engine Definition
    virtualisation.oci-containers.containers.mlbserver = {
      image = "tonywagner/mlbserver:${cfg.version}";
      autoStart = true;

      environment = {
        TZ = cfg.timeZone;
        fav_teams = cfg.favTeams;
        # Remaining knobs from the original compose file, uncomment as needed:
        # http_root = "/mlbserver";
        # debug = "false";
        # multiview_path = "";
        # ffmpeg_path = "";
        # ffmpeg_encoder = "";
        # page_username = "";
        # page_password = "";
        # content_protect = "";
        # login_page = "false";
        # gamechanger_delay = "0";
        # PUID = "1000";
        # PGID = "1000";
      };

      environmentFiles = [ config.sops.templates."mlbserver.env".path ];

      volumes = [
        "${cfg.dataDir}:/mlbserver/data_directory"
      ];

      ports = [
        "${toString cfg.port}:9999"
      ];

      extraOptions = [
        "--pull=always" # Pull updates automatically on container restarts
        "--stop-timeout=60" # Let in-flight stream sessions close cleanly
      ];
    };

    # 4. Bind the container life cycle to its decrypted credentials
    systemd.services.docker-mlbserver = {
      wantedBy = [ "multi-user.target" ];

      # AUTOMATIC RETRY LOGIC: MLB.tv login can fail transiently, retry every 10 seconds
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
        cfg.port # mlbserver web interface and stream playlist endpoints
      ];
    };
  };
}
