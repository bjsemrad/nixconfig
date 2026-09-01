{ pkgs, config, ... }:
let
  nixconfigdir = "nixconfig";
in
{
  programs.carapace = {
    enable = true;
    enableNushellIntegration = false;
    enableZshIntegration = true;
  };

  programs.zsh = {
    enable = true;
    shellAliases = {
      #homeupdate = "home-manager switch --flake ${nixconfigdir}";
      nixupdate = "(cd ${config.home.homeDirectory}/${nixconfigdir} && nix flake update) && sudo nixos-rebuild switch --verbose --flake ${config.home.homeDirectory}/${nixconfigdir}";
      #forces cleanup of home manager generations
      nixupdateclean = "(cd ${config.home.homeDirectory}/${nixconfigdir} && nix flake update) && sudo nixos-rebuild switch --verbose --option keep-outputs false --option keep-derivations false --flake ${config.home.homeDirectory}/${nixconfigdir}";
      nixswitch = "sudo nixos-rebuild switch --verbose --upgrade --flake ${config.home.homeDirectory}/${nixconfigdir}";
      nixgc = "sudo nix-store --gc;nix-store --gc";
      # recommeneded to sometimes run as sudo to collect additional garbage
      nixgcd = "sudo nix-collect-garbage -d;nix-collect-garbage -d";
      ga = "git add";
      gba = "git branch -a";
      gc = "git commit -v";
      gcb = "git checkout -b";
      gcmsg = "git commit -m";
      gl = "git pull";
      gp = "git push";
      gco = "git checkout";
      gst = "git status";
      sshbaldr = "ssh root@baldr.otter-rigel.ts.net";
      sshtruenas = "ssh root@truenas.otter-rigel.ts.net";
      sshminecraft = "ssh mine@minecraft.otter-rigel.ts.net";
      tmuxsessionize = "tmux attach-session -t main || tmux new-session -s main";
      rebuild-baldr = "nixos-rebuild switch -s --flake .#baldr --target-host root@10.0.10.6 --verbose";
      rebuild-loki = "nixos-rebuild switch -s --flake .#loki --target-host root@10.0.10.7 --verbose";

      tailreceive = "sudo tailscale file get .";
      setup-vial = "qmk setup bjsemrad/vial-qmk -H ~/vial-qmk -b vial";
      setup-qmk = "qmk setup bjsemrad/qmk_firmware -H ~/qmk_firmwarel";
      build-lily58 = "QMK_HOME=~/vial-qmk qmk compile -kb lily58/rev1 -km brian -e CONVERT_TO=rp2040_ce";
      flash-lily58 = "QMK_HOME=~/vial-qmk qmk flash -kb lily58/rev1 -km brian -e CONVERT_TO=rp2040_ce";
      build-ferrismx = "QMK_HOME=~/vial-qmk qmk compile -kb ferris/sweep -km mxferris_linvert_blok -e CONVERT_TO=blok";
      flash-ferrismx = "QMK_HOME=~/vial-qmk qmk flash -kb ferris/sweep -km mxferris_linvert_blok -e CONVERT_TO=blok";

    };
    autosuggestion.enable = true;
    enableCompletion = true;
    syntaxHighlighting.enable = true;
    initContent = ''
      export PATH=$PATH:~/tools

      export NIX_LD=$(nix eval --impure --raw --expr 'let pkgs = import <nixpkgs> {}; NIX_LD = pkgs.lib.fileContents "${pkgs.stdenv.cc}/nix-support/dynamic-linker"; in NIX_LD')
    '';
  };
}
