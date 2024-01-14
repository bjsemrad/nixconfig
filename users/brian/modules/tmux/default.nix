{  pkgs, ... }:
{
     programs.tmux = {
    enable = true;

    baseIndex = 1;
    newSession = true;
    plugins = [
      pkgs.tmuxPlugins.onedark-theme
      pkgs.tmuxPlugins.sensible
    ];

    extraConfig = ''
       # Fix Colors
      set -g default-terminal "screen-256color"
      set -ag terminal-overrides ",xterm-256color:Tc"

      set -g prefix C-b

      set -g base-index 1
      setw -g pane-base-index 1

      set -g mouse on

      set -g status-position bottom
   
      #set -g @onedark_widgets "#(date +%s)"
      set -g @onedark_time_format "%I:%M %p"
      set -g @onedark_date_format "%D"
      # set -g @catppuccin_window_right_separator "█ "

      # set -g @catppuccin_window_default_fill "number"
      # set -g @catppuccin_window_default_text "#W - #{pane_current_path}"

      # set -g @catppuccin_window_current_fill "number"
      # set -g @catppuccin_window_current_text "#W - #{pane_current_path}"

      # set -g @catppuccin_window_right_separator "█ "
      # set -g @catppuccin_window_number_position "left"
      # set -g @catppuccin_window_middle_separator " | "

      # set -g @catppuccin_window_default_fill "none"

      # set -g @catppuccin_window_current_fill "all"
      # set -g @catppuccin_status_modules_right "session user host"
      # set -g @catppuccin_status_left_separator "█"
      # set -g @catppuccin_status_right_separator "█"


      # set -g @catppuccin_status_right_separator_inverse "no"
      # set -g @catppuccin_status_fill "icon"
      # set -g @catppuccin_status_connect_separator "no"

      # set -g @catppuccin_directory_text "#{pane_current_path}"

    '';
  };
}