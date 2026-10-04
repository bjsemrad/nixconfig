{ config, ... }: {
  programs.atuin = {
    enable = true;
    settings = {
      # Self-hosted sync server on baldr, reached over Tailscale MagicDNS
      sync_address = "http://baldr.otter-rigel.ts.net:8888";
      auto_sync = true;
      sync_frequency = "5m";
    };
  };
}
