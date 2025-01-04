{  pkgs, ... }:
{
   home.packages = with pkgs; [ tmux-sessionizer ];

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
      set -g prefix C-a
      unbind-key t
      bind-key -T prefix t switch-client -T tms
      bind-key -T tms p display-popup -E "tms"
      bind-key -T tms s display-popup -E "tms switch"

      bind-key -T prefix w switch-client -T window
      bind-key -T window c new-window
      bind-key -T window r command-prompt -I "#W" { rename-window "%%" } 
      bind-key -T window x confirm kill-window

      bind-key -T prefix s switch-client -T session
      bind-key -T session r command-prompt -p "Rename active session to: " "run-shell 'tms rename %1'"
      bind-key -T session c command-prompt -p "New Session:" "new-session -A -s '%%'"
      bind-key -T session x confirm "run-shell 'tms kill'"

      bind-key -T prefix p switch-client -T pane
      bind-key -T pane h split-window -h
      bind-key -T pane v split-window -v


      set -g base-index 1
      setw -g pane-base-index 1

      set -g mouse on

      set -g status-position bottom
   
      set -g @onedark_time_format "%I:%M %p"
      set -g @onedark_date_format "%D"
    '';
  };
}
