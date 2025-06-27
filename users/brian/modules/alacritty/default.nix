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
    terminal.shell.program = "${pkgs.zsh}/bin/zsh";
    env.term = "xterm-256color";
    general.import = ["~/.config/alacritty/themes/onedark-darker.toml"];
      #general.import = [pkgs.alacritty-theme.one_dark];
    # import = [ pkgs.alacritty-theme.catppuccin_mocha ]; # rose-pine  ];
  };

    home.file = {
        ".config/alacritty/themes/onedark-darker.toml".source = ./onedark-darker.toml;
    };
}
