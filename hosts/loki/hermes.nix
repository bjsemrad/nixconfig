# hermes.nix
# Hermes Agent (Nous Research), always-on assistant connected to Home Assistant.
#
# Uses the official NixOS module from the hermes-agent flake input (native
# systemd service, not container mode). It runs `hermes gateway` as the
# dedicated `hermes` system user with state in /var/lib/hermes
# (HERMES_HOME=/var/lib/hermes/.hermes).
#
# The browser dashboard runs alongside on port 9119, bound to all interfaces:
# http://10.0.10.7:9119 on the LAN, http://loki:9119 over Tailscale. A
# non-loopback bind engages Hermes' auth gate; login is the basic_auth plugin
# (user `admin`, password from sops).
#
# Secrets come from sops (secrets.yaml keys hermes_hass_token,
# hermes_dashboard_password, hermes_dashboard_session_secret), rendered into an
# env file that the module's activation script merges into $HERMES_HOME/.env,
# so they never land in the world-readable Nix store.
#
# Model provider: ChatGPT subscription via Codex OAuth. After the first deploy,
# log in once (device-code flow, works over SSH):
#
#   hermes-admin auth add openai-codex
#   sudo systemctl restart hermes-agent

{
  config,
  pkgs,
  ...
}:
let
  cfg = config.services.hermes-agent;

  # Run the hermes CLI against the service's state, as the service user.
  # Interactive shells otherwise get a separate ~/.hermes.
  hermes-admin = pkgs.writeShellScriptBin "hermes-admin" ''
    exec sudo -u ${cfg.user} env \
      HOME=${cfg.stateDir} \
      HERMES_HOME=${cfg.stateDir}/.hermes \
      HERMES_MANAGED=true \
      ${cfg.package}/bin/hermes "$@"
  '';
in
{
  # 1. Home Assistant long-lived access token for a dedicated non-admin HA user
  sops.secrets.hermes_hass_token = { };
  # Dashboard login password, and the key that signs its session cookies
  # (32+ random bytes, so sessions survive restarts)
  sops.secrets.hermes_dashboard_password = { };
  sops.secrets.hermes_dashboard_session_secret = { };

  sops.templates."hermes.env" = {
    # Rendered to /run/secrets/rendered/hermes.env, mode 0400 root:root. The
    # module's activation script (ordered after setupSecrets) copies it into
    # $HERMES_HOME/.env; hermes reads that file at startup.
    content = ''
      HASS_TOKEN=${config.sops.placeholder.hermes_hass_token}
      HERMES_DASHBOARD_BASIC_AUTH_PASSWORD=${config.sops.placeholder.hermes_dashboard_password}
      HERMES_DASHBOARD_BASIC_AUTH_SECRET=${config.sops.placeholder.hermes_dashboard_session_secret}
    '';
    # Future chat platforms. Add the sops keys first, then uncomment.
    #   MATRIX_HOMESERVER=https://matrix.example.org
    #   MATRIX_USER_ID=@hermes:example.org
    #   MATRIX_ACCESS_TOKEN=${config.sops.placeholder.hermes_matrix_access_token}
    #   MATRIX_ALLOWED_USERS=@you:example.org
    #   SIGNAL_HTTP_URL=http://127.0.0.1:8080
    #   SIGNAL_ACCOUNT=${config.sops.placeholder.hermes_signal_account}
    #   SIGNAL_ALLOWED_USERS=+1...
    restartUnits = [
      "hermes-agent.service"
      "hermes-backend.service"
    ];
  };

  # 2. Hermes gateway service
  services.hermes-agent = {
    enable = true;

    environment = {
      HASS_URL = "http://10.0.10.9:8123";
      HERMES_DASHBOARD_BASIC_AUTH_USERNAME = "admin";
    };
    environmentFiles = [ config.sops.templates."hermes.env".path ];

    # Browser admin panel (includes the `serve` API for Hermes Desktop).
    backend = {
      mode = "dashboard";
      host = "0.0.0.0";
      port = 9119;
    };

    # Rendered to $HERMES_HOME/config.yaml and deep-merged over what's on disk,
    # so runtime choices (e.g. the model picked during `auth add`) are kept.
    settings = {
      model.provider = "openai-codex";
      # TODO(verify): pin model.default once logged in (`hermes-admin model` lists
      # the ids available to the ChatGPT subscription).

      platforms.homeassistant = {
        enabled = true;
        extra = {
          # Explicit entity IDs only. Every matching state change costs a model
          # call, so no watch_all and no broad watch_domains.
          watch_entities = [ ];
          cooldown_seconds = 300;
        };
      };
    };
  };

  environment.systemPackages = [ hermes-admin ];

  # Dashboard on the LAN (tailscale0 is already trusted)
  networking.firewall.allowedTCPPorts = [ cfg.backend.port ];
}
