{ config, pkgs, inputs, ... }:

{
  networking.hostName = "odin";

  imports = with inputs.self.nixosModules; [
    ./hardware-configuration.nix
    ./kernel.nix
    ./ups.nix

    services-firmware
    desktop-gnome
    desktop-hyprland
    services-tailscale
    services-network
    services-sound
    services-displayserver
    services-printing
    services-openrgb

    common-nixsettings
    common-alacritty
    common-locale
    common-fonts
    common-opengl
    common-packages

    programs-steam

    keyboard-qmk
    virt-podman
    programs-nix-ld
    services-atuin
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  users.users.brian = {
    isNormalUser = true;
    description = "Brian Semrad";
    extraGroups = [ "networkmanager" "wheel" "storage" "dialout" ];
    shell = pkgs.zsh;
    packages = with pkgs; [ ];
  };

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users = import "${inputs.self}/users";
    extraSpecialArgs = {
      inherit inputs;
    };
  };


  # Set your time zone.
  time.timeZone = "America/Chicago";

  environment.systemPackages = with pkgs; [
    nut
  ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?
}
