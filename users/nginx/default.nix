{ config, pkgs, ... }:
{

  imports = [
  ];

  home = {
    username = "nginx";
    homeDirectory = "/home/nginx";
    packages = with pkgs; [
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

  programs.zsh = {
    enable = true;
    shellAliases = {
      nixgc = "nix-store --gc";
      nixgcd = "sudo nix-collect-garbage -d";
      ga = "git add";
      gba = "git branch -a";
      gc = "git commit -v";
      gcb = "git checkout -b";
      gcmsg = "git commit -m";
      gl = "git pull";
      gp = "git push";
      gco = "git checkout";
      gst = "git status";
    };
    autosuggestion.enable = true;
    enableCompletion = true;
    syntaxHighlighting.enable = true; #OLD enableSyntaxHighlighting = true;

  };

}
