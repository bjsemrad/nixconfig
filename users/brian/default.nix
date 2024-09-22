{ config, pkgs, inputs, ... }:

{
  imports =
    [
      ./modules/alacritty
      ./modules/kitty
      ./modules/firefox
      ./modules/chromium
      ./modules/git
      ./modules/hyprland
      ./modules/java
      ./modules/neovim
      ./modules/shell
      ./modules/starship
      ./modules/tmux
      ./modules/zellij
      ./modules/openrgb
      ./modules/atuin
      ./modules/kitty
      ./modules/yazi
      ./modules/catppuccin
    ];

  home = {
    username = "brian";
    homeDirectory = "/home/brian";
    packages = with pkgs; [
      bitwarden
      go
      rustup
      jetbrains.idea-ultimate
      vscode
      zig
      nodejs
      gcc
      clang-tools
      cmake
      croc
      kora-icon-theme
      vial
      via
      qmk
      qmk-udev-rules
      #element-desktop
      fastfetch
      #thunderbird
      discord
      gnumake
      quickemu
      # quickgui doesn't work
      python3
      distrobox
      exercism
      vlc
      httpie
      fzf
      yubikey-manager
      yubikey-manager-qt
      #Failed to download try again later mblock-mlink
      gimp
      nixd
      cider
      podman-tui
      podman-compose
      docker-compose
      pciutils
      slides
      file
      lm_sensors
    ] ++ [  inputs.nixpkgs-unstable.legacyPackages.${system}.zed-editor];

    sessionVariables = {
      # EDITOR = "emacs";
    };
    # This value determines the Home Manager release that your configuration is
    # compatible with. This helps avoid breakage when a new Home Manager release
    # introduces backwards incompatible changes.
    #
    # You should not change this value, even if you update Home Manager. If you do
    # want to update the value, then make sure to first check the Home Manager
    # release notes.
    stateVersion = "24.05"; # Please read the comment before changing.
  };

  # environment.
  programs.direnv.enable = true;

  #CONFIRM  programs.home-manager.enable = true;


}
