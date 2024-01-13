{ config, pkgs, ... }:

{

  imports =
    [
      ./hyprpaper
      ./waybar
      ./swaylock
      ./wlogout
    ];

  home.pointerCursor = {
    gtk.enable = true;
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Classic";
    size = 22;
  };

  gtk = {
    enable = true;
    theme = {
      name = "Adwait:dark";
    };

    iconTheme = {
      package = pkgs.gnome.adwaita-icon-theme;
      name = "Adwaita";
    };

  };


  wayland.windowManager.hyprland = {
    enable = true;
    plugins = [
      #  (pkgs.callPackage ./hyprbars.nix { inherit hyprland-plugins; } )
    ];
    settings = { };
    extraConfig = ''
      # This is an example Hyprland config file.
      #
      # Refer to the wiki for more information.

      #
      # Please note not all available settings / options are set here.
      # For a full list, see the wiki
      #

      # See https://wiki.hyprland.org/Configuring/Monitors/
      #monitor=,preferred,auto,1.0
      monitor=,preferred,auto,1.175

      xwayland {
        force_zero_scaling = true
      }

      misc {
        disable_hyprland_logo = true
      }

      # See https://wiki.hyprland.org/Configuring/Keywords/ for more

      # Execute your favorite apps at launch
      #exec-once = pkill waybar & sleep 0.5 && waybar
      exec-once=waybar 
      exec-once=hyprpaper
      exec-once=swayidle -w
      exec-once=dunst
      #exec-once=bitwarden-desktop
      exec-once = wl-paste --type text --watch cliphist -max-items 25 store #Stores only text data
      exec-once = wl-paste --type image --watch cliphist -max-items 25 store #Stores only image data
      #exec-once=openrgb -p Arc
      #exec-once=/usr/lib/polkit-kde-authentication-agent-1

      # Some default env vars.
      #env = GDK_BACKEND,wayland
      env = GTK_THEME,Adwaita:dark
      env = XCURSOR_SIZE,22
      env = QT_QPA_PLATFORM,wayland
      env = QT_QPA_PLATFORMTHEME,qt5ct
      env = GDK_DPI_SCALE,1.175
      # For all categories, see https://wiki.hyprland.org/Configuring/Variables/
      input {
          kb_layout = us
          kb_variant Noto, JetBrainsMono Nerd Font
          kb_model =
          kb_rules =
          kb_options=ctrl:nocaps
          follow_mouse = 1

          touchpad {
              natural_scroll = true
          }

          sensitivity = 0 # -1.0 - 1.0, 0 means no modification.
      }

      general {
          # See https://wiki.hyprland.org/Configuring/Variables/ for more

          gaps_in = 1
          gaps_out = 2
          border_size = 3

          col.active_border = rgba(7EBAE4ff) rgba(5277C3ff) 45deg
          col.inactive_border = rgba(595959aa)

          layout = master
      }

      decoration {
          # See https://wiki.hyprland.org/Configuring/Variables/ for more

          rounding = 10
          active_opacity = 0.85
          inactive_opacity = 0.6

          blur {
              enabled = true
              size = 6
              passes = 3
              new_optimizations = true
              ignore_opacity = true
              xray = true
              noise = 0
              brightness = 0.60
          }
          drop_shadow = true
          shadow_range = 4
          shadow_render_power = 3
          #col.shadow = rgba(f67400ff)
          col.shadow = 3daee9ff) 
          col.shadow_inactive = rgba(595959aa)
      }

      # Blur for waybar 
      #blurls=waybar

      animations {
          enabled = true

          # Some default animations, see https://wiki.hyprland.org/Configuring/Animations/ for more

          bezier = myBezier, 0.05, 0.9, 0.1, 1.05

          animation = windows, 1, 7, myBezier
          animation = windowsOut, 1, 7, default, popin 80%
          animation = border, 1, 10, default
          animation = borderangle, 1, 8, default
          animation = fade, 1, 7, default
          animation = workspaces, 1, 7, default, fade
          animation = windowsMove, 1, 6, default
      }

      dwindle {
          # See https://wiki.hyprland.org/Configuring/Dwindle-Layout/ for more
          pseudotile = true # master switch for pseudotiling. Enabling is bound to mainMod + P in the keybinds section below
          preserve_split = true # you probably want this
      }

      master {
          # See https://wiki.hyprland.org/Configuring/Master-Layout/ for more
          new_is_master = true
      }

      gestures {
          # See https://wiki.hyprland.org/Configuring/Variables/ for more
          workspace_swipe = true
      }

      # Example per-device config
      # See https://wiki.hyprland.org/Configuring/Keywords/#executing for more
      device:epic-mouse-v1 {
          sensitivity = -0.5
      }

      # Example windowrule v1
      # windowrule = float, ^(kitty)$
      # Example windowrule v2
      windowrulev2 = workspace 1,class:(firefox)
      windowrulev2 = workspace 3,class:(Alacritty)
      windowrulev2 = workspace 3,class:(org.wezfurlong.wezterm)
      windowrulev2 = workspace 4,class:(jetbrains-idea)
      windowrulev2 = workspace 4,class:(Code)
      windowrulev2 = workspace 2,class:(discord)

      windowrulev2 = opacity 1.0 override 1.0 override,class:^(firefox)$
      windowrulev2 = opacity 0.9 override 0.9 override,class:^(jetbrains-idea)$

      windowrulev2 = float,class:^(blueman-manager)$
      windowrulev2 = float,class:^(nm-connection-editor)$
      windowrulev2 = float,class:^(pavucontrol)$ 
      # windowrulev2 = float,class:^(kitty)$,title:^(kitty)$
      # See https://wiki.hyprland.org/Configuring/Window-Rules/ for more


      # See https://wiki.hyprland.org/Configuring/Keywords/ for more
      $mainMod = ALT_L

      # Example binds, see https://wiki.hyprland.org/Configuring/Binds/ for more
      bind = $mainMod, T, exec, alacritty
      #bind = $mainMod, T, exec, wezterm
      bind = $mainMod, Q, killactive,
      #bind = $mainMod, M, exit,
      bind = $mainMod, E, exec, dolphin
      bind = $mainMod, G, togglefloating,
      bind = $mainMod, D, exec, fuzzel
      #$HOME/.config/rofi/bin/launcher
      bind = $mainMod, W, exec, $HOME/.config/rofi/bin/window
      bind = $mainMod CTRL_L SHIFT, P, exec, killall wlogout || wlogout -b 5 -m 500
      bind = $mainMod CTRL_L SHIFT, C, exec, $HOME/.config/rofi/bin/clipboard

      bind = $mainMod CTRL_L SHIFT, I, exec, grim -g "$(slurp)"

      bind = $mainMod CTRL_L SHIFT, N, exec, dunstctl close 
      #bind = $mainMod, R, exec, krunner
      bind = $mainMod, J, togglesplit, # dwindle
      bind = $mainMod SHIFT, W, exec, pkill waybar && waybar

      # Move focus with mainMod + arrow keys
      bind = $mainMod, left, movefocus, l
      bind = $mainMod, right, movefocus, r
      bind = $mainMod, up, movefocus, u
      bind = $mainMod, down, movefocus, d

      # Switch workspaces with mainMod + [0-9]
      bind = CTRL_L, 1, workspace, 1
      bind = CTRL_L, 2, workspace, 2
      bind = CTRL_L, 3, workspace, 3
      bind = CTRL_L, 4, workspace, 4
      bind = CTRL_L, 5, workspace, 5
      bind = CTRL_L, 6, workspace, 6
      bind = CTRL_L, 7, workspace, 7
      bind = CTRL_L, 8, workspace, 8
      bind = CTRL_L, 9, workspace, 9
      bind = CTRL_L, 0, workspace, 10

      # Move active window to a workspace with mainMod + SHIFT + [0-9]
      bind = $mainMod SHIFT, 1, movetoworkspace, 1
      bind = $mainMod SHIFT, 2, movetoworkspace, 2
      bind = $mainMod SHIFT, 3, movetoworkspace, 3
      bind = $mainMod SHIFT, 4, movetoworkspace, 4
      bind = $mainMod SHIFT, 5, movetoworkspace, 5
      bind = $mainMod SHIFT, 6, movetoworkspace, 6
      bind = $mainMod SHIFT, 7, movetoworkspace, 7
      bind = $mainMod SHIFT, 8, movetoworkspace, 8
      bind = $mainMod SHIFT, 9, movetoworkspace, 9
      bind = $mainMod SHIFT, 0, movetoworkspace, 10

      bind = $mainMod SHIFT, left, swapwindow, l
      bind = $mainMod SHIFT, right, swapwindow, r
      bind = $mainMod SHIFT, up, swapwindow, u
      bind = $mainMod SHIFT, down, swapwindow, d

      # Resize window
      bind = SUPER SHIFT, left, resizeactive, -160 0
      bind = SUPER SHIFT, right, resizeactive, 160 0
      bind = SUPER SHIFT, down, resizeactive, 0 -160
      bind = SUPER SHIFT, up, resizeactive, 0 160

      # Scroll through existing workspaces with mainMod + scroll
      bind = $mainMod, mouse_down, workspace, e+1
      bind = $mainMod, mouse_up, workspace, e-1

      # Move/resize windows with mainMod + LMB/RMB and dragging
      bindm = $mainMod, mouse:272, movewindow
      bindm = $mainMod CTRL_L, mouse:272, resizewindow

      binde=, XF86AudioRaiseVolume, exec, wpctl set-volume -l 1.0 @DEFAULT_AUDIO_SINK@ 5%+ && dunstify -h int:value:"$(pamixer --get-volume)" -i ~/.config/dunst/assets/volume.png -t 500 -r 2593 "Volume: $(pamixer --get-volume) %" 
      bindl=, XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%- && dunstify -h int:value:"$(pamixer --get-volume)" -i ~/.config/dunst/assets/volume.png -t 500 -r 2593 "Volume: $(pamixer --get-volume) %" 

      binde=, XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle && dunstify -i ~/.config/dunst/assets/$(pamixer --get-mute | grep -q "true" && echo "volume-mute.png" || echo "volume.png") -t 500 -r 2593 "Toggle Mute"

      binde=, XF86MonBrightnessUp, exec, brightnessctl s 5%+ && dunstify -h int:value:"$(( ($(cat /sys/class/backlight/*/brightness) * 100) / $(cat /sys/class/backlight/*/max_brightness) ))"  -i ~/.config/dunst/assets/brightness.svg -t 500 -r 2593 "Brightness: $(( ($(cat /sys/class/backlight/*/brightness) * 100) / $(cat /sys/class/backlight/*/max_brightness) ))%" 

      binde=, XF86MonBrightnessDown, exec, brightnessctl s 5%- && dunstify -h int:value:"$(( ($(cat /sys/class/backlight/*/brightness) * 100) / $(cat /sys/class/backlight/*/max_brightness) ))"  -i ~/.config/dunst/assets/brightness.svg -t 500 -r 2593 "Brightness: $(( ($(cat /sys/class/backlight/*/brightness) * 100) / $(cat /sys/class/backlight/*/max_brightness) ))%" 
      bind = $mainMod SHIFT CTRL_L, M, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle
      bind = $mainMod SHIFT CTRL_L, S, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
      bind= ALT, Tab, focuscurrentorlast,
      #bind = ALT, Tab, cyclenext

      bind = SUPER,F,fullscreen
      bind = $mainMod, F, fullscreen,1
    '';
    xwayland = { enable = true; };
    systemd.enable = true;
  };
}
