{ osConfig, inputs, pkgs, ... }: {

  home.file.".config/waybar/scripts/recorder.sh" = {
    source = ./scripts/recorder.sh;
    executable = true;
  };

  programs.waybar = {
    enable = true;
    systemd.enable = true;
    # package = inputs.waybar.packages.${pkgs.system}.waybar;
    settings = {
      mainBar = {
        spacing = 0;
        layer = "top";
        gtk-layer-shell = true;
        margin-top = 0; # 5;
        margin-left = 0; # 10;
        margin-right = 0; # 10;
        margin-bottom = 2;
        modules-left =
          [ "group/launcher" "hyprland/workspaces" "niri/workspaces" ];
        modules-center = [ "hyprland/window" ];
        modules-right = [
          #"custom/recorder"
          #"custom/clipboard"
          # "group/expand"
          #"bluetooth"
          "network"
          # "pulseaudio#sink"
          #"pulseaudio#source"
        ] ++ (if (osConfig.networking.hostName == "thor") then [
          "battery"
          "group/settings"
          "clock"
        ] else [
          "group/settings"
          "clock"
        ]);
        "group/launcher" = {
          "orientation" = "inherit";
          "drawer" = {
            "children-class" = "launcheritems";
            "transition-duration" = 500;
            "transition-left-to-right" = true;
          };
          "modules" = [
            "custom/launcher"
            "custom/lock"
            "custom/reboot"
            "custom/shutdown"
            "custom/logout"
            "custom/suspend"
          ];
        };
        "custom/expand" = {
          "format" = "";
          "tooltip" = false;
        };
        "custom/endpoint" = {
          "format" = "";
          "tooltip" = false;
        };
        "custom/settings" = {
          "format" = "";
          "tooltip" = false;
        };
        "group/settings" = {
          "orientation" = "inherit";
          "drawer" = {
            "transition-duration" = 500;
            "transition-left-to-right" = false;
          };
          "modules" = [
            "custom/settings"
            "custom/endpoint"
            #          "custom/backlight"
            #"backlight/slider"
            "pulseaudio#sink"
            "pulseaudio/slider"
            "pulseaudio#source"
            "custom/clipboard"
            "tray"
            "bluetooth"
          ];
        };
        "pulseaudio/slider" = {
          "min" = 0;
          "max" = 100;
          "orientation" = "horizontal";
        };
        "backlight/slider" = {
          "min" = 0;
          "max" = 100;
          "orientation" = "horizontal";
        };
        "custom/backlight" = { "format" = ""; };
        "custom/lock" = {
          "format" = "";
          "on-click" = "hyprlock";
          "tooltip-format" = "Lock";
        };
        "custom/reboot" = {
          "format" = "";
          "on-click" = "systemctl reboot";
          "tooltip-format" = "Reboot";
        };
        "custom/shutdown" = {
          "format" = "";
          "on-click" = "systemctl poweroff";
          "tooltip-format" = "Shutdown";
        };
        "custom/logout" = {
          "format" = "󰗽";
          "on-click" = "hyprctl dispatch exit 0";
          "tooltip-format" = "Logout";
        };
        "custom/suspend" = {
          "format" = "󰤄";
          "on-click" = "systemctl suspend";
          "tooltip-format" = "Sleep";
        };
        "group/expand" = {
          "orientation" = "inherit";
          "drawer" = {
            "transition-duration" = 500;
            "transition-left-to-right" = false;
          };
          "modules" =
            [ "custom/expand" "custom/endpoint" "tray" "custom/clipboard" ];
        };
        "wlr/taskbar" = {
          "format" = "{icon}";
          "icon-size" = 14;
          "tooltip-format" = "{title}";
          "on-click" = "activate";
          "on-click-middle" = "close";
        };
        "custom/launcher" = {
          format = "{icon}";
          "icon-size" = 24;
          format-icons = [ "󰀻" ];
          "tooltip-format" = "Applications";
          #format-icons = [ "" ];
          "on-click" = "$HOME/.config/rofi/scripts/launcher.sh";
        };
        "custom/sep" = { "format" = "|"; };
        "custom/space" = { "format" = " "; };
        "hyprland/window" = {
          "format" = "{title}";
          "max-length" = 50;
          "separate-outputs" = true;
        };
        "custom/clipboard" = {
          format = "{icon}";
          format-icons = { "default" = "󰨸"; };
          "on-click" = "$HOME/.config/rofi/scripts/clipboard.sh";
          "on-click-right" = "cliphist wipe";
        };
        "custom/notification" = {
          "tooltip" = true;
          format = " {icon} ";
          format-icons = {
            "notification" = "";
            "none" = "";
            "dnd-notification" = "";
            "dnd-none" = "";
          };
          "return-type" = "json";
          "exec-if" = "which swaync-client";
          "exec" = "swaync-client -swb";
          "on-click" = "swaync-client -t -sw";
          "on-click-right" = "swaync-client -d -sw";
          "escape" = true;
        };
        "custom/recorder" = {
          "format" = "{}";
          "exec" = "$HOME/.config/waybar/scripts/recorder.sh";
          "return-type" = "json";
          "signal" = 12;
          "interval" = 5;
          "on-click" =
            "wf-recorder -f $(xdg-user-dir VIDEOS)/$(date +'recording_%Y-%m-%d-%H%M%S.mp4')";
          "on-click-right" = "pkill --signal SIGINT wf-recorder";
          "escape" = true;
        };
        "custom/session" = {
          format = "{icon}";
          format-icons = { "default" = "󰐥 "; };
          "toolip" = false;
          "on-click" = "killall wlogout || wlogout -b 5 -m 500";
        };
        "backlight" = {
          format = "{icon}";
          format-icons = [ "" ];
          "tooltip-format" = "{icon}  {percent}%";
        };
        "hyprland/workspaces" = {
          "all-outputs" = false;
          "active-only" = false;
          "on-click" = "activate";
          #"format" = "{id}";
          "format" = "{icon} {id}";
          "show-special" = true;
          "persistent-workspaces" = { "*" = 2; };
          format-icons = {
            "default" = "";
            "active" = "";
            #"1" = "1";
            # "2" = "2";
            #"3" = "3";
            #"4" = "4";
            #"5" = "5";
            #"6" = "6";
            #"7" = "7";
            #"8" = "8";
            #"9" = "9";
            #"10" = "10";
          };
          "sort-by-number" = true;
        };
        "niri/workspaces" = {
          "all-outputs" = false;
          "current-only" = false;
          "format" = "{icon}";
          format-icons = {
            #"default" = "";
            #"active" = "";
            "browser" = "";
            "chat" = "󰭻";
            "email" = "󰇮";
            "terminal" = "";
            "ide" = "";
            "games" = "󰓓";
            "music" = "";
            "3dprint" = "󰐫";
          };
        };
        "tray" = {
          "icon-size" = 16;
          "spacing" = 15;
        };
        "clock" = {
          # "format" = "{:%a %b %d, %G %I:%M %p} ";
          #        "format" = "{:%a %b %d %I:%M %p} ";
          "format" = "{:%a %I:%M %p} ";
          "interval" = 60;
          "tooltip-format" = ''
            <big>{:%a %b %d}</big>
            <tt><small>{calendar}</small></tt>'';
        };
        "cpu" = { "format" = "  {usage}%"; };
        "temperature" = { "format" = " HEEH {temperatureC}°C"; };
        "memory" = { "format" = "  {}%"; };
        "bluetooth" = {
          "format" = "󰂯";
          "format-disabled" = "󰂲";
          "format-connected" = "󰂱 {status}";
          "tooltip-format" = ''
            Devices connected: 
            {device_enumerate}'';
          "tooltip-format-enumerate-connected" = "{device_alias}";
          "on-click" = "GTK_THEME=Adwaita-dark blueman-manager";
          "justify" = "center";
        };
        "battery" = {
          "states" = {
            "good" = 95;
            "warning" = 30;
            "critical" = 15;
          };
          "format" = "{icon}";
          "format-charging" = "󰂄";
          "format-plugged" = " ";
          #"format-alt" = "{icon} {time}";
          "tooltip-format" = "{capacity}%, {time}";
          "format-icons" = [ "" "" "" "" "" ];
        };
        "battery#bat2" = { "bat" = "BAT2"; };
        "network" = {
          "format-icons" = [ "󰤯" "󰤟" "󰤢" "󰤥" "󰤨" ];
          "family" = "ipv4";
          "format" = "{icon}";
          "format-wifi" = "{icon}";
          "format-ethernet" = "";
          "format-disconnected" = "󰖪";
          "tooltip-format-wifi" = ''
            {essid} {ipaddr} ({frequency} GHz)
            ⇣{bandwidthDownBytes}  ⇡{bandwidthUpBytes}'';
          "tooltip-format-ethernet" =
            "{ipaddr} ⇣{bandwidthDownBytes}  ⇡{bandwidthUpBytes}";
          "tooltip-format-disconnected" = "Disconnected";
          "interval" = 3;
          "nospacing" = 1;
          "on-click-right" = "nm-connection-editor";
          "on-click" = "$HOME/.config/rofi/scripts/networkmanager.sh";
        };
        "pulseaudio#sink" = {
          "format" = "{icon}";
          "format-bluetooth" = "{icon}";
          "format-bluetooth-muted" = "";
          "format-muted" = "";
          "format-source" = "{volume}% ";
          "tooltip-format" = ''
            {desc}
            {volume}%'';
          "format-icons" = {
            "headphone" = "";
            "hands-free" = "";
            "headset" = "";
            "phone" = "";
            "portable" = "";
            "car" = "";
            "default" = [ "" "" "" ];
          };
          "on-click" = "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
          "on-click-right" = "pavucontrol";
        };
        "pulseaudio#source" = {
          "format" = "{format_source}";
          "format-source" = "";
          "format-source-muted" = "";
          "on-click" = "wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle";
          "on-click-right" = "pavucontrol";
          "on-scroll-up" = "wpctl set-volume -l 1.0 @DEFAULT_AUDIO_SOURCE@ 5%+";
          "on-scroll-down" = "wpctl set-volume @DEFAULT_AUDIO_SOURCE@ 5%-";
          "scroll-step" = 5;
        };
        "custom/media" = {
          "format" = "{icon} {}";
          "return-type" = "json";
          "max-length" = 40;
          "format-icons" = {
            "spotify" = "";
            "default" = "🎜";
          };
        };
      };
    };
    style = ''
                  @define-color black        #0e1013; /* rgba(14, 16, 19, 1) */
                  @define-color bgDark       #1E2127; /* rgba(30, 33, 39, 1) */
      	    @define-color bg0          #1f2329;
      	    @define-color bg1          #282c34;
      	    @define-color bg2          #30363f;
      	    @define-color bg3          #323641;
      	    @define-color bg_d         #181b20;
      	    @define-color bg_blue      #61afef;
      	    @define-color bg_yellow    #e8c88c;
      	    @define-color fg           #a0a8b7;
                  @define-color fg_dark      #abb2bf;
      	    @define-color purple       #bf68d9;
      	    @define-color green        #8ebd6b;
      	    @define-color orange       #cc9057;
      	    @define-color blue         #4fa6ed;
      	    @define-color yellow       #e2b86b;
      	    @define-color cyan         #48b0bd;
      	    @define-color red          #e55561;
      	    @define-color grey         #535965;
      	    @define-color light_grey   #7a818e;
      	    @define-color dark_cyan    #266269;
      	    @define-color dark_red     #8b3434;
      	    @define-color dark_yellow  #835d1a;
      	    @define-color dark_purple  #7e3992;
      	    @define-color diff_add     #272e23;
                  @define-color diff_delete  #2d2223;
                  @define-color diff_change  #172a3a;
      	    @define-color diff_text    #274964;

                  * {
                    font-family: JetbrainsMono Nerd Font Propo; /*Hack Nerd Font;*/
                    font-size: 16px;
                  }

                  window {
                  }

                  window#waybar {
                    background-color: rgba(0, 0, 0, 1.0);
                    /*background-color: rgba(14, 16, 19, 1.0);*/
                    transition-property: background-color;
                    transition-duration: 0.5s;
                    /*border-bottom: 2px solid @bg1;*/
                  }

                  .modules-right {
                    background: transparent;
                  }

                  .modules-center {
                    background: transparent;
                  }

                  .modules-left {
                    background: transparent;
                  }

                  tooltip {
                    background-color: @black;
                    border: 2px solid @bg1;
                    color: @fg_dark;
                    border-radius: 10px;
                  }
                  
                  tooltip label {
                    color: @fg_dark;
                  }

                  #custom-session {
                    font-size: 16px;
                  }

                  #custom-launcher {
                    min-width: 13px;
                    margin-left: 10px;
                    margin-right: 15px;
                    font-size: 16px;
                  }

                  #launcher {
                    margin-left: 10px;
                  }


                 /* #custom-launcher {
                    background: @black;
                    margin: 0px 10px 0px 0px;
                    padding: 0px 35px 0px 15px;
                    border-radius: 0px 0px 40px 0px;
                   font-size: 16px;
                  } */

                 /* #launcher {
                    background: @black;
                    margin-right: 5px;
                    padding: 0px 10px 0px 10px;
                    border-radius: 0px 0px 40px 0px;
                    font-size: 16px;
                  } */


                  #workspaces {
                    margin-left: 10px;
                    background: transparent;
                  }

                  #workspaces button {
                      background: transparent;
                      color: @fg_dark;
                      font-weight: bold;
                      border: none;
                  }

                  #workspaces button:hover {
                      color: @fg;
                      font-weight: bold;
                      border: none;
                      background: transparent;
                  }

                  #workspaces button.active {
                    color: @fg; /*fg*/
                    background: transparent;
                  }

                  #taskbar button {
                    background: transparent;
                    border: none;
                  }

                  #taskbar button.active {
                    background: transparent;
                  }

                  button.urgent {
                      color: @red;
                      background: @black;
                      border-radius: 10px;
                  }

                  #custom-sep {
                    color: @black;
                  }

                  #window {
                    color: @fg_dark;
                  }

                  #pulseaudio.sink,
                  #custom-backlight {
                    color: @fg_dark;
                    min-width: 13px;
                    padding: 0px 1px 0px 1px;
                  }


                  #pulseaudio.source,
                  #wireplumber,
                  #battery,
                  #custom-clipboard,
                  #custom-menu,
                  #backlight,
                  #idle_inhibitor,
                  #network,
                  #clock,
                  #tray,
                  #custom-settings,
                  #custom-expand,
                  #custom-lock,
                  #custom-reboot,
                  #custom-shutdown,
                  #custom-suspend,
                  #custom-logout,
                  #custom-endpoint,
                  #custom-session,
                  #custom-recorder,
                  #bluetooth,
                  #cpu,
                  #disk,
                  #memory,
                  #temperature {
                    color: @fg_dark;
                    min-width: 13px;
                    margin-right: 10px;
                    padding: 0px 5px 0px 5px;
                  }

                  #bluetooth.connected {
                    color: @green;
                  }

                  #battery.warning:not(.charging) {
                    color: @orange;
                  }
                  
                  #battery.critical:not(.charging) {
                    color: @red;
                  }

                  #custom-recorder.enabled {
                    color: @green;
                  }

                  #pulseaudio-slider slider {
                    min-height: 0px;
                    min-width: 0px;
                    opacity: 0;
                    background-image: none;
                    border: none;
                    box-shadow: none;
                 }
                #pulseaudio-slider trough {
                  min-height: 10px;
                  min-width: 80px;
                  border-radius: 5px;
                  background-color: @bg3;
                }
                #pulseaudio-slider highlight {
                  min-width: 10px;
                  border-radius: 5px;
                  background-color: @fg;
                }
                #backlight-slider slider {
                  min-height: 0px;
                  min-width: 0px;
                  opacity: 0;
                  background-image: none;
                  border: none;
                  box-shadow: none;
                }
                #backlight-slider trough {
                  min-height: 10px;
                  min-width: 80px;
                  border-radius: 5px;
                  background-color: @bg3;
                }
                #backlight-slider highlight {
                  min-width: 10px;
                  border-radius: 5px;
                  background-color: @fg;
                }
    '';
  };
}
