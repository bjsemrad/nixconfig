# pinchflat.nix
# Pinchflat (YouTube downloader), moved off TrueNAS where the app container kept
# crashing. Runs as the native NixOS service; downloads go straight to TrueNAS over
# NFS, while Pinchflat's own state (SQLite db, metadata, logs) stays local in
# /var/lib/pinchflat, since SQLite over NFS is unreliable.
#
# Web UI on the LAN (http://10.0.10.7:8945) and Tailscale (http://loki:8945).
#
# `selfhosted` uses Pinchflat's built-in weak SECRET_KEY_BASE (as its Docker image
# does). Fine while it is LAN/Tailscale only with no login; switch to a sops
# `secretsFile` before enabling basic auth or exposing it publicly.

{ ... }:
let
  truenas = "truenas";
  mediaDir = "/mnt/pinchflat/downloads";
in
{
  networking.hosts."10.0.10.8" = [ truenas ];

  boot.supportedFilesystems = [ "nfs" ];

  fileSystems.${mediaDir} = {
    device = "${truenas}:/mnt/tank/pinchflat/downloads";
    fsType = "nfs";
    options = [
      "nfsvers=4"
      "noauto"
      "x-systemd.automount"
    ];
  };

  # Fixed IDs so files on the share are owned consistently. 568 is the TrueNAS
  # `apps` user/group, which owned the downloads under the old app.
  users.users.pinchflat.uid = 568;
  users.groups.pinchflat.gid = 568;

  services.pinchflat = {
    enable = true;
    inherit mediaDir;
    port = 8945;
    openFirewall = true;
    selfhosted = true;
  };

  # Don't start (and download into an empty local directory) without the share.
  systemd.services.pinchflat.unitConfig.RequiresMountsFor = [ mediaDir ];
}
