{ config, pkgs, inputs, lib, osConfig, ... }:
{
  imports =
    [
      ./hyprpaper
      ./hyprlock
      ./hypridle
      ./waybar
      #./swaylock
      ./wlogout
      #./swayidle
      ./dunst
      ./rofi
    ];

  home.pointerCursor = {
    gtk.enable = true;
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Classic";
    size = 22;
  };
  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
    };
  };

  gtk = {
    enable = true;
    theme = {
      name = "Adwaita-dark";
      package = pkgs.gnome.gnome-themes-extra;
    };

    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = true;
    };

    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme = true;
    };

    iconTheme = {
      package = pkgs.kora-icon-theme;
      name = "kora";
    };

  };

  wayland.windowManager.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.system}.hyprland;
    plugins = [
       inputs.hyprland-plugins.packages.${pkgs.system}.hyprexpo
      #  (pkgs.callPackage ./hyprbars.nix { inherit hyprland-plugins; } )
    ];
    settings = {
      monitor = [
        ",preferred,auto,1"
      ] ++ (
        if (osConfig.networking.hostName == "thor") then
          [ "eDP-1,preferred,auto,1.175" ]
        else if (osConfig.networking.hostName == "odin") then
          [ ",3840x1600@60,auto,1.0" ]
        else [ ",preferred,auto,1.0" ]
      );
      xwayland = {
        force_zero_scaling = true;
      };

      misc = {
        disable_hyprland_logo = true;
      };

      exec-once = [
        "waybar"
        "hyprpaper"
        "wl-paste --type text --watch cliphist -max-items 25 store" #Stores only text data
        "wl-paste --type image --watch cliphist -max-items 25 store" #Stores only image data
      ] ++ (
        if (osConfig.networking.hostName == "odin") then
          [
            "openrgb -p Nix"
            "wpctl set-default 45"
          ]
        else [ ]
      );

      env = [
        "GDK_BACKEND,wayland"
        "GTK_THEME,Adwaita:dark"
        "XCURSOR_SIZE,22"
        "QT_QPA_PLATFORM,wayland"
        "QT_QPA_PLATFORMTHEME,qt5ct"
        "NIXOS_OZONE_WL,1"
      ] ++ (
        if (osConfig.networking.hostName == "thor") then
          [ "GDK_DPI_SCALE,1.175" ]
        else if (osConfig.networking.hostName == "odin") then
          [ "GDK_DPI_SCALE,1.0" ]
        else [ "GDK_DPI_SCALE,1.0" ]
      );

      input = {
        kb_layout = "us";
        kb_options = "ctrl:nocaps";
        follow_mouse = 1;
        mouse_refocus = false;

        touchpad = {
          natural_scroll = true;
        };

        sensitivity = 0; # -1.0 - 1.0, 0 means no modification.
      };

      general = {
        gaps_in = 3;
        gaps_out = 4;
        border_size = 2;

        #"col.active_border" = "rgba(${config.colorScheme.palette.base0C}ff) rgba(${config.colorScheme.palette.base0D}ff) rgba(${config.colorScheme.palette.base0B}ff) rgba(${config.colorScheme.palette.base0E}ff) 45deg";
        #"col.inactive_border" = "rgba(${config.colorScheme.palette.base00}cc) rgba(${config.colorScheme.palette.base01}cc) 45deg";

        "col.active_border" = "rgba(7EBAE4ff) rgba(7EBAE4ff) 45deg";
        "col.inactive_border" = "rgba(585b70ff)";
        layout = "master";
      };
      decoration = {
        rounding = 10;
        active_opacity = 0.85;
        inactive_opacity = 0.6;


        blur = {
          enabled = true;
          size = 6;
          passes = 4;
          new_optimizations = true;
          ignore_opacity = true;
          xray = true;
        };
        drop_shadow = true;
        shadow_range = 30;
        shadow_render_power = 3;
        "col.shadow" = "0x66000000";
      };

      animations = {
        enabled = true;

        bezier = "myBezier, 0.05, 0.9, 0.1, 1.05";

        animation = [
          "windows, 1, 7, myBezier"
          "windowsOut, 1, 7, default, popin 80%"
          "border, 1, 10, default"
          "borderangle, 1, 8, default"
          "fade, 1, 7, default"
          "workspaces, 1, 7, default, fade"
          "windowsMove, 1, 6, default"
        ];
      };

      dwindle = {
        # See https://wiki.hyprland.org/Configuring/Dwindle-Layout/ for more
        pseudotile = true; # master switch for pseudotiling. Enabling is bound to mainMod + P in the keybinds section below
        preserve_split = true; # you probably want this
      };

      master = {
        # See https://wiki.hyprland.org/Configuring/Master-Layout/ for more
        new_is_master = true;
      };

      gestures = {
        # See https://wiki.hyprland.org/Configuring/Variables/ for more
        workspace_swipe = true;
      };

      plugin = {
        hyprexpo = {
          columns = 3;
          gap_size = 5;
          #bg_col = rgb(111111);
          workspace_method = "first 1"; # [center/first] [workspace] e.g. first 1 or center m+1

          enable_gesture = true; # laptop touchpad, 4 fingers
          gesture_distance = 300; # how far is the "max"
          gesture_positive = true; # positive = swipe down. Negative = swipe up.
        };
      };


      # See https://wiki.hyprland.org/Configuring/Keywords/#executing for more
      #device = {
      #  name = "epic-mouse-v1";
      #  sensitivity = -0.5;
      #};


      windowrulev2 = [
        "workspace 1,class:(firefox)"
        "workspace 4,class:(Alacritty)"
        "workspace 4,class:(org.wezfurlong.wezterm)"
        "workspace 5,class:(jetbrains-idea)"
        "workspace 5,class:(Code)"
        "workspace 5,class:(code-url-handler)"
        "workspace 2,class:(discord)"
        "workspace 2,class:(Element)"
        "workspace 6,class:(steam)"
        "workspace 3,class:(geary)"

        #"opacity 1.0 override 1.0 override,class:^(firefox)$"
        #"opacity 0.9 override 0.9 override,class:^(jetbrains-idea)$"

        "float,class:^(blueman-manager)$"
        "float,class:^(nm-connection-editor)$"
        "float,class:^(pavucontrol)$"
      ];

      "$mainMod" = "ALT_L";

      bind = [
        "$mainMod, grave, hyprexpo:expo, toggle"  # can be: toggle, off/disable or on/enable

        "$mainMod, T, exec, alacritty"
        "$mainMod, Q, killactive,"
        "$mainMod, E, exec, thunar"
        "$mainMod, G, togglefloating,"
        "$mainMod, D, exec, $HOME/.config/rofi/scripts/launcher.sh"
        "$mainMod CTRL_L, W, exec, $HOME/.config/rofi/scripts/window.sh"
        "$mainMod CTRL_L SHIFT, P, exec, $HOME/.config/wlogout/scripts/wlogout.sh"
        "$mainMod CTRL_L SHIFT, C, exec, $HOME/.config/rofi/scripts/clipboard.sh"
        "$mainMod CTRL_L SHIFT, I, exec, grim -g \"$(slurp)\""

        "$mainMod CTRL_L SHIFT, N, exec, dunstctl close"
        "$mainMod SHIFT, W, exec, pkill waybar && waybar"

        # Move focus with mainMod + arrow keys
        "$mainMod, left, movefocus, l"
        "$mainMod, right, movefocus, r"
        "$mainMod, up, movefocus, u"
        "$mainMod, down, movefocus, d"

        "$mainMod SHIFT, left, swapwindow, l"
        "$mainMod SHIFT, right, swapwindow, r"
        "$mainMod SHIFT, up, swapwindow, u"
        "$mainMod SHIFT, down, swapwindow, d"

        # Resize window
        "SUPER SHIFT, left, resizeactive, -160 0"
        "SUPER SHIFT, right, resizeactive, 160 0"
        "SUPER SHIFT, down, resizeactive, 0 -160"
        "SUPER SHIFT, up, resizeactive, 0 160"

        # Scroll through existing workspaces with mainMod + scroll
        "$mainMod, mouse_down, workspace, e+1"
        "$mainMod, mouse_up, workspace, e-1"


        "$mainMod SHIFT CTRL_L, M, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
        "$mainMod SHIFT CTRL_L, S, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
        "ALT, Tab, focuscurrentorlast,"

        "SUPER,F,fullscreen"
        "$mainMod, F, fullscreen,1"

        "CTRL_L, 0, workspace, 10"
        "$mainMod SHIFT, 0, movetoworkspace, 10"
      ]
      ++ (
        # workspaces
        # binds $mod + [shift +] {1..9} to [move to] workspace {1..9}
        builtins.concatLists (builtins.genList
          (
            x:
            let
              ws =
                let
                  c = (x + 1) / 10;
                in
                builtins.toString (x + 1 - (c * 10));
            in
            [
              "CTRL_L, ${ws}, workspace, ${toString (x + 1)}"
              "CTRL_L SHIFT, ${ws}, movetoworkspace, ${toString (x + 1)}"
            ]
          )
          9)
      );

      bindm = [
        "$mainMod, mouse:272, movewindow"
        "$mainMod CTRL_L, mouse:272, resizewindow"
      ];

      binde = [
        ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle && dunstify -i ~/.config/dunst/assets/$(pamixer --get-mute | grep -q \"true\" && echo \"volume-mute.png\" || echo \"volume.png\") -t 500 -r 2593 \"Toggle Mute\""
        ", XF86MonBrightnessUp, exec, brightnessctl s 5%+ && dunstify -h int:value:\"$(( ($(cat /sys/class/backlight/*/brightness) * 100) / $(cat /sys/class/backlight/*/max_brightness) ))\"  -i ~/.config/dunst/assets/brightness.svg -t 500 -r 2593 \"Brightness: $(( ($(cat /sys/class/backlight/*/brightness) * 100) / $(cat /sys/class/backlight/*/max_brightness) ))%\""
        ", XF86MonBrightnessDown, exec, brightnessctl s 5%- && dunstify -h int:value:\"$(( ($(cat /sys/class/backlight/*/brightness) * 100) / $(cat /sys/class/backlight/*/max_brightness) ))\"  -i ~/.config/dunst/assets/brightness.svg -t 500 -r 2593 \"Brightness: $(( ($(cat /sys/class/backlight/*/brightness) * 100) / $(cat /sys/class/backlight/*/max_brightness) ))%\""
        ", XF86AudioRaiseVolume, exec, wpctl set-volume -l 1.0 @DEFAULT_AUDIO_SINK@ 5%+ && dunstify -h int:value:\"$(pamixer --get-volume)\" -i ~/.config/dunst/assets/volume.png -t 500 -r 2593 \"Volume: $(pamixer --get-volume) %\""
      ];

      bindl = [
        ", XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%- && dunstify -h int:value:\"$(pamixer --get-volume)\" -i ~/.config/dunst/assets/volume.png -t 500 -r 2593 \"Volume: $(pamixer --get-volume) %\""
      ];

    };
    extraConfig = ''
    '';
    xwayland = { enable = true; };
    systemd.enable = true;
  };
}
