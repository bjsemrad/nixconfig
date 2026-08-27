# nfs.nix
{ config, lib, ... }:
let
  cfg = config.services.nfs-client;
in
{
  options.services.nfs-client = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
    };
    truenas = lib.mkOption {
      type = lib.types.str;
      default = "truenas";
    };
  };

  config = lib.mkIf cfg.enable {
    networking.hosts = {
      "10.0.10.8" = [ cfg.truenas ];
    };

    fileSystems."/var/lib/npm/data" = {
      device = "${cfg.truenas}:/mnt/ssd/proxy/npm/data";
      fsType = "nfs";
      options = [
        "nfsvers=4"
        "noauto"
        "x-systemd.automount"
      ];
    };

    fileSystems."/var/lib/npm/letsencrypt" = {
      device = "${cfg.truenas}:/mnt/ssd/proxy/npm/letsencrypt";
      fsType = "nfs";
      options = [
        "nfsvers=4"
        "noauto"
        "x-systemd.automount"
      ];
    };
  };
}
