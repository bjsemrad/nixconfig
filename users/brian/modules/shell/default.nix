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
      nixgc = "sudo nix-store --gc";
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
      sshdash="ssh dash@dashboard.otter-rigel.ts.net";
      sshprox="ssh root@proxmox.otter-rigel.ts.net";
      sshtruenas="ssh root@10.0.10.13";
      sshchannels="ssh channels@channels.otter-rigel.ts.net";
      sshcroc="ssh worm@loki.otter-rigel.ts.net";
      croc-rebuild="nixos-rebuild switch -s --flake .#loki --target-host root@loki.otter-rigel.ts.net  --verbose";
      dashboard-rebuild="nixos-rebuild switch -s --flake .#heimdall --target-host root@dashboard.otter-rigel.ts.net  --verbose";
      crocsend="send(){ croc --relay loki.otter-rigel.ts.net:9009 send --code $2 $1};send";
      crocreceive="receive(){ croc --relay loki.otter-rigel.ts.net:9009 $1};receive";
    };
    enableAutosuggestions = true;
    enableCompletion = true;
    syntaxHighlighting.enable = true; #OLD enableSyntaxHighlighting = true;
  };
}
