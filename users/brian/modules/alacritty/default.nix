{ pkgs, lib, ... }:

{
  programs.alacritty.enable = true;
  programs.alacritty.settings = {
    #window.opacity = lib.mkForce 0.85;
    font.size = 13.0;
    font.bold = {
      family = "JetBrainsMono Nerd Font";
      style = "Bold";
    };

    font.bold_italic = {
      family = "JetBrainsMono Nerd Font";
      style = "Bold Italic";
    };

    font.italic = {
      family = "JetBrainsMono Nerd Font";
      style = "Italic";
    };

    font.normal = {
      family = "JetBrainsMono Nerd Font";
      style = "Regular";
    };
    #shell.args = [ "--login" "-c" "tmux attach || tmux" ];
    shell.program = "${pkgs.zsh}/bin/zsh";
    env.term = "xterm-256color";
    # import = [ pkgs.alacritty-theme.catppuccin_mocha ]; # rose-pine  ];
  };
}
