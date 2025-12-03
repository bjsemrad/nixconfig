{ config, pkgs, ... }:

let
  nixconfigdir = "nixconfig";
in
{

  imports = [
  ];

  home = {
    username = "dash";
    homeDirectory = "/home/dash";
    packages = with pkgs; [
            croc
    ];

    file = {
      "compose.yaml".source = ./compose.yaml;
    };

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

  programs.zsh = {
    enable = true;
    shellAliases = {
      #homeupdate = "home-manager switch --flake ${nixconfigdir}";
      nixupdate = "(cd ${config.home.homeDirectory}/${nixconfigdir} && nix flake update) && sudo nixos-rebuild switch --verbose --upgrade --flake ${config.home.homeDirectory}/${nixconfigdir}";
      nixswitch = "sudo nixos-rebuild switch --verbose --upgrade --flake ${config.home.homeDirectory}/${nixconfigdir}";
      nixgc = "nix-store --gc";
      # recommeneded to sometimes run as sudo to collect additional garbage
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
      crocsend="send(){ croc --relay loki.otter-rigel.ts.net:9009 send --code $2 $1};send";
      crocreceive="receive(){ croc --relay loki.otter-rigel.ts.net:9009 $1};receive";
    };
    autosuggestion.enable = true;
    enableCompletion = true;
    syntaxHighlighting.enable = true; #OLD enableSyntaxHighlighting = true;

  };



  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "Brian Semrad";
        email = "bjsemrad@gmail.com";
      };
    };
  };


  # environment.
  programs.direnv.enable = true;

  #CONFIRM  programs.home-manager.enable = true;


}
