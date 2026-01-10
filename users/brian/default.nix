{
  config,
  pkgs,
  inputs,
  ...
}:

{
  imports = [
    ./modules/alacritty
    ./modules/kitty
    ./modules/firefox
    ./modules/chromium
    ./modules/git
    #./modules/jujutsu
    ./modules/hyprland
    ./modules/niri
    #./modules/mango
    ./modules/java
    ./modules/gradle
    ./modules/neovim
    ./modules/shell
    ./modules/starship
    ./modules/tmux
    #./modules/zellij
    ./modules/openrgb
    ./modules/atuin
    ./modules/kitty
    ./modules/yazi
    ./modules/helix
    ./modules/ghostty
    ./modules/zoxide
    ./modules/vial
    ./modules/tailscale
    inputs.nix-flatpak.homeManagerModules.nix-flatpak
    inputs.walker.homeManagerModules.walker
    ./modules/flatpak
    ./modules/webapps
    ./modules/wmscripts
    ./modules/epochshell
  ];

  home = {
    username = "brian";
    homeDirectory = "/home/brian";
    sessionVariables = {
      NIXOS_OZONE_WL = "1";
      OZONE_PLATFORM = "wayland";
      XDG_SESSION_TYPE = "wayland";
    };

    packages =
      with pkgs;
      [
        bitwarden-desktop
        rustup
        cargo-watch
        ffmpeg-full
        libheif
        pinta
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
        lazygit
        btop
        fd
        gnome-disk-utility
        podman-tui
        kubectl
        cosign
        devpod
        devpod-desktop
        jq
        protonvpn-gui
        loupe

        element-desktop
        kdePackages.kdialog
        kdePackages.qt5compat
        kdePackages.qtbase
        kdePackages.qtdeclarative
        kdePackages.qtimageformats
        kdePackages.qtmultimedia
        kdePackages.qtpositioning
        kdePackages.qtquicktimeline
        kdePackages.qtsensors
        kdePackages.qtsvg
        kdePackages.qttools
        kdePackages.qttranslations
        kdePackages.qtvirtualkeyboard
        kdePackages.qtwayland
        kdePackages.syntax-highlighting

        wakeonlan
        trayscale
      ]
      ++ [
        inputs.nixpkgs-unstable.legacyPackages.${pkgs.stdenv.hostPlatform.system}.temporal-cli
        inputs.nixpkgs-unstable.legacyPackages.${pkgs.stdenv.hostPlatform.system}.go
        inputs.quickshell.packages.${pkgs.stdenv.hostPlatform.system}.quickshell
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
    stateVersion = "25.11"; # Please read the comment before changing.
  };

  # environment.
  programs.direnv = {
    enable = true;
    enableNushellIntegration = true;
    enableZshIntegration = true;
  };

  #CONFIRM  programs.home-manager.enable = true;

}
