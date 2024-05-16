{ pkgs, lib, ... }:

{
  programs.alacritty.enable = true;
  programs.alacritty.settings = {
    #window.opacity = lib.mkForce 0.85;
    font.size = 13.0;
    #shell.args = [ "--login" "-c" "tmux attach || tmux" ];
    shell.program = "${pkgs.zsh}/bin/zsh";
    env.term = "xterm-256color";
    import = [ pkgs.alacritty-theme.dracula ];
  };

}
