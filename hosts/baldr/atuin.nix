# atuin.nix
# Import this file into your flake, then configure in your configuration.nix:
# {
#   services.atuin-server.enable = true;
# }
#
# Self-hosted atuin sync server, backed by a local PostgreSQL database that the
# upstream NixOS module creates and manages.

{
  lib,
  config,
  ...
}:
with lib;
let
  cfg = config.services.atuin-server;
in
{
  options.services.atuin-server = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "If enabled, run the atuin shell history sync server";
    };
    host = mkOption {
      type = types.str;
      default = "0.0.0.0";
      description = "Address to listen on (use 127.0.0.1 if a reverse proxy sits in front)";
    };
    port = mkOption {
      type = types.port;
      default = 8888;
      description = "Port the atuin sync server listens on";
    };
    openRegistration = mkOption {
      type = types.bool;
      default = true;
      description = "Allow new users to register; flip to false once your account exists";
    };
  };

  config = mkIf cfg.enable {
    # 1. atuin Sync Server (upstream module, PostgreSQL created locally)
    services.atuin = {
      enable = true;
      inherit (cfg) host port openRegistration;
      database.createLocally = true;
    };

    # 2. Core Network Firewall Pass Rules
    networking.firewall = {
      allowedTCPPorts = [
        cfg.port # atuin sync API
      ];
    };
  };
}
