# paperclip.nix
# Paperclip (paperclipai/paperclip) agent task board / orchestrator. Scaffold
# only: disabled until Hermes and Claude Code are working. Enable with:
# {
#   services.paperclip.enable = true;
# }
#
# Runs as the `agent` user so it can spawn the claude/codex CLIs with the
# subscription logins in /home/agent. That also means it (and whatever it runs)
# has everything `agent` has; `agent` has no sudo and no docker.
#
# Not in nixpkgs, so the service runs the pinned npm release through npx
# (fetched on first start into agent's npm cache). The database is the NixOS
# postgres over the local socket instead of upstream's embedded-postgres, whose
# downloaded binaries won't run on NixOS.
#
# Runs in `authenticated` mode (real logins) so it can listen beyond loopback,
# on the LAN (http://10.0.10.7:3100), Tailscale (http://loki:3100) and behind
# nginx on baldr (paperclip.semrad.net; enable websockets there). The auth
# secret comes from sops (secrets.yaml key
# paperclip_better_auth_secret), rendered into an env file under
# /run/secrets/rendered. Create your account once, then set
# services.paperclip.disableSignUp = true.

{
  lib,
  config,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.services.paperclip;

  paperclipai = "${pkgs.nodejs_24}/bin/npx --yes paperclipai@${cfg.version}";

  # `run` refuses to start without a config when non-interactive. On first
  # start, `onboard --yes --bind lan` writes one from the environment below
  # (mode, host, port, DATABASE_URL, allowed hostnames) and then serves.
  paperclip-start = pkgs.writeShellScript "paperclip-start" ''
    if [ ! -f "$PAPERCLIP_HOME/instances/default/config.json" ]; then
      exec ${paperclipai} onboard --yes --bind lan --no-install-service
    fi
    exec ${paperclipai} run
  '';
in
{
  options.services.paperclip = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "If enabled, run the Paperclip agent orchestrator server";
    };
    version = mkOption {
      type = types.str;
      default = "2026.916.1";
      description = "paperclipai npm release to run";
    };
    user = mkOption {
      type = types.str;
      default = "agent";
      description = "User the server (and the agent CLIs it spawns) runs as";
    };
    dataDir = mkOption {
      type = types.str;
      default = "/var/lib/paperclip";
      description = "PAPERCLIP_HOME: config, file storage and run state";
    };
    port = mkOption {
      type = types.port;
      default = 3100;
      description = "Port for the web UI / API (all interfaces, opened in the firewall)";
    };
    allowedHostnames = mkOption {
      type = types.listOf types.str;
      default = [
        "10.0.10.7"
        "loki"
        "loki.otter-rigel.ts.net"
        "paperclip.semrad.net" # nginx proxy on baldr
      ];
      description = "Hostnames the UI may be reached by (Host header allowlist and trusted login origins), besides localhost";
    };
    trustProxy = mkOption {
      type = types.str;
      default = "10.0.10.6";
      description = "Reverse proxy addresses whose X-Forwarded-* headers are trusted (Express `trust proxy`; baldr's nginx)";
    };
    disableSignUp = mkOption {
      type = types.bool;
      default = false;
      description = "Turn off new account sign-up (set once your account exists)";
    };
  };

  config = mkIf cfg.enable {
    # 1. Persistent state directory
    systemd.tmpfiles.rules = [
      "d ${cfg.dataDir} 0750 ${cfg.user} users - -"
    ];

    # 2. Database: local socket, peer auth; the service user maps to role `paperclip`
    services.postgresql = {
      enable = true;
      ensureDatabases = [ "paperclip" ];
      ensureUsers = [
        {
          name = "paperclip";
          ensureDBOwnership = true;
        }
      ];
      identMap = ''
        paperclip ${cfg.user} paperclip
      '';
      authentication = ''
        local paperclip paperclip peer map=paperclip
      '';
    };

    # 3. Auth secret (decrypted at activation, never in /nix/store)
    sops.secrets.paperclip_better_auth_secret = { };

    sops.templates."paperclip.env" = {
      # Rendered to /run/secrets/rendered/paperclip.env, mode 0400 root:root;
      # systemd reads it as root before dropping to the service user.
      content = ''
        BETTER_AUTH_SECRET=${config.sops.placeholder.paperclip_better_auth_secret}
      '';
      restartUnits = [ "paperclip.service" ];
    };

    # 4. Server
    systemd.services.paperclip = {
      description = "Paperclip agent orchestrator";
      wantedBy = [ "multi-user.target" ];
      after = [
        "network-online.target"
        "postgresql.service"
      ];
      wants = [ "network-online.target" ];
      requires = [ "postgresql.service" ];

      environment = {
        # Agent's real HOME so the spawned CLIs find their OAuth logins.
        HOME = "/home/${cfg.user}";
        PAPERCLIP_HOME = cfg.dataDir;
        PAPERCLIP_DEPLOYMENT_MODE = "authenticated";
        PAPERCLIP_DEPLOYMENT_EXPOSURE = "private";
        HOST = "0.0.0.0";
        PORT = toString cfg.port;
        # No fixed public URL: the login base URL follows the request, so the
        # LAN and Tailscale names both work.
        PAPERCLIP_AUTH_BASE_URL_MODE = "auto";
        PAPERCLIP_ALLOWED_HOSTNAMES = concatStringsSep "," cfg.allowedHostnames;
        TRUST_PROXY = cfg.trustProxy;
        PAPERCLIP_AUTH_DISABLE_SIGN_UP = boolToString cfg.disableSignUp;
        # Unix socket + peer auth. postgres.js ignores ?host=, and a user with
        # an empty host fails URL parsing, so host and user come from PGHOST /
        # PGUSER (its fallbacks when the URL has neither).
        DATABASE_URL = "postgresql:///paperclip";
        PGHOST = "/run/postgresql";
        PGUSER = "paperclip";
      };

      # claude, codex, gh, etc. come from agent's home-manager profile.
      path = [
        pkgs.nodejs_24
        pkgs.git
        "/etc/profiles/per-user/${cfg.user}"
      ];

      serviceConfig = {
        User = cfg.user;
        Group = "users";
        WorkingDirectory = cfg.dataDir;
        EnvironmentFile = config.sops.templates."paperclip.env".path;
        ExecStart = paperclip-start;
        Restart = "on-failure";
        RestartSec = "10s";
      };
    };

    # 5. Web UI / API on the LAN (tailscale0 is already trusted)
    networking.firewall.allowedTCPPorts = [ cfg.port ];
  };
}
