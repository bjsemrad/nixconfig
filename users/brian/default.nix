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
      ./modules/gradle
      ./modules/neovim
      ./modules/shell
      ./modules/starship
      ./modules/tmux
      ./modules/zellij
      ./modules/openrgb
      ./modules/atuin
      ./modules/kitty
      ./modules/yazi
      ./modules/helix
      ./modules/ghostty
      ./modules/zoxide
    ];

  home = {
    username = "brian";
    homeDirectory = "/home/brian";
    packages = with pkgs; [
      bitwarden
      go
      rustup
      cargo-watch
      jetbrains.idea-ultimate
      jetbrains.rust-rover
      vscode
      zig
      nodejs
      gcc
      clang-tools
      bear
      cmake
      lldb
      kotlin
      kora-icon-theme
      vial
      via
      qmk
      qmk-udev-rules
      fastfetch
      discord
      gnumake
      quickemu
      python3
      exercism
      vlc
      httpie
      fzf
      yubikey-manager
      yubikey-manager-qt
      backblaze-b2
      #Failed to download try again later mblock-mlink
      gimp
      nixd
      docker-compose
      pciutils
      slides
      file
      lm_sensors
      dig

      protonmail-desktop
      signal-desktop
      dotnet-sdk_8
      devenv
      slack
      lazygit
      btop
      protonvpn-gui
      fd
    ] ++ [  
            inputs.nixpkgs-unstable.legacyPackages.${system}.zed-editor
            inputs.nixpkgs-unstable.legacyPackages.${system}.temporal-cli
            inputs.nixpkgs-unstable.legacyPackages.${system}.cider
            inputs.nixpkgs-unstable.legacyPackages.${system}.mumble
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
    stateVersion = "24.11"; # Please read the comment before changing.
  };

  # environment.
  programs.direnv = {
    enable = true;
    enableNushellIntegration = true;  
    enableZshIntegration = true;
  };

  #CONFIRM  programs.home-manager.enable = true;


}
