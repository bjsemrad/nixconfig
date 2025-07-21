{ config, pkgs, inputs, ... }:

{
  imports = [
    ./modules/alacritty
    ./modules/kitty
    ./modules/firefox
    ./modules/chromium
    ./modules/git
    ./modules/jujutsu
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
    ./modules/vial
    ./modules/wezterm
    inputs.nix-flatpak.homeManagerModules.nix-flatpak
    #inputs.walker.homeManagerModules.default
    ./modules/flatpak
  ];

  home = {
    username = "brian";
    homeDirectory = "/home/brian";
    packages = with pkgs;
      [
        bitwarden
        go
        rustup
        cargo-watch
        #Moving to flatpack
        #jetbrains.idea-ultimate
        #jetbrains.rust-rover
        #vscode
        zig
        nodejs_24
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

        #broken signal-desktop
        #Broken devenv
        slack
        lazygit
        btop
        fd
        brave
        gnome-disk-utility
        podman-tui
        #podman-desktop
        kubectl

        overskride
        cosign

        devpod
        devpod-desktop
      ] ++ [ inputs.nixpkgs-unstable.legacyPackages.${system}.temporal-cli ];

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
    stateVersion = "25.05"; # Please read the comment before changing.
  };

  # environment.
  programs.direnv = {
    enable = true;
    enableNushellIntegration = true;
    enableZshIntegration = true;
  };

  #CONFIRM  programs.home-manager.enable = true;

}
