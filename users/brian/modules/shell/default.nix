{ config, ... }:
let 
  nixconfigdir = "nixconfig";
  in
{

  programs.zsh = {
    enable = true;
    shellAliases = {
      #homeupdate = "home-manager switch --flake ${nixconfigdir}";
      nixupdate = "cd ${config.home.homeDirectory}/${nixconfigdir} && nix flake update && sudo nixos-rebuild switch --verbose --upgrade --flake ${config.home.homeDirectory}/${nixconfigdir}";
      nixswitch = "cd ${config.home.homeDirectory}/${nixconfigdir} && sudo nixos-rebuild switch --verbose --upgrade --flake ${config.home.homeDirectory}/${nixconfigdir}";
      nixgc = "nix-store --gc";
      # recommeneded to sometimes run as sudo to collect additional garbage
      nixgcd = "sudo nix-collect-garbage -d";
      # As a separation of concerns - you will need to run this command to clean out boot
      nixcleanboot = "sudo /run/current-system/bin/switch-to-configuration boot";
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
    enableAutosuggestions = true;
    enableCompletion = true;
    syntaxHighlighting.enable = true; #OLD enableSyntaxHighlighting = true;
  };
}
