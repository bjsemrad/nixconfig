{
  config,
  pkgs,
  inputs,
  lib,
  osConfig,
  ...
}:
{
  imports = [
    ./hyprpaper
    ./hyprlock
    ./hypridle
    ./hyprlauncher
    ./polkitagent
    ./waybar
    ./wlogout
    # ./dunst
    ./swaync
    ./rofi
    ./walker
  ];

  home.file = {
    ".config/hypr/resize.sh".source = ./resize.sh;
  };

  home.pointerCursor = {
    gtk.enable = true;
    package = pkgs.xcursor-pro; # bibata-cursors;
    name = "XCursor-Pro-Dark"; # "Bibata-Modern-Classic";
    size = 24;
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
      package = pkgs.gnome-themes-extra;
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

  qt = {
    enable = true;
    style = {
      name = "adwaita-dark";
      package = pkgs.adwaita-qt6;
    };
    platformTheme.name = "qtct";
  };

  wayland.windowManager.hyprland = {
    enable = true;
    package = null;
    portalPackage = null;
    plugins = [
      # inputs.hyprland-plugins.packages.${pkgs.system}.hyprexpo
      # inputs.hyprland-plugins.packages.${pkgs.stdenv.hostPlatform.system}.hyprscrolling
    ];
    # settings = {
    # monitor = [
    #   #",preferred,auto,1"
    # ]
    # ++ (
    #   if (osConfig.networking.hostName == "thor") then
    #     [
    #       "eDP-1,preferred,auto,1.333333,vrr,1"
    #       ",preferred,auto,1.0"
    #     ]
    #   else if (osConfig.networking.hostName == "odin") then
    #     [
    #       "DP-3,3840x2560@60,auto,1.333333" # ",bitdepth,10,cm,hdr,sdrbrightness,1.5,sdrsaturation,1.0"
    #       ",preferred,auto,1"
    #     ]
    #   else
    #     [ ",preferred,auto,1.0" ]
    # );
    #
    # render = {
    #   cm_enabled = true;
    #   cm_auto_hdr = 1;
    # };
    #
    # xwayland = {
    #   force_zero_scaling = true;
    # };
    #
    # misc = {
    #   disable_hyprland_logo = true;
    # };

    #       exec-once = [
    #         # "systemctl --user enable --now waybar.service"
    # #        "systemctl --user restart --now hyprpaper.service"
    # #        "systemctl --user restart --now hyprpolkitagent.service"
    # #        "systemctl --user restart --now hypridle.service"
    # #        "systemctl --user restart --now elephant.service"
    # #        "systemctl --user restart --now epochshell"
    # #        "wl-paste --type text --watch cliphist -max-items 25 store"
    # #        "wl-paste --type image --watch cliphist -max-items 25 store"
    #       ]
    #       ++ (
    #         if (osConfig.networking.hostName == "odin") then
    #           [
    #             "openrgb -p Blue"
    #             "wpctl set-default 48"
    #           ]
    #         else
    #           [ ]
    #       );

    # env = [
    #   "GDK_BACKEND,wayland"
    #   "GTK_THEME,Adwaita:dark"
    #   "XCURSOR_SIZE,24"
    #   "HYPRCURSOR_SIZE,24"
    #   "HYPRCURSOR_THEME,Bibata-Modern-Classic"
    #   "QT_QPA_PLATFORM,wayland"
    #   # "QT_QPA_PLATFORMTHEME,adwaita" # "qt7ct"
    #   # "QT_QPA_PLATFORMTHEME_QT6,adwaita" # "qt6ct"
    #   "NIXOS_OZONE_WL,1"
    #   "GDK_DPI_SCALE,1.0"
    # ];
    #
    # input = {
    #   kb_layout = "us";
    #   kb_options = "ctrl:nocaps";
    #   follow_mouse = 1;
    #   mouse_refocus = false;
    #
    #   touchpad = {
    #     natural_scroll = true;
    #   };
    #
    #   sensitivity = 0; # -1.0 - 1.0, 0 means no modification.
    # };
    #
    # general = {
    #   gaps_in = 3;
    #   gaps_out = 4;
    #   border_size = 2;
    #   "$black" = "0xff0e1013";
    #   "$bgDark" = "0xff1E2127";
    #   "$bg0" = "0xff1f2329";
    #   "$bg1" = "0xff282c34";
    #   "$bg2" = "0xff30363f";
    #   "$bg3" = "0xff323641";
    #   "$bg_d" = "0xff181b20";
    #   "$bg_blue" = "0xff61afef";
    #   "$bg_yellow" = "0xffe8c88c";
    #   "$fg" = "0xffa0a8b7";
    #   "$fg_dark" = "0xffabb2bf";
    #   "$purple" = "0xffbf68d9";
    #   "$green" = "0xff8ebd6b";
    #   "$orange" = "0xffcc9057";
    #   "$blue" = "0xff4fa6ed";
    #   "$yellow" = "0xffe2b86b";
    #   "$cyan" = "0xff48b0bd";
    #   "$red" = "0xffe55561";
    #   "$grey" = "0xff535965";
    #   "$light_grey" = "0xff7a818e";
    #   "$dark_cyan" = "0xff266269";
    #   "$dark_red" = "0xff8b3434";
    #   "$dark_yellow" = "0xff835d1a";
    #   "$dark_purple" = "0xff7e3992";
    #   "$diff_add" = "0xff272e23";
    #   "$diff_delete" = "0xff2d2223";
    #   "$diff_change" = "0xff172a3a";
    #   "$diff_text" = "0xff274964";
    #
    #   "col.active_border" = "$blue";
    #   "col.inactive_border" = "$bg1";
    #   layout = "scrolling";
    #   # "dwindle"; "scrolling";
    # };
    #
    # group = {
    #   "$black" = "0xff0e1013";
    #   "$bgDark" = "0xff1E2127";
    #   "$bg0" = "0xff1f2329";
    #   "$bg1" = "0xff282c34";
    #   "$bg2" = "0xff30363f";
    #   "$bg3" = "0xff323641";
    #   "$bg_d" = "0xff181b20";
    #   "$bg_blue" = "0xff61afef";
    #   "$bg_yellow" = "0xffe8c88c";
    #   "$fg" = "0xffa0a8b7";
    #   "$fg_dark" = "0xffabb2bf";
    #   "$purple" = "0xffbf68d9";
    #   "$green" = "0xff8ebd6b";
    #   "$orange" = "0xffcc9057";
    #   "$blue" = "0xff4fa6ed";
    #   "$yellow" = "0xffe2b86b";
    #   "$cyan" = "0xff48b0bd";
    #   "$red" = "0xffe55561";
    #   "$grey" = "0xff535965";
    #   "$light_grey" = "0xff7a818e";
    #   "$dark_cyan" = "0xff266269";
    #   "$dark_red" = "0xff8b3434";
    #   "$dark_yellow" = "0xff835d1a";
    #   "$dark_purple" = "0xff7e3992";
    #   "$diff_add" = "0xff272e23";
    #   "$diff_delete" = "0xff2d2223";
    #   "$diff_change" = "0xff172a3a";
    #   "$diff_text" = "0xff274964";
    #   groupbar = {
    #     enabled = true;
    #     font_size = 16;
    #     height = 18;
    #     gradients = true;
    #     priority = 3;
    #     rounding = 0;
    #     round_only_edges = true;
    #     "col.active" = "$bg_d"; # active group background
    #     "col.inactive" = "$black"; # inactive group background
    #
    #     "text_color" = "$fg"; # ACTIVE text color
    #     "text_color_inactive" = "$bg2"; # inactive text color
    #   };
    #
    #   "col.border_active" = "$blue";
    #   "col.border_inactive" = "$bg1";
    # };
    #
    # decoration = {
    #   rounding = 10;
    #   active_opacity = 1.0;
    #   inactive_opacity = 1.0;
    #
    #   layerrule = [
    #     # "blur,waybar"
    #     # "ignorealpha 0.1,waybar"
    #     "no_anim on, match:class ^(walker)$"
    #     "no_screen_share on, match:class ^(Bitwarden)$"
    #   ];
    #
    #   blur = {
    #     enabled = true;
    #     size = 12;
    #     passes = 4;
    #     new_optimizations = true;
    #     ignore_opacity = true;
    #     xray = true;
    #     brightness = 1;
    #     noise = 1.0e-2;
    #     contrast = 1;
    #     popups = true;
    #     popups_ignorealpha = 0.6;
    #     input_methods = true;
    #     input_methods_ignorealpha = 0.8;
    #   };
    #
    #   shadow = {
    #     enabled = true;
    #     range = 30;
    #     render_power = 3;
    #     color = "0x66000000";
    #   };
    # };

    #      animations = {
    #        enabled = false;

    #        bezier = "myBezier, 0.05, 0.9, 0.1, 1.05";

    #        animation = [
    #          "windows, 1, 7, myBezier"
    #          "windowsOut, 1, 7, default, popin 80%"
    #          "border, 1, 10, default"
    #          "borderangle, 1, 8, default"
    #          "fade, 1, 7, default"
    #          "workspaces, 0, 7, default, fade"
    #          "windowsMove, 1, 6, default"
    #        ];
    #      };

    # dwindle = {
    #   # See https://wiki.hyprland.org/Configuring/Dwindle-Layout/ for more
    #   # pseudotile = true; # master switch for pseudotiling. Enabling is bound to mainMod + P in the keybinds section below
    #   preserve_split = true; # you probably want this
    # };
    #
    # master = {
    #   # See https://wiki.hyprland.org/Configuring/Master-Layout/ for more
    # };
    #
    # gesture = [
    #   "4,horizontal,workspace"
    #   "4,vertical,fullscreen"
    #   "3,right,dispatcher,movefocus,l"
    #   "3,left,dispatcher,movefocus,r"
    #
    # ];
    #
    # plugin = {
    #   hyprscrolling = {
    #     fullscreen_on_one_column = true;
    #     column_width = 0.99;
    #     explicit_column_widths = "0.5, 0.99";
    #   };
    #   # hyprexpo = {
    #   #   columns = 3;
    #   #   gap_size = 5;
    #   #   workspace_method =
    #   #     "first 1"; # [center/first] [workspace] e.g. first 1 or center m+1
    #   #   enable_gesture = true; # laptop touchpad, 4 fingers
    #   #   gesture_distance = 300; # how far is the "max"
    #   #   gesture_positive =
    #   #     false; # positive = swipe down. Negative = swipe up.
    #   #   skip_empty = true;
    #   # };
    # };

    # windowrule = [
    #   # --- Workspace rules ---
    #   "workspace 1, match:class ^(firefox)$"
    #   "workspace 1, match:class ^(brave-browser)$"
    #   "workspace 3, match:class ^(Proton Mail)$"
    #   "workspace 2, match:class ^(discord)$"
    #   "workspace 2, match:class ^(org.signal.Signal)$"
    #   "workspace 4, match:class ^(Alacritty)$"
    #   "workspace 4, match:class ^(kitty)$"
    #   "workspace 4, match:class ^(com.mitchellh.ghostty)$"
    #   "workspace 5, match:class ^(jetbrains-idea)$"
    #   "workspace 5, match:class ^(Code)$"
    #   "workspace 5, match:class ^(code-url-handler)$"
    #   "workspace 6, match:class ^(steam)$"
    #   "workspace 9, match:class ^(Cider)$"
    #   "workspace 10, match:class ^(BambuStudio)$"
    #
    #   # Brave app-mode windows
    #   "workspace 3, match:class ^(brave-gmail\\.com).*"
    #   "workspace 3, match:class ^(brave-mail\\.proton\\.me).*"
    #   "workspace 9, match:class ^(brave-chatgpt\\.com).*"
    #   "workspace 8, match:class ^(brave-music).*"
    #
    #   # --- Opacity (active inactive fullscreen) ---
    #   "opacity 1.0, match:class ^(firefox)$"
    #   "opacity 1.0, match:class ^(Alacritty)$"
    #   "opacity 1.0, match:class ^(kitty)$"
    #   "opacity 1.0, match:class ^(com.mitchellh.ghostty)$"
    #   "opacity 1.0, match:class ^(jetbrains-idea)$"
    #   "opacity 1.0, match:class ^(Code)$"
    #   "opacity 1.0, match:class ^(code-url-handler)$"
    #   "opacity 1.0, match:class ^(Cider)$"
    #   "opacity 1.0, match:class ^(dev.zed.Zed)$"
    #
    #   # --- Floating windows ---
    #   "float on, match:class ^(blueman-manager)$"
    #   "float on, match:class ^(nm-connection-editor)$"
    #   "float on, match:class ^(pavucontrol)$"
    #
    #   "no_anim on, match:class ^(walker)$"
    #   "no_dim on, match:class ^(walker)$"
    # ];
    # windowrulev2 = [
    #   "workspace 1,class:(firefox)"
    #   "workspace 1,class:(brave-browser)"
    #   "workspace 3,class:(Proton Mail)"
    #   "workspace 2,class:(discord)"
    #   "workspace 2,class:(org.signal.Signal)"
    #   "workspace 4,class:(Alacritty)"
    #   "workspace 4,class:(kitty)"
    #   "workspace 4,class:(com.mitchellh.ghostty)"
    #   "workspace 5,class:(jetbrains-idea)"
    #   "workspace 5,class:(Code)"
    #   "workspace 5,class:(code-url-handler)"
    #   "workspace 6,class:(steam)"
    #   "workspace 9,class:(Cider)"
    #   "workspace 10,class:(BambuStudio)"
    #   "workspace 3,class:^(brave-gmail.com).*"
    #   "workspace 3,class:^(brave-mail.proton.me).*"
    #   "workspace 9,class:^(brave-chatgpt.com).*"
    #   "workspace 8,class:^(brave-music).*"
    #
    #
    #   "opacity 1.0 override 1.0 override,class:^(firefox)$"
    #   "opacity 1.0 override 1.0 override,class:^(Alacritty)$"
    #   "opacity 1.0 override 1.0 override,class:^(kitty)$"
    #   "opacity 1.0 override 1.0 override,class:^(com.mitchellh.ghostty)$"
    #   "opacity 1.0 override 1.0 override,class:^(jetbrains-idea)$"
    #   "opacity 1.0 override 1.0 override,class:^(Code)$"
    #   "opacity 1.0 override 1.0 override,class:^(code-url-handler)$"
    #   "opacity 1.0 override 1.0 override,class:^(Cider)$"
    #   "opacity 1.0 override 1.0 override,class:^(dev.zed.Zed)$"
    #
    #   "float,class:^(blueman-manager)$"
    #   "float,class:^(nm-connection-editor)$"
    #   "float,class:^(pavucontrol)$"
    # ];

    #       scrolling = {
    #         column_width = 0.98;
    #         explicit_column_widths = "0.33,0.5,0.66,0.98";
    #       };
    #
    #       bind = [
    #         # "SUPER_L, O, hyprexpo:expo, toggle"
    #
    # #UPGRADE        ''SUPER_L CTRL_L ALT SHIFT, S, exec, hyprctl keyword general:layout "scrolling"''
    # #        ''SUPER_L CTRL_L ALT SHIFT, T, exec, hyprctl keyword general:layout "dwindle"''
    # #        "SUPER_L CTRL_L ALT SHIFT, E, exec, systemctl --user restart elephant.service"
    # #END UPGRADE
    #         # "SUPER_L, T, exec, ghostty"
    #         "SUPER_L, RETURN, exec, ghostty" # kitty" #alacritty"
    #         "SUPER_L, Q, killactive,"
    #         "SUPER_L, E, exec,  thunar"
    #         "SUPER_L, B, exec,  brave"
    #         "SUPER_L, G, togglefloating,"
    #
    #         # "SUPER_L, D, exec, ags -t launcher"
    #         # ",XF86PowerOff,  exec, ags -t powermenu"
    #         # "SUPER_L CTRL_L SHIFT, P, exec, ags -t powermenu"
    #         "SUPER_L, D, exec, walker"
    #         "SUPER_L CTRL_L ALT SHIFT, K, exec, $HOME/.config/walker/scripts/keybinds.sh"
    #
    #         "SUPER_L CTRL_L, W, exec, $HOME/.config/walker/scripts/windows.sh"
    #
    #         ",XF86PowerOff,  exec,  $HOME/.config/wlogout/scripts/wlogout.sh"
    #         "SUPER_L CTRL_L SHIFT, P, exec, $HOME/.config/wlogout/scripts/wlogout.sh"
    #
    #         "SUPER_L CTRL_L ALT SHIFT, C, exec, walker --provider clipboard"
    #
    #         ''SUPER_L CTRL_L SHIFT, I, exec, grim -g "$(slurp)"''
    #         '',Print, exec,  grim -g "$(slurp)"''
    #
    #         "SUPER_L CTRL_L ALT SHIFT, W, exec, systemctl --user restart epochshell"
    #         # "SUPER_L CTRL_L SHIFT, A, exec, ags -q && ags"
    #
    #         # Move focus with mainMod + arrow keys
    #         "SUPER_L, left, movefocus, l"
    #         "SUPER_L, right, movefocus, r"
    #         "SUPER_L, up, movefocus, u"
    #         "SUPER_L, down, movefocus, d"
    #
    #         "SUPER_L SHIFT, left, swapwindow, l"
    #         "SUPER_L SHIFT, right, swapwindow, r"
    #         "SUPER_L SHIFT, up, swapwindow, u"
    #         "SUPER_L SHIFT, down, swapwindow, d"
    #
    #         # "$ALT, period, togglegroup"
    #         # "SUPER_L ALT, left, changegroupactive, b"
    #         # "SUPER_L ALT, right, changegroupactive, f"
    #         # "SUPER_L SHIFT ALT, up, moveoutofgroup"
    #         # "SUPER_L SHIFT ALT, down, moveoutofgroup"
    #         # "SUPER_L SHIFT ALT, left, moveintogroup, l"
    #         # "SUPER_L SHIFT ALT, right, moveintogroup, r"
    #
    #         # "SUPER_L SHIFT, left, layoutmsg, swapcol l"
    #         # "SUPER_L SHIFT, right, layoutmsg, swapcol r"
    #         # "SUPER_L SHIFT, up, layoutmsg, movewindowto u"
    #         # "SUPER_L SHIFT, down, layoutmsg, movewindowto d"
    #         "SUPER_L SHIFT CTRL, left, movewindow, l"
    #         "SUPER_L SHIFT CTRL, right, movewindow, r"
    #         "SUPER_L, R, layoutmsg, colresize +conf"
    #         "ALT, period, layoutmsg, promote"
    #
    #         # "ALT, slash, togglesplit, " # dwindlehyprlahyprlahyprlahyprla
    #
    #         # Resize window
    #         # "SUPER_L CTRL_L, left, resizeactive, -10 0"
    #         # "SUPER_L CTRL_L, right, resizeactive, 10 0"
    #         # "SUPER_L CTRL_L, down, resizeactive, 0 -10"
    #         # "SUPER_L CTRL_L, up, resizeactive, 0 10"
    #
    #         #"SUPER_L, R, exec, ~/.config/hypr/resize.sh"
    #
    #         # Scroll through existing workspaces with mainMod + scroll
    #         "SUPER_L, mouse_down, movefocus, l"
    #         "SUPER_L, mouse_up, movefocus, r"
    #         "SUPER_L SHIFT, mouse_down, workspace, e+1"
    #         "SUPER_L SHIFT, mouse_up, workspace, e-1"
    #
    #         # Home Automations
    #         ''SUPER_L CTRL_L ALT_L SHIFT, L, exec, curl -X GET "https://home.semrad.net/api/webhook/-WaJcaS6CZ1F-V-0exl8Nuhmq"''
    #
    #         "SUPER_L SHIFT CTRL_L, M, exec,  wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
    #         "SUPER_L SHIFT CTRL_L, S, exec,  wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
    #         "SUPER_L, Tab, focuscurrentorlast,"
    #
    #         "SUPER_L,F,fullscreen"
    #
    #         "SUPER_L ALT CTRL_L, right, workspace, +1"
    #         "SUPER_L ALT CTRL_L, left, workspace, -1"
    #         "SUPER_L ALT CTRL_L SHIFT, right, movetoworkspace, +1"
    #         "SUPER_L ALT CTRL_L SHIFT, left, movetoworkspace, -1"
    #
    #         "SUPER_L, 0, workspace, 10"
    #         "SUPER_L SHIFT, 0, movetoworkspace, 10"
    #       ]
    #       ++ (
    #         # workspaces
    #         # binds SUPER_L + [shift +] {1..9} to [move to] workspace {1..9}
    #         builtins.concatLists (
    #           builtins.genList (
    #             x:
    #             let
    #               ws =
    #                 let
    #                   c = (x + 1) / 10;
    #                 in
    #                 builtins.toString (x + 1 - (c * 10));
    #             in
    #             [
    #               "SUPER_L, ${ws}, workspace, ${toString (x + 1)}"
    #               "SUPER_L SHIFT, ${ws}, movetoworkspace, ${toString (x + 1)}"
    #             ]
    #           ) 9
    #         )
    #       );
    #
    #       bindm = [
    #         "SUPER_L, mouse:272, movewindow"
    #         "SUPER_L CTRL_L, mouse:272, resizewindow"
    #       ];
    #
    #       binde = [
    #         ", XF86AudioMute, exec,  wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
    #         ", XF86MonBrightnessUp, exec, brightnessctl s 5%+"
    #         ", XF86MonBrightnessDown, exec, brightnessctl s 5%-"
    #         ", XF86AudioRaiseVolume, exec, wpctl set-volume -l 1.0 @DEFAULT_AUDIO_SINK@ 5%+"
    #       ];
    #       bindl = [
    #         ", XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
    #       ];
    #     };
    extraConfig = ''
            ----------------
      -- Variables  --
      ----------------

      local mainMod = "SUPER_L"

      local bg0 = 0xff1f2329
      local bg1 = 0xff282c34
      local bg2 = 0xff30363f
      local bg3 = 0xff323641
      local bgDark = 0xff1E2127
      local bg_blue = 0xff61afef
      local bg_d = 0xff181b20
      local bg_yellow = 0xffe8c88c
      local black = 0xff0e1013
      local blue = 0xff4fa6ed
      local cyan = 0xff48b0bd
      local dark_cyan = 0xff266269
      local dark_purple = 0xff7e3992
      local dark_red = 0xff8b3434
      local dark_yellow = 0xff835d1a
      local diff_add = 0xff272e23
      local diff_change = 0xff172a3a
      local diff_delete = 0xff2d2223
      local diff_text = 0xff274964
      local fg = 0xffa0a8b7
      local fg_dark = 0xffabb2bf
      local green = 0xff8ebd6b
      local grey = 0xff535965
      local light_grey = 0xff7a818e
      local orange = 0xffcc9057
      local purple = 0xffbf68d9
      local red = 0xffe55561
      local yellow = 0xffe2b86b

      ----------------
      -- Helpers    --
      ----------------

      local function trim(s)
        s = s or ""
        return (s:gsub("^%s+", ""):gsub("%s+$", ""))
      end

      local function hostname_from_file(path)
        local f = io.open(path, "r")
        if not f then
          return nil
        end
        local value = f:read("*l")
        f:close()
        return trim(value)
      end

      local function get_hostname()
        return hostname_from_file("/etc/hostname")
          or trim(os.getenv("HOSTNAME"))
          or trim(os.getenv("HOST"))
          or ""
      end

      local function exec(cmd)
        return hl.dsp.exec_cmd(cmd)
      end

      local function rule_name(prefix, value)
        local cleaned = value:gsub("[^%w]+", "-"):gsub("^-+", ""):gsub("-+$", "")
        if cleaned == "" then
          cleaned = "rule"
        end
        return prefix .. "-" .. cleaned
      end

      local function window_rule(match_class, effects, name)
        effects.name = name or rule_name("window", match_class)
        effects.match = { class = match_class }
        hl.window_rule(effects)
      end

      local function workspace_rule(workspace, match_class)
        window_rule(match_class, { workspace = tostring(workspace) }, rule_name("workspace-" .. tostring(workspace), match_class))
      end

      local function opacity_rule(match_class)
        window_rule(match_class, { opacity = "1.0" }, rule_name("opacity", match_class))
      end

      local function float_rule(match_class)
        window_rule(match_class, { float = true }, rule_name("float", match_class))
      end

      ----------------
      -- Monitors   --
      ----------------

      local hostname = get_hostname()

      if hostname == "thor" then
        hl.monitor({
          output = "eDP-1",
          mode = "preferred",
          position = "auto",
          scale = 1.333333,
          vrr = 1,
        })

        hl.monitor({
          output = "",
          mode = "preferred",
          position = "auto",
          scale = 1.0,
        })
      elseif hostname == "odin" then
        hl.monitor({
          output = "DP-3",
          mode = "3840x2560@60",
          position = "auto",
          scale = 1.333333,
          -- Original Nix comment kept here for HDR testing:
          -- bitdepth = 10,
          -- cm = "hdr",
          -- sdrbrightness = 1.5,
          -- sdrsaturation = 1.0,
        })

        hl.monitor({
          output = "",
          mode = "preferred",
          position = "auto",
          scale = 1,
        })
      else
        hl.monitor({
          output = "",
          mode = "preferred",
          position = "auto",
          scale = 1.0,
        })
      end

      ----------------
      -- Config     --
      ----------------

      hl.config({
        animations = {
          enabled = false,
        },

        decoration = {
          rounding = 10,
          active_opacity = 1.0,
          inactive_opacity = 1.0,

          blur = {
            brightness = 1,
            contrast = 1,
            enabled = true,
            ignore_opacity = true,
            input_methods = true,
            input_methods_ignorealpha = 0.8,
            new_optimizations = true,
            noise = 0.01,
            passes = 4,
            popups = true,
            popups_ignorealpha = 0.6,
            size = 12,
            xray = true,
          },

          shadow = {
            color = 0x66000000,
            enabled = true,
            range = 30,
            render_power = 3,
          },
        },

        dwindle = {
          preserve_split = true,
        },

        general = {
          border_size = 2,
          col = {
            active_border = blue,
            inactive_border = bg1,
          },
          gaps_in = 3,
          gaps_out = 4,
          layout = "scrolling",
        },

        group = {
          col = {
            border_active = blue,
            border_inactive = bg1,
          },
          groupbar = {
            col = {
              active = bg_d,
              inactive = black,
            },
            enabled = true,
            font_size = 16,
            gradients = true,
            height = 18,
            priority = 3,
            round_only_edges = true,
            rounding = 0,
            text_color = fg,
            text_color_inactive = bg2,
          },
        },

        input = {
          follow_mouse = 1,
          kb_layout = "us",
          kb_options = "ctrl:nocaps",
          mouse_refocus = false,
          sensitivity = 0,
          touchpad = {
            natural_scroll = true,
          },
        },

        -- Empty in your original config, kept as an explicit table so it is easy to edit later.
        master = {},

        misc = {
          disable_hyprland_logo = true,
        },

        render = {
          cm_auto_hdr = 1,
          cm_enabled = true,
        },

        scrolling = {
          column_width = 0.98,
          explicit_column_widths = "0.33, 0.5, 0.66, 0.98",
        },

        xwayland = {
          force_zero_scaling = true,
        },
      })

      ----------------
      -- Animations --
      ----------------

      hl.curve("myBezier", { type = "bezier", points = { { 0.05, 0.9 }, { 0.1, 1.05 } } })

      hl.animation({ leaf = "windows", enabled = true, speed = 7, bezier = "myBezier" })
      hl.animation({ leaf = "windowsOut", enabled = true, speed = 7, bezier = "default", style = "popin 80%" })
      hl.animation({ leaf = "border", enabled = true, speed = 10, bezier = "default" })
      hl.animation({ leaf = "borderangle", enabled = true, speed = 8, bezier = "default" })
      hl.animation({ leaf = "fade", enabled = true, speed = 7, bezier = "default" })
      hl.animation({ leaf = "workspaces", enabled = false, speed = 7, bezier = "default", style = "fade" })
      hl.animation({ leaf = "windowsMove", enabled = true, speed = 6, bezier = "default" })

      ----------------
      -- Layer rules --
      ----------------

      hl.layer_rule({
        name = "walker-no-anim",
        match = { namespace = "^(walker)$" },
        no_anim = true,
      })

      hl.layer_rule({
        name = "bitwarden-no-screen-share",
        match = { namespace = "^(Bitwarden)$" },
        no_screen_share = true,
      })

      ----------------
      -- Keybinds   --
      ----------------

      hl.bind("SUPER + CTRL + ALT + SHIFT + S", exec('hyprctl keyword general:layout "scrolling"'))
      hl.bind("SUPER + CTRL + ALT + SHIFT + T", exec('hyprctl keyword general:layout "dwindle"'))
      hl.bind("SUPER + CTRL + ALT + SHIFT + E", exec("systemctl --user restart elephant.service"))

      hl.bind("SUPER + RETURN", exec("ghostty"))
      hl.bind("SUPER + Q", hl.dsp.window.close())
      hl.bind("SUPER + E", exec("thunar"))
      hl.bind("SUPER + B", exec("brave"))
      hl.bind("SUPER + G", hl.dsp.window.float({ action = "toggle" }))
      hl.bind("SUPER + D", exec("walker"))
      --BROKEN hl.bind("SUPER + CTRL + ALT + SHIFT + K", exec("$HOME/.config/walker/scripts/keybinds.sh"))
      hl.bind("SUPER + CTRL + W", exec("walker --provider windows"))

      hl.bind("XF86PowerOff", exec("$HOME/.config/wlogout/scripts/wlogout.sh"))
      hl.bind("SUPER + CTRL + SHIFT + P", exec("$HOME/.config/wlogout/scripts/wlogout.sh"))
      hl.bind("SUPER + CTRL + ALT + SHIFT + C", exec("walker --provider clipboard"))
      hl.bind("SUPER + CTRL + ALT + SHIFT + W", exec("walker --provider windows"))
      hl.bind("SUPER + CTRL + SHIFT + I", exec('grim -g "$(slurp)"'))
      --hl.bind("Print", exec('grim -g "$(slurp)"'))
      --hl.bind("SUPER + CTRL + ALT + SHIFT + W", exec("systemctl --user restart epochshell"))

      hl.bind("SUPER + left", hl.dsp.focus({ direction = "l" }))
      hl.bind("SUPER + right", hl.dsp.focus({ direction = "r" }))
      hl.bind("SUPER + up", hl.dsp.focus({ direction = "u" }))
      hl.bind("SUPER + down", hl.dsp.focus({ direction = "d" }))

      hl.bind("SUPER + SHIFT + left", hl.dsp.window.swap({ direction = "l" }))
      hl.bind("SUPER + SHIFT + right", hl.dsp.window.swap({ direction = "r" }))
      hl.bind("SUPER + SHIFT + up", hl.dsp.window.swap({ direction = "u" }))
      hl.bind("SUPER + SHIFT + down", hl.dsp.window.swap({ direction = "d" }))

      hl.bind("SUPER + SHIFT + CTRL + left", hl.dsp.window.move({ direction = "l" }))
      hl.bind("SUPER + SHIFT + CTRL + right", hl.dsp.window.move({ direction = "r" }))

      hl.bind("SUPER + R", hl.dsp.layout("colresize +conf"))
      hl.bind("ALT + period", hl.dsp.layout("promote"))

      hl.bind("SUPER + mouse_down", hl.dsp.focus({ direction = "l" }))
      hl.bind("SUPER + mouse_up", hl.dsp.focus({ direction = "r" }))
      hl.bind("SUPER + SHIFT + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
      hl.bind("SUPER + SHIFT + mouse_up", hl.dsp.focus({ workspace = "e-1" }))

      hl.bind("SUPER + CTRL + ALT + SHIFT + L", exec('curl -X GET "https://home.semrad.net/api/webhook/-WaJcaS6CZ1F-V-0exl8Nuhmq"'))
      hl.bind("SUPER + SHIFT + CTRL + M", exec("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"))
      hl.bind("SUPER + SHIFT + CTRL + S", exec("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"))

      hl.bind("SUPER + Tab", hl.dsp.focus({ last = true }))
      hl.bind("SUPER + F", hl.dsp.window.fullscreen({ mode = "fullscreen", action = "toggle" }))

      hl.bind("SUPER + ALT + CTRL + right", hl.dsp.focus({ workspace = "+1" }))
      hl.bind("SUPER + ALT + CTRL + left", hl.dsp.focus({ workspace = "-1" }))
      hl.bind("SUPER + ALT + CTRL + SHIFT + right", hl.dsp.window.move({ workspace = "+1" }))
      hl.bind("SUPER + ALT + CTRL + SHIFT + left", hl.dsp.window.move({ workspace = "-1" }))

      for i = 1, 10 do
        local key = i % 10
        hl.bind("SUPER + " .. key, hl.dsp.focus({ workspace = i }))
        hl.bind("SUPER + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
      end

      hl.bind("XF86AudioMute", exec("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"), { repeating = true })
      hl.bind("XF86MonBrightnessUp", exec("brightnessctl s 5%+"), { repeating = true })
      hl.bind("XF86MonBrightnessDown", exec("brightnessctl s 5%-"), { repeating = true })
      hl.bind("XF86AudioRaiseVolume", exec("wpctl set-volume -l 1.0 @DEFAULT_AUDIO_SINK@ 5%+"), { repeating = true })
      hl.bind("XF86AudioLowerVolume", exec("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"), { locked = true })

      hl.bind("SUPER + mouse:272", hl.dsp.window.drag(), { mouse = true })
      hl.bind("SUPER + CTRL + mouse:272", hl.dsp.window.resize(), { mouse = true })

      ----------------
      -- Environment--
      ----------------

      hl.env("GDK_BACKEND", "wayland")
      hl.env("GTK_THEME", "Adwaita:dark")
      hl.env("XCURSOR_SIZE", "24")
      hl.env("HYPRCURSOR_SIZE", "24")
      hl.env("HYPRCURSOR_THEME", "Bibata-Modern-Classic")
      hl.env("QT_QPA_PLATFORM", "wayland")
      hl.env("NIXOS_OZONE_WL", "1")
      hl.env("GDK_DPI_SCALE", "1.0")

      ----------------
      -- Autostart  --
      ----------------

      hl.on("hyprland.start", function()
        hl.exec_cmd("systemctl --user restart --now hyprpaper.service")
        hl.exec_cmd("systemctl --user restart --now hyprpolkitagent.service")
        hl.exec_cmd("systemctl --user restart --now hypridle.service")
        hl.exec_cmd("systemctl --user restart --now elephant.service")
        hl.exec_cmd("systemctl --user restart --now epochshell")
        hl.exec_cmd("wl-paste --type text --watch cliphist -max-items 25 store")
        hl.exec_cmd("wl-paste --type image --watch cliphist -max-items 25 store")
      end)

      ----------------
      -- Gestures   --
      ----------------

      hl.gesture({ fingers = 4, direction = "horizontal", action = "workspace" })
      hl.gesture({ fingers = 4, direction = "vertical", action = "fullscreen" })
      hl.gesture({
        fingers = 3,
        direction = "right",
        action = function()
          hl.dispatch(hl.dsp.focus({ direction = "l" }))
        end,
      })
      hl.gesture({
        fingers = 3,
        direction = "left",
        action = function()
          hl.dispatch(hl.dsp.focus({ direction = "r" }))
        end,
      })

      ------------------
      -- Window rules --
      ------------------

      workspace_rule(1, "^(firefox)$")
      workspace_rule(1, "^(brave-browser)$")
      workspace_rule(3, "^(Proton Mail)$")
      workspace_rule(2, "^(discord)$")
      workspace_rule(2, "^(org.signal.Signal)$")
      workspace_rule(4, "^(Alacritty)$")
      workspace_rule(4, "^(kitty)$")
      workspace_rule(4, "^(com.mitchellh.ghostty)$")
      workspace_rule(5, "^(jetbrains-idea)$")
      workspace_rule(5, "^(Code)$")
      workspace_rule(5, "^(code-url-handler)$")
      workspace_rule(6, "^(steam)$")
      workspace_rule(9, "^(Cider)$")
      workspace_rule(10, "^(BambuStudio)$")
      workspace_rule(3, "^(brave-gmail\\.com).*")
      workspace_rule(3, "^(brave-mail\\.proton\\.me).*")
      workspace_rule(9, "^(brave-chatgpt\\.com).*")
      workspace_rule(8, "^(brave-music).*")

      opacity_rule("^(firefox)$")
      opacity_rule("^(Alacritty)$")
      opacity_rule("^(kitty)$")
      opacity_rule("^(com.mitchellh.ghostty)$")
      opacity_rule("^(jetbrains-idea)$")
      opacity_rule("^(Code)$")
      opacity_rule("^(code-url-handler)$")
      opacity_rule("^(Cider)$")
      opacity_rule("^(dev.zed.Zed)$")

      float_rule("^(blueman-manager)$")
      float_rule("^(nm-connection-editor)$")
      float_rule("^(pavucontrol)$")

      window_rule("^(walker)$", { no_anim = true }, "walker-no-anim-window")
      window_rule("^(walker)$", { no_dim = true }, "walker-no-dim-window")
      window_rule("^(Bitwarden)$", { no_screen_share = true }, "bitwarden-no-screen-share-window")
    '';
    xwayland = {
      enable = true;
    };
    systemd.enable = false; # NO longer using UWSM
  };

}
