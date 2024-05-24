{ config, pkgs, inputs, ... }:

{
  imports =
    [
      ./modules/alacritty
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
      quickgui
      python3
      distrobox
      exercism
      vlc
      httpie
      fzf
      yubikey-manager
      #Failed to download try again later mblock-mlink
      gimp
      nixd
    ];

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
    stateVersion = "23.11"; # Please read the comment before changing.
  };

  # environment.
  programs.direnv.enable = true;

  #CONFIRM  programs.home-manager.enable = true;


}
