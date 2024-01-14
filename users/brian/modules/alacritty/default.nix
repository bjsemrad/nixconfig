{ config, pkgs, lib, inputs, ... }:

{
  nixpkgs.overlays = [ inputs.alacritty-theme.overlays.default ];
  programs.alacritty.enable = true;
  programs.alacritty.settings = {
    window.opacity = lib.mkForce 0.95;
    font.size = 14.0;
    shell.args = [ "--login" "-c" "tmux attach || tmux" ];
    shell.program = "${pkgs.zsh}/bin/zsh";
    env.term = "xterm-256color";
    import = [ pkgs.alacritty-theme.one_dark ];
  };

}
