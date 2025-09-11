{ config, pkgs, inputs, lib, osConfig, ... }: {
  imports = [
    ./hyprpaper
    ./hyprlock
    ./hypridle
    ./polkitagent
    ./waybar
    ./wlogout
    ./dunst
    ./rofi
    ./walker
  ];

  home.pointerCursor = {
    gtk.enable = true;
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Classic";
    size = 22;
  };

  dconf.settings = {
    "org/gnome/desktop/interface" = { color-scheme = "prefer-dark"; };
  };

  gtk = {
    enable = true;
    theme = {
      name = "Adwaita-dark";
      package = pkgs.gnome-themes-extra;
    };

    gtk3.extraConfig = { gtk-application-prefer-dark-theme = true; };

    gtk4.extraConfig = { gtk-application-prefer-dark-theme = true; };

    # catppuccin.icon.enable = true;
    # catppuccin.icon.accent = "blue";
    iconTheme = {
      package = pkgs.kora-icon-theme;
      name = "kora";
    };

  };
  qt = {
    enable = true;
    style = { name = "adwaita-dark"; };
    platformTheme.name = "kde6";
  };

  wayland.windowManager.hyprland = {
    enable = true;
    package = null;
    portalPackage = null;
    plugins = [
      # inputs.hyprland-plugins.packages.${pkgs.system}.hyprexpo
      #inputs.hyprland-plugins.packages.${pkgs.system}.hyprscrolling
    ];
    settings = {
      monitor = [
        #",preferred,auto,1"
      ] ++ (if (osConfig.networking.hostName == "thor") then [
        "eDP-1,preferred,auto,1.333333,vrr,1"
        ",preferred,auto,1.0"
      ] else if (osConfig.networking.hostName == "odin") then [
        "DP-3,3840x2560@60,auto,1.333333"
        ",preferred,auto,1"
      ] else
        [ ",preferred,auto,1.0" ]);
      xwayland = { force_zero_scaling = true; };

      misc = { disable_hyprland_logo = true; };

      exec-once = [
        "systemctl --user enable --now waybar.service"
        "systemctl --user enable --now hyprpaper.service"
        "systemctl --user enable --now hyprpolkitagent.service"
        "systemctl --user enable --now hypridle.service"
        "uwsm app -- wl-paste --type text --watch cliphist -max-items 25 store" # Stores only text data
        "uwsm app -- wl-paste --type image --watch cliphist -max-items 25 store" # Stores only image data
      ] ++ (if (osConfig.networking.hostName == "odin") then [
        "uwsm app -- openrgb -p Nix3"
        "uwsm app -- wpctl set-default 48"
      ] else
        [ ]);

      env = [
        "GDK_BACKEND,wayland"
        "GTK_THEME,Adwaita:dark"
        "XCURSOR_SIZE,22"
        "HYPRCURSOR_SIZE,22"
        "HYPRCURSOR_THEME,Bibata-Modern-Classic"
        "QT_QPA_PLATFORM,wayland"
        "QT_QPA_PLATFORMTHEME,qt6ct"
        "NIXOS_OZONE_WL,1"
      ] ++ (if (osConfig.networking.hostName == "thor") then
        [ "GDK_DPI_SCALE,1.0" ]
      else if (osConfig.networking.hostName == "odin") then
        [
          "GDK_DPI_SCALE,1.0"
          # "AQ_DRM_DEVICES,/dev/dri/card1"
        ]
      else
        [ "GDK_DPI_SCALE,1.0" ]);

      input = {
        kb_layout = "us";
        kb_options = "ctrl:nocaps";
        follow_mouse = 1;
        mouse_refocus = false;

        touchpad = { natural_scroll = true; };

        sensitivity = 0; # -1.0 - 1.0, 0 means no modification.
      };

      general = {
        gaps_in = 3;
        gaps_out = 4;
        border_size = 2;
        "$black" = "0xff0e1013";
        "$bgDark" = "0xff1E2127";
        "$bg0" = "0xff1f2329";
        "$bg1" = "0xff282c34";
        "$bg2" = "0xff30363f";
        "$bg3" = "0xff323641";
        "$bg_d" = "0xff181b20";
        "$bg_blue" = "0xff61afef";
        "$bg_yellow" = "0xffe8c88c";
        "$fg" = "0xffa0a8b7";
        "$fg_dark" = "0xffabb2bf";
        "$purple" = "0xffbf68d9";
        "$green" = "0xff8ebd6b";
        "$orange" = "0xffcc9057";
        "$blue" = "0xff4fa6ed";
        "$yellow" = "0xffe2b86b";
        "$cyan" = "0xff48b0bd";
        "$red" = "0xffe55561";
        "$grey" = "0xff535965";
        "$light_grey" = "0xff7a818e";
        "$dark_cyan" = "0xff266269";
        "$dark_red" = "0xff8b3434";
        "$dark_yellow" = "0xff835d1a";
        "$dark_purple" = "0xff7e3992";
        "$diff_add" = "0xff272e23";
        "$diff_delete" = "0xff2d2223";
        "$diff_change" = "0xff172a3a";
        "$diff_text" = "0xff274964";

        "col.active_border" = "$blue";
        "col.inactive_border" = "$bg1";
        layout = "dwindle";
        #layout = "scrolling";
      };
      decoration = {
        rounding = 10;
        active_opacity = 1.0;
        inactive_opacity = 1.0;

        layerrule = [ "blur,waybar" "ignorealpha 0.1,waybar" "noanim, walker" ];

        blur = {
          enabled = true;
          size = 12;
          passes = 4;
          new_optimizations = true;
          ignore_opacity = true;
          xray = true;
          brightness = 1;
          noise = 1.0e-2;
          contrast = 1;
          popups = true;
          popups_ignorealpha = 0.6;
          input_methods = true;
          input_methods_ignorealpha = 0.8;
        };

        shadow = {
          enabled = true;
          range = 30;
          render_power = 3;
          color = "0x66000000";
        };
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
          "workspaces, 0, 7, default, fade"
          "windowsMove, 1, 6, default"
        ];
      };

      dwindle = {
        # See https://wiki.hyprland.org/Configuring/Dwindle-Layout/ for more
        pseudotile =
          true; # master switch for pseudotiling. Enabling is bound to mainMod + P in the keybinds section below
        preserve_split = true; # you probably want this
      };

      master = {
        # See https://wiki.hyprland.org/Configuring/Master-Layout/ for more
      };

      gesture = [
        "3,horizontal,workspace"
        "4,vertical,fullscreen"
        "4,horizontal,move"
      ];

      plugin = {
        #scrolling = { fullscreen_on_one_column = true; };
        # hyprexpo = {
        #   columns = 3;
        #   gap_size = 5;
        #   workspace_method =
        #     "first 1"; # [center/first] [workspace] e.g. first 1 or center m+1
        #   enable_gesture = true; # laptop touchpad, 4 fingers
        #   gesture_distance = 300; # how far is the "max"
        #   gesture_positive =
        #     false; # positive = swipe down. Negative = swipe up.
        #   skip_empty = true;
        # };
      };

      # See https://wiki.hyprland.org/Configuring/Keywords/#executing for more
      #device = {
      #  name = "epic-mouse-v1";
      #  sensitivity = -0.5;
      #};

      windowrulev2 = [
        "workspace 1,class:(firefox)"
        "workspace 1,class:(brave-browser)"
        "workspace 3,class:(Proton Mail)"
        "workspace 2,class:(discord)"
        "workspace 2,class:(signal)"
        "workspace 4,class:(Alacritty)"
        "workspace 4,class:(kitty)"
        "workspace 4,class:(com.mitchellh.ghostty)"
        "workspace 5,class:(jetbrains-idea)"
        "workspace 5,class:(Code)"
        "workspace 5,class:(code-url-handler)"
        "workspace 6,class:(steam)"
        "workspace 9,class:(Cider)"
        "workspace 10,class:(BambuStudio)"

        "opacity 1.0 override 1.0 override,class:^(firefox)$"
        "opacity 1.0 override 1.0 override,class:^(Alacritty)$"
        "opacity 1.0 override 1.0 override,class:^(kitty)$"
        "opacity 1.0 override 1.0 override,class:^(com.mitchellh.ghostty)$"
        "opacity 1.0 override 1.0 override,class:^(jetbrains-idea)$"
        "opacity 1.0 override 1.0 override,class:^(Code)$"
        "opacity 1.0 override 1.0 override,class:^(code-url-handler)$"
        "opacity 1.0 override 1.0 override,class:^(Cider)$"
        "opacity 1.0 override 1.0 override,class:^(dev.zed.Zed)$"

        "float,class:^(blueman-manager)$"
        "float,class:^(nm-connection-editor)$"
        "float,class:^(pavucontrol)$"
      ];

      "$mainMod" = "SUPER_L";

      bind = [
        #"$mainMod SHIFT, E, hyprexpo:expo, toggle" # can be: toggle, off/disable or on/enable

        "$mainMod, RETURN, exec, uwsm app -- ghostty" # kitty" #alacritty"
        "$mainMod, Q, killactive,"
        "$mainMod, E, exec,  uwsm app -- thunar"
        "$mainMod, B, exec,  uwsm app -- brave"
        "$mainMod, G, togglefloating,"

        # "$mainMod, D, exec, ags -t launcher"
        # ",XF86PowerOff,  exec, ags -t powermenu"
        # "$mainMod CTRL_L SHIFT, P, exec, ags -t powermenu"
        "$mainMod, D, exec, uwsm app -- $HOME/.config/rofi/scripts/launcher.sh"
        #"$mainMod, D, exec, uwsm app -- walker"

        "$mainMod CTRL_L, W, exec, uwsm app -- $HOME/.config/rofi/scripts/window.sh"
        #"$mainMod CTRL_L, W, exec, uwsm app -- walker -m windows"

        ",XF86PowerOff,  exec,  uwsm app -- $HOME/.config/wlogout/scripts/wlogout.sh"
        "$mainMod CTRL_L SHIFT, P, exec, uwsm app -- $HOME/.config/wlogout/scripts/wlogout.sh"

        "$mainMod CTRL_L SHIFT, C, exec,  uwsm app -- $HOME/.config/rofi/scripts/clipboard.sh"
        #"$mainMod CTRL_L SHIFT, C, exec,  uwsm app -- walker -m clipboard"

        ''$mainMod CTRL_L SHIFT, I, exec,  uwsm app -- grim -g "$(slurp)"''
        '',Print, exec,  uwsm app -- grim -g "$(slurp)"''

        "$mainMod CTRL_L SHIFT, N, exec,  uwsm app -- dunstctl close"
        "$mainMod SHIFT, W, exec,  uwsm app -- pkill waybar && waybar"
        # "$mainMod CTRL_L SHIFT, A, exec, ags -q && ags"

        # Move focus with mainMod + arrow keys
        "$mainMod, left, movefocus, l"
        "$mainMod, right, movefocus, r"
        "$mainMod, up, movefocus, u"
        "$mainMod, down, movefocus, d"

        "$mainMod SHIFT, left, swapwindow, l"
        "$mainMod SHIFT, right, swapwindow, r"
        "$mainMod SHIFT, up, swapwindow, u"
        "$mainMod SHIFT, down, swapwindow, d"

        "$mainMod, J, togglesplit, " # dwindle

        # Resize window
        "$mainMod CTRL_L, left, resizeactive, -10 0"
        "$mainMod CTRL_L, right, resizeactive, 10 0"
        "$mainMod CTRL_L, down, resizeactive, 0 -10"
        "$mainMod CTRL_L, up, resizeactive, 0 10"

        # Scroll through existing workspaces with mainMod + scroll
        "$mainMod, mouse_down, workspace, e+1"
        "$mainMod, mouse_up, workspace, e-1"

        # Home Automations
        ''
          $mainMod CTRL_L ALT_L SHIFT, L, exec, curl -X GET "https://home.semrad.net/api/webhook/-WaJcaS6CZ1F-V-0exl8Nuhmq"''

        "$mainMod SHIFT CTRL_L, M, exec,  uwsm app -- wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
        "$mainMod SHIFT CTRL_L, S, exec,  uwsm app -- wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
        "$mainMod, Tab, focuscurrentorlast,"

        "$mainMod,F,fullscreen"

        "$mainMod ALT, right, workspace, +1"
        "$mainMod ALT, left, workspace, -1"
        "$mainMod ALT SHIFT, right, movetoworkspace, +1"
        "$mainMod ALT SHIFT, left, movetoworkspace, -1"

        "$mainMod, 0, workspace, 10"
        "$mainMod SHIFT, 0, movetoworkspace, 10"
      ] ++ (
        # workspaces
        # binds $mod + [shift +] {1..9} to [move to] workspace {1..9}
        builtins.concatLists (builtins.genList (x:
          let
            ws = let c = (x + 1) / 10; in builtins.toString (x + 1 - (c * 10));
          in [
            "$mainMod, ${ws}, workspace, ${toString (x + 1)}"
            "$mainMod SHIFT, ${ws}, movetoworkspace, ${toString (x + 1)}"
          ]) 9));

      bindm = [
        "$mainMod, mouse:272, movewindow"
        "$mainMod CTRL_L, mouse:272, resizewindow"
      ];

      binde = [
        ''
          , XF86AudioMute, exec,  uwsm app -- wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle && dunstify -i ~/.config/dunst/assets/$(pamixer --get-mute | grep -q "true" && echo "volume-mute.png" || echo "volume.png") -t 500 -r 2593 "Toggle Mute"''
        ''
          , XF86MonBrightnessUp, exec,  uwsm app -- brightnessctl s 5%+ && dunstify -h int:value:"$(( ($(cat /sys/class/backlight/*/brightness) * 100) / $(cat /sys/class/backlight/*/max_brightness) ))"  -i ~/.config/dunst/assets/brightness.svg -t 500 -r 2593 "Brightness: $(( ($(cat /sys/class/backlight/*/brightness) * 100) / $(cat /sys/class/backlight/*/max_brightness) ))%"''
        ''
          , XF86MonBrightnessDown, exec,  uwsm app -- brightnessctl s 5%- && dunstify -h int:value:"$(( ($(cat /sys/class/backlight/*/brightness) * 100) / $(cat /sys/class/backlight/*/max_brightness) ))"  -i ~/.config/dunst/assets/brightness.svg -t 500 -r 2593 "Brightness: $(( ($(cat /sys/class/backlight/*/brightness) * 100) / $(cat /sys/class/backlight/*/max_brightness) ))%"''
        ''
          , XF86AudioRaiseVolume, exec,  uwsm app -- wpctl set-volume -l 1.0 @DEFAULT_AUDIO_SINK@ 5%+ && dunstify -h int:value:"$(pamixer --get-volume)" -i ~/.config/dunst/assets/volume.png -t 500 -r 2593 "Volume: $(pamixer --get-volume) %"''
      ];
      # #
      bindl = [
        ''
          , XF86AudioLowerVolume, exec,  uwsm app -- wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%- && dunstify -h int:value:"$(pamixer --get-volume)" -i ~/.config/dunst/assets/volume.png -t 500 -r 2593 "Volume: $(pamixer --get-volume) %"''
      ];
    };
    extraConfig = "";
    xwayland = { enable = true; };
    systemd.enable = false;
  };

}
