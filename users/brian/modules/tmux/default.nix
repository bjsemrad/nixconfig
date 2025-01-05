{ pkgs, ... }:
{
   home.packages = with pkgs; [ tmux-sessionizer ];
   home.file = {
        ".config/tms/config.toml".source = ./config.toml;
   };

  programs.tmux = {
    enable = true;

    baseIndex = 1;
    newSession = false;
    plugins = with pkgs; [
      tmuxPlugins.sensible
      {
        plugin = tmuxPlugins.resurrect;
        extraConfig = ''
            set -g @resurrect-strategy-nvim 'session'
            resurrect_dir="$HOME/.tmux/resurrect"
            set -g @resurrect-dir $resurrect_dir
          '';
      }
      {
        plugin = tmuxPlugins.continuum;
        extraConfig = ''
          set -g @continuum-restore 'on'
          set -g @continuum-save-interval '1' # minutes
        '';
      }
      tmuxPlugins.prefix-highlight
      tmuxPlugins.tmux-fzf
    ];

    extraConfig = ''
       # Fix Colors
      set -g default-terminal "screen-256color"
      set -ag terminal-overrides ",xterm-256color:Tc"

      set -g prefix C-a
      unbind-key t
 
      #Session
      bind-key -T prefix s switch-client -T session
      bind-key -T session s display-popup -E "tms switch"
      bind-key -T session p display-popup -E "tms"
      bind-key -T session r command-prompt -p "Rename active session to: " "run-shell 'tms rename %1'"
      bind-key -T session n command-prompt -p "New Session:" "new-session -A -s '%%'"
      bind-key -T session x confirm "run-shell 'tms kill'"

      #Window
      bind-key -T prefix w switch-client -T window
      bind-key -T window n new-window
      bind-key -T window r command-prompt -I "#W" { rename-window "%%" } 

      #PANE
      bind-key -T prefix p switch-client -T pane
      bind-key -T pane h split-window -h
      bind-key -T pane v split-window -v

      set -g base-index 1
      setw -g pane-base-index 1

      set -g mouse on

      set -g status-position bottom


# Set the One Dark theme colors as tmux variables
set -g @onedark_black "#282c34"
set -g @onedark_blue "#61afef"
set -g @onedark_yellow "#e5c07b"
set -g @onedark_red "#e06c75"
set -g @onedark_white "#aab2bf"
set -g @onedark_green "#98c379"
set -g @onedark_visual_grey "#3e4452"
set -g @onedark_comment_grey "#5c6370"

# Set status bar appearance
set -g status on
set -g status-justify left
set -g status-left-length 100
set -g status-right-length 100


# Set window style colors
set -g window-style "fg=$onedark_comment_grey"
set -g window-active-style "fg=$onedark_white"

# Set display panes colors
set -g display-panes-active-colour "$onedark_yellow"
set -g display-panes-colour "$onedark_blue"

# Set the status bar colors
set -g status-bg "$onedark_black"
set -g status-fg "$onedark_white"

# Prefix highlight settings
set -g @prefix_highlight_fg "$onedark_black"
set -g @prefix_highlight_bg "$onedark_green"
set -g @prefix_highlight_copy_mode_attr "fg=$onedark_black,bg=$onedark_green"
set -g @prefix_highlight_output_prefix "  "

# Set status-right to include time, date, and custom widgets
set -g status-right "#[fg=$onedark_green,bg=$onedark_black,nobold,nounderscore,noitalics]#[fg=$onedark_black,bg=$onedark_green,bold] #h "

# Set status-left to show session and prefix highlight
set -g status-left "#[fg=$onedark_black,bg=$onedark_green,bold] #S #[fg=$onedark_green,bg=$onedark_black,nobold,nounderscore,noitalics]"

# Set window status format
set -g window-status-format "#[fg=$onedark_black,bg=$onedark_black,nobold,nounderscore,noitalics]#[fg=$onedark_white,bg=$onedark_black] #I  #W #[fg=$onedark_black,bg=$onedark_black,nobold,nounderscore,noitalics]"
set -g window-status-current-format "#[fg=$onedark_black,bg=$onedark_visual_grey,nobold,nounderscore,noitalics]#[fg=$onedark_white,bg=$onedark_visual_grey,nobold] #I  #W #[fg=$onedark_visual_grey,bg=$onedark_black,nobold,nounderscore,noitalics]"

    '';
  };
}
