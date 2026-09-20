{ inputs, config, pkgs, ... }:
{
  networking.hostName = "semradpi";

  imports = with inputs.self.nixosModules; [
    ./hardware-configuration.nix
  ];

  networking.useDHCP = true;

  time.timeZone = "America/Chicago";

  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "yes";
      PasswordAuthentication = true;
    };
  };

  users.users.root.openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICBlihWxnAF0W+cuKqpQbN1yOY0bABNhQx7qb1sp83Z1 bjsemrad@gmail.com"
  ];

  environment.systemPackages = with pkgs; [ vim git htop ];
  
  # services.journald.storage = "volatile";
  # services.journald.extraConfig = ''
    # RuntimeMaxUse=64M
  # '';
  services.tailscale.enable = true;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };

  system.stateVersion = "26.05";
}
