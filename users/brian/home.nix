{ config, pkgs, ... }:
let
  username = "brian";
  homeDirectory = "/home/brian";
  nixconfigdir = "${homeDirectory}/nixconfig";
in
{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = username;
  home.homeDirectory = homeDirectory;

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.11"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  programs.firefox.enable = true;
  programs.neovim.enable = true;
  programs.starship.enable = true;
  programs.git.enable = true;
  programs.direnv.enable = true;
  programs.java = {
    enable = true;
    package = pkgs.jdk21;
  };

  home.packages = with pkgs; [
    alacritty
    bitwarden
    go
    rustup
    jetbrains.idea-ultimate
    vscode
    #doesn't work for launching not within toolbox jetbrains-toolbox
    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })
  ];

  programs.zsh = {
    enable = true;
    shellAliases = {
      homeupdate = "home-manager switch --flake ${nixconfigdir}";
      nixupdate = "cd ${nixconfigdir} && nix flake update && sudo nixos-rebuild switch --verbose --upgrade --flake ${nixconfigdir}";
      nixgc = "nix-store --gc";
    };
    enableAutosuggestions = true;
    enableCompletion = true;
    syntaxHighlighting.enable = true; #OLD enableSyntaxHighlighting = true;
  };
  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. If you don't want to manage your shell through Home
  # Manager then you have to manually source 'hm-session-vars.sh' located at
  # either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/brian/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    # EDITOR = "emacs";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
