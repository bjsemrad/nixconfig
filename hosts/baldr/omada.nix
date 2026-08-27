# omada-controller.nix
# Import this file into your flake, then in your config:
#{
#  services.omada-controller.enable = true;
#  services.omada-controller.version = "6.2";
#}

{
  lib,
  config,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.services.omada-controller;
in
{
  options.services.omada-controller = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "If enabled, run the Omada software controller";
    };
    version = mkOption {
      type = types.str;
      default = "6.2";
      description = "Omada controller image tag";
    };
  };

  config = mkIf cfg.enable {
    virtualisation.oci-containers.containers.omada-controller = {
      image = "mbentley/omada-controller:${cfg.version}";
      autoStart = true;
      environment = {
        TZ = "Etc/UTC";
      };
      volumes = [
        "omada_data:/opt/tplink/EAPController/data"
        "omada_logs:/opt/tplink/EAPController/logs"
      ];
      extraOptions = [
        "--network=host"
        "--ulimit"
        "nofile=4096:8192"
        "--pull=always"
        "--stop-timeout=60"
      ];
    };

    virtualisation.docker.enable = true;
    virtualisation.oci-containers.backend = "docker";

    networking.firewall = {
      allowedTCPPorts = [
        8088
        8043
        8843
        29811
        29812
        29813
        29814
        29815
        29816
        29817
      ];
      allowedUDPPorts = [
        29810
        27001
      ];
    };
  };
}
