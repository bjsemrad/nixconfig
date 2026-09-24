# loki: Intel N100 (Alder Lake-N) mini PC, 16GB RAM. Headless, always-on agent box.
#
# The N100 is slow to compile, so build on thor and push the closure with the
# `rebuild-loki` shell alias (users/brian/modules/shell):
#
#   nixos-rebuild switch -s --flake .#loki --target-host root@10.0.10.7 --verbose
#
# sops secrets are decrypted on loki at activation, so loki needs its own copy
# of /var/lib/sops-nix/key.txt (same as baldr).

{
  config,
  pkgs,
  inputs,
  ...
}:

{
  imports = with inputs.self.nixosModules; [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    common-nixsettings
    services-network
    services-smartd
    services-firmware
    ./hermes.nix
    ./paperclip.nix
  ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Use latest kernel.
  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.hostName = "loki"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/Chicago";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users."admin" = {
    isNormalUser = true;
    description = "admin";
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
    packages = with pkgs; [ ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINxG6NiEQZOEJiqpEDXg/eERqe71XNqnNLlI7VaOGqch bjsemrad@gmail.com"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICBlihWxnAF0W+cuKqpQbN1yOY0bABNhQx7qb1sp83Z1 bjsemrad@gmail.com"
    ];
  };

  # Unprivileged account the AI agents run as. Deliberately not in wheel or
  # docker (docker group membership is effectively root).
  users.users.agent = {
    isNormalUser = true;
    description = "agent";
    extraGroups = [ ];
    # Keep user services (tmux servers, agent daemons) running without a login.
    linger = true;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINxG6NiEQZOEJiqpEDXg/eERqe71XNqnNLlI7VaOGqch bjsemrad@gmail.com"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICBlihWxnAF0W+cuKqpQbN1yOY0bABNhQx7qb1sp83Z1 bjsemrad@gmail.com"
    ];
  };

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "hmbackup";
    users.agent = import "${inputs.self}/users/agent";
    extraSpecialArgs = { inherit inputs; };
  };

  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINxG6NiEQZOEJiqpEDXg/eERqe71XNqnNLlI7VaOGqch bjsemrad@gmail.com"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICBlihWxnAF0W+cuKqpQbN1yOY0bABNhQx7qb1sp83Z1 bjsemrad@gmail.com"
  ];

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    zsh
    git
    gh
    tmux
    htop
    jq
    ripgrep
    fd
    curl
    dnsutils
    iperf3
    nmap
  ];

  # mtr needs raw sockets; this installs it with a cap_net_raw wrapper.
  programs.mtr.enable = true;

  # Microcode for the N100. hardware-configuration.nix ties updateMicrocode to
  # enableRedistributableFirmware, which services-firmware turns on; set it
  # explicitly so it doesn't depend on that.
  hardware.cpu.intel.updateMicrocode = true;

  nix.settings.trusted-users = [
    "root"
    "admin"
  ];

  # Agent task board.
  services.paperclip.enable = true;

  sops.defaultSopsFile = ../../secrets.yaml;
  sops.age.keyFile = "/var/lib/sops-nix/key.txt";

  # Enable the OpenSSH daemon. Key-only; root may log in with its keys but never a password.
  services.openssh = {
    settings = {
      PermitRootLogin = "prohibit-password";
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
    };
    enable = true;
  };

  services.tailscale = {
    enable = true;
    package = inputs.tailscale.packages.${pkgs.stdenv.hostPlatform.system}.tailscale;
    extraUpFlags = [
    ];
    useRoutingFeatures = "server";
  };

  networking.firewall = {
    # enable the firewall
    enable = true;

    # always allow traffic from your Tailscale network
    trustedInterfaces = [ "tailscale0" ];

    # SSH (services.openssh) and Paperclip (paperclip.nix) open their own ports.

    # allow the Tailscale UDP port through the firewall
    allowedUDPPorts = [ config.services.tailscale.port ];
  };

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "26.05"; # Did you read the comment?

}
