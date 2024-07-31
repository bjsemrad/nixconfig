{ config, pkgs, inputs, ... }:

{
  networking.hostName = "thor";

  imports = with inputs.self.nixosModules; [
    ./hardware-configuration.nix
    ./kernel.nix
    ./power-management.nix
    ./security.nix

    services-firmware
    desktop-gnome
    #desktop-plasma
    desktop-hyprland
    desktop-sway
    services-tailscale
    services-network
    services-sound
    services-displayserver
    services-printing

    common-nixsettings
    common-alacritty
    common-locale
    common-fonts
    common-opengl
    common-packages

    keyboard-qmk
    virt-podman
    programs-nix-ld
  ];

  # Bootloader.
  boot = {
    binfmt.emulatedSystems = [ "aarch64-linux" "armv7l-linux" "armv6l-linux" "riscv64-linux" ];
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
  };

  users.users.brian = {
    isNormalUser = true;
    description = "Brian Semrad";
    extraGroups = [ "networkmanager" "wheel" "dialout" "podman" "docker" ];
    shell = pkgs.zsh;
    packages = with pkgs; [ ];
  };

  # Broken, logs into hyprland then swaps to gnome with GDM.
  # services.xserver.displayManager.autoLogin.enable = true;
  # services.xserver.displayManager.autoLogin.user = "brian";
  services.logind.extraConfig = ''
    # don’t shutdown when power button is short-pressed
    HandlePowerKey=ignore
  '';


  users.users.root = {
    # disable root login here, and also when installing nix by running `nixos-install --no-root-passwd`
    # https://discourse.nixos.org/t/how-to-disable-root-user-account-in-configuration-nix/13235/3
    hashedPassword = "!"; # disable root logins, nothing hashes to !
  };

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "hmback";
    users = import "${inputs.self}/users";
    extraSpecialArgs = {
      inherit inputs;
    };
  };

  # Set your time zone.
  time.timeZone = "America/Chicago";
  environment.sessionVariables.NIXOS_OZONE_WL = "1";
  environment.systemPackages = with pkgs; [ ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?
}
