{ config, ... }:
let 
  nixconfigdir = "nixconfig";
  in
{

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
    };
    enableAutosuggestions = true;
    enableCompletion = true;
    syntaxHighlighting.enable = true; #OLD enableSyntaxHighlighting = true;
  };
}
