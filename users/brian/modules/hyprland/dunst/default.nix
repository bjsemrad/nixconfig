{
  services.dunst = {
    enable = true;
    settings = {
      global = {
        monitor = 0;
        follow = "none";
        width = 300;
        height = 145;
        origin = "top-right";
        alignment = "left";
        vertical_alignment = "center";
        ellipsize = "middle";
        offset = "15x15";
        padding = 15;
        horizontal_padding = 15;
        text_icon_padding = 15;
        icon_position = "left";
        min_icon_size = 48;
        max_icon_size = 64;
        progress_bar = true;
        progress_bar_height = 8;
        progress_bar_frame_width = 1;
        progress_bar_min_width = 150;
        progress_bar_max_width = 300;
        progress_bar_corner_radius = 20;
        separator_height = 2;
        frame_width = 2;
        frame_color = "#282c34";
        separator_color = "frame";
        corner_radius = 20;
        transparency = 0;
        gap_size = 8;
        line_height = 0;
        notification_limit = 0;
        idle_threshold = 120;
        history_length = 20;
        show_age_threshold = 60;
        markup = "full";
        font = "NotoMono Nerd Font 12";
        format = ''
          <b>%s</b>
          %b:'';
        word_wrap = "yes";
        sort = "yes";
        shrink = "no";
        indicate_hidden = "yes";
        sticky_history = "yes";
        ignore_newline = "no";
        show_indicators = "no";
        stack_duplicates = true;
        always_run_script = true;
        hide_duplicate_count = false;
        ignore_dbusclose = false;
        force_xwayland = false;
        force_xinerama = false;
        mouse_left_click = "do_action";
        mouse_middle_click = "close_all";
        mouse_right_click = "close_current";
      };
      experimental = { per_monitor_dpi = false; };

      urgency_low = {
        background = "#0e1013f0";
        foreground = "#abb2bf";
        highlight = "#abb2bf";
      };

      urgency_normal = {
        background = "#0e1013F0";
        foreground = "#FFFFFF";
        highlight = "#FFFFFF";
      };

      urgency_critical = {
        background = "#0e1013f0";
        foreground = "#FFFFFF";
        frame_color = "#e55561";
        highlight = "#e55561";
      };
    };

  };

  home.file = {
    ".config/dunst/assets/brightness.svg".source = ./assets/brightness.svg;
    ".config/dunst/assets/volume-mute.png".source = ./assets/volume-mute.png;
    ".config/dunst/assets/volume.png".source = ./assets/volume.png;
  };
}
