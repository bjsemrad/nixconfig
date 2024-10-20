{ pkgs, config, ... }:
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
      sshminecraft="ssh mine@10.0.10.206";
      sshcroc="ssh worm@loki.otter-rigel.ts.net";
      croc-rebuild="nixos-rebuild switch -s --flake .#loki --target-host root@loki.otter-rigel.ts.net  --verbose";
      dashboard-rebuild="nixos-rebuild switch -s --flake .#heimdall --target-host root@dashboard.otter-rigel.ts.net  --verbose";
      crocsend="send(){ croc --relay loki.otter-rigel.ts.net:9009 send --code $2 $1};send";
      crocreceive="receive(){ croc --relay loki.otter-rigel.ts.net:9009 $1};receive";
      tailreceive="sudo tailscale file get .";
      setup-vial="qmk setup bjsemrad/vial-qmk -H ~/vial-qmk -b vial";
      setup-qmk="qmk setup bjsemrad/qmk_firmware -H ~/qmk_firmwarel";
      build-lily58="QMK_HOME=~/vial-qmk qmk compile -kb lily58/rev1 -km brian -e CONVERT_TO=rp2040_ce";
      flash-lily58="MK_HOME=~/vial-qmk qmk flash -kb lily58/rev1 -km brian -e CONVERT_TO=rp2040_ce";
    };
    autosuggestion.enable = true;   
    enableCompletion = true;
    syntaxHighlighting.enable = true;
    initExtra = ''
      zellij_tab_name_update() {
        if [[ -n $ZELLIJ ]]; then
          local current_dir=$PWD
          if [[ $current_dir == $HOME ]]; then
              current_dir="~"
          else
              current_dir=''\${current_dir##*/}
          fi
          command nohup zellij action rename-tab $current_dir >/dev/null 2>&1
        fi
      }

      zellij_tab_name_update
      chpwd_functions+=(zellij_tab_name_update)
      # This command let's me execute arbitrary binaries downloaded through channels such as mason.
      export NIX_LD=$(nix eval --impure --raw --expr 'let pkgs = import <nixpkgs> {}; NIX_LD = pkgs.lib.fileContents "${pkgs.stdenv.cc}/nix-support/dynamic-linker"; in NIX_LD')
    '';
  };
}
