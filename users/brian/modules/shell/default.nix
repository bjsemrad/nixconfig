{ pkgs, config, ... }:
let 
  nixconfigdir = "nixconfig";
  in
{
  programs.carapace = {
    enable = true;
    enableNushellIntegration = true;
    enableZshIntegration = true;
  };

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
      sshproxy="ssh nginx@proxy.otter-rigel.ts.net";
      sshcroc="ssh worm@loki.otter-rigel.ts.net";
      croc-rebuild="nixos-rebuild switch -s --flake .#loki --target-host root@loki.otter-rigel.ts.net  --verbose";
      dashboard-rebuild="nixos-rebuild switch -s --flake .#tyr --target-host root@dashboard.otter-rigel.ts.net  --verbose";
      proxy-rebuild="nixos-rebuild switch -s --flake .#yggdrasil --target-host root@proxy.otter-rigel.ts.net --verbose";
      tailreceive="sudo tailscale file get .";
      setup-vial="qmk setup bjsemrad/vial-qmk -H ~/vial-qmk -b vial";
      setup-qmk="qmk setup bjsemrad/qmk_firmware -H ~/qmk_firmwarel";
      build-lily58="QMK_HOME=~/vial-qmk qmk compile -kb lily58/rev1 -km brian -e CONVERT_TO=rp2040_ce";
      flash-lily58="QMK_HOME=~/vial-qmk qmk flash -kb lily58/rev1 -km brian -e CONVERT_TO=rp2040_ce";
      build-ferrismx="QMK_HOME=~/vial-qmk qmk compile -kb ferris/sweep -km mxferris_linvert_blok -e CONVERT_TO=blok";
      flash-ferrismx="QMK_HOME=~/vial-qmk qmk flash -kb ferris/sweep -km mxferris_linvert_blok -e CONVERT_TO=blok";

    };
    autosuggestion.enable = true;   
    enableCompletion = true;
    syntaxHighlighting.enable = true;
    initContent = ''
      export PATH=$PATH:~/tools
      if uwsm check may-start && uwsm select; then
	exec systemd-cat -t uwsm_start uwsm start default
      fi

      if command -v tmux &> /dev/null && [ -z "$TMUX" ]; then
        tmux attach-session -t main || tmux new-session -s main
      fi

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


      #if [[ -z "$ZELLIJ" ]]; then
      #  zellij attach -c main

       # if [[ "$ZELLIJ_AUTO_EXIT" == "true" ]]; then
       #   exit
       # fi
      #fi

      #zellij_tab_name_update
      #chpwd_functions+=(zellij_tab_name_update)
      # This command let's me execute arbitrary binaries downloaded through channels such as mason.
      export NIX_LD=$(nix eval --impure --raw --expr 'let pkgs = import <nixpkgs> {}; NIX_LD = pkgs.lib.fileContents "${pkgs.stdenv.cc}/nix-support/dynamic-linker"; in NIX_LD')
    '';
  };

  programs.nushell = {
    enable = true;
    envFile.text = ''$env.PATH = ($env.PATH | split row (char esep) | append '~/tools/')'';
    extraConfig = ''
      $env.config = {
         show_banner: false,
        hooks: {
          env_change: {
             PWD: {|after| (zellij_tab_name_update) }
          }
        }
      }

      export-env {
          let nix_ld_path = (nix eval --impure --raw --expr 'let pkgs = import <nixpkgs> {}; NIX_LD = pkgs.lib.fileContents "${pkgs.stdenv.cc}/nix-support/dynamic-linker"; in NIX_LD')
          $env.NIX_LD = $nix_ld_path
      }

      def nixupdate [] {
          cd ${config.home.homeDirectory}/${nixconfigdir}
          nix flake update
          sudo nixos-rebuild switch --verbose --upgrade --flake ${config.home.homeDirectory}/${nixconfigdir}
      };

      def start_zellij [] {
        if 'ZELLIJ' not-in ($env | columns) {
            zellij attach -c
        }
      };


      def zellij_tab_name_update [] {
        if 'ZELLIJ' in ($env | columns) {
          mut current_directory = pwd
          if ($current_directory == $env.HOME) {
              $current_directory = "~"
          } else {
              $current_directory = ( $current_directory | path basename )
          }
          (zellij action rename-tab $current_directory)
        }
      }

      start_zellij
      zellij_tab_name_update

    '';
    shellAliases = {
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
      sshminecraft="ssh mine@minecraft.otter-rigel.ts.net";
      sshproxy="ssh nginx@proxy.otter-rigel.ts.net";
      dashboard-rebuild="nixos-rebuild switch -s --flake .#tyr --target-host root@dashboard.otter-rigel.ts.net  --verbose";
      proxy-rebuild="nixos-rebuild switch -s --flake .#yggdrasil --target-host root@proxy.otter-rigel.ts.net --verbose";
      tailreceive="sudo tailscale file get .";
      setup-vial="qmk setup bjsemrad/vial-qmk -H ~/vial-qmk -b vial";
      setup-qmk="qmk setup bjsemrad/qmk_firmware -H ~/qmk_firmwarel";
      build-lily58="QMK_HOME=~/vial-qmk qmk compile -kb lily58/rev1 -km brian -e CONVERT_TO=rp2040_ce";
      flash-lily58="QMK_HOME=~/vial-qmk qmk flash -kb lily58/rev1 -km brian -e CONVERT_TO=rp2040_ce";
      build-ferrismx="QMK_HOME=~/vial-qmk qmk compile -kb ferris/sweep -km mxferris_linvert_blok -e CONVERT_TO=blok";
      flash-ferrismx="QMK_HOME=~/vial-qmk qmk flash -kb ferris/sweep -km mxferris_linvert_blok -e CONVERT_TO=blok";
    };
  };
}
