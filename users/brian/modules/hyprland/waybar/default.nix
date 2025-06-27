{

  home.file.".config/waybar/scripts/recorder.sh" = {
    source = ./scripts/recorder.sh;
    executable = true;
  };

  programs.waybar = {
    enable = true;
    # package = inputs.waybar.packages.${pkgs.system}.waybar;
    settings = {
      mainBar = {
        spacing = 0;
        layer = "top";
        gtk-layer-shell = true;
        margin-top =  0; #5;
        margin-left = 0; #10;
        margin-right = 0; #10;
        margin-bottom = 5;
        modules-left = [
          "hyprland/workspaces"
        ];
        modules-center = [          
          #"hyprland/window"
        ];
        modules-right = [
          #"custom/recorder"
          "custom/clipboard"
          "bluetooth"
          "network"
          "pulseaudio#sink"
          "pulseaudio#source"
          "battery"
          "clock"
        ];
        "wlr/taskbar" = {
          "format" = "{icon}";
          "icon-size" = 14;
          "tooltip-format" = "{title}";
          "on-click" = "activate";
          "on-click-middle" = "close";
        };
        "custom/launcher" = {
          format = "{icon}";
          "icon-size" = 22;
          format-icons = [
            ""
          ];
          "on-click" = "$HOME/.config/rofi/scripts/launcher.sh";
        };
        "custom/sep" = {
          "format" = "|";
        };
        "custom/space" = {
          "format" = " ";
        };
        "hyprland/window" = {
          "format" = "{title}";
          "max-length" = 50;
          "separate-outputs" = true;
        };
        "custom/clipboard" = {
          format = "{icon}";
          format-icons = {
            "default" = "󰨸";
          };
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
          "on-click" = "wf-recorder -f $(xdg-user-dir VIDEOS)/$(date +'recording_%Y-%m-%d-%H%M%S.mp4')";
          "on-click-right" = "pkill --signal SIGINT wf-recorder";
          "escape" = true;
        };
        "custom/session" = {
          format = "{icon}";
          format-icons = {
            "default" = "󰐥 ";
          };
          "toolip" = false;
          "on-click" = "killall wlogout || wlogout -b 5 -m 500";
        };
        "backlight" = {
          format = "{icon}";
          format-icons = [
            ""
          ];
          "tooltip-format" = "{icon}  {percent}%";
        };
        "hyprland/workspaces" = {
          "all-outputs" = false;
          "active-only" = false;
          "on-click" = "activate";
          "format" = "{icon}";
          "persistent-workspaces" = {
            "*" = 2;
          };
          format-icons = {
            "1" = "1";
            "2" = "2";
            "3" = "3";
            "4" = "4";
            "5" = "5";
            "6" = "6";
            "7" = "7";
            "8" = "8";
            "9" = "9";
            "10" = "10";
          };
          "sort-by-number" = true;
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
          "tooltip-format" = "<big>{:%a %b %d}</big>\n<tt><small>{calendar}</small></tt>";
        };
        "cpu" = {
          "format" = "  {usage}%";
        };
        "temperature" = {
          "format" = " HEEH {temperatureC}°C";
        };
        "memory" = {
          "format" = "  {}%";
        };
        "bluetooth" = {
          "format" = "󰂯";
          "format-disabled" = "󰂲";
          "format-connected" = "󰂱";
          "tooltip-format" = "Devices connected: {num_connections}";
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
          "format-icons" = [
            ""
            ""
            ""
            ""
            ""
          ];
        };
        "battery#bat2" = {
          "bat" = "BAT2";
        };
        "network" = {
           "format-icons" = [
            "󰤯"
            "󰤟"
            "󰤢"
            "󰤥"
            "󰤨"
          ];
          "family" = "ipv4";
          "format" = "{icon}";
          "format-wifi" = "{icon}";
          "format-ethernet" = "";
          "format-disconnected" = "󰖪";
          "tooltip-format-wifi" = "{essid} {ipaddr} ({frequency} GHz)\n⇣{bandwidthDownBytes}  ⇡{bandwidthUpBytes}";
          "tooltip-format-ethernet" = "{ipaddr} ⇣{bandwidthDownBytes}  ⇡{bandwidthUpBytes}";
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
          "tooltip-format" = "{desc}\n{volume}%";
          "format-icons" = {
            "headphone" = "";
            "hands-free" = "";
            "headset" = "";
            "phone" = "";
            "portable" = "";
            "car" = "";
            "default" = [
              ""
              ""
              ""
            ];
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
              font-family: Hack Nerd Font;
              font-size: 16px;
            }

            window {
            }

            window#waybar {
              background-color: rgba(14, 16, 19, 1.0);
              transition-property: background-color;
              transition-duration: 0.5s;
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

            #workspaces {
              background: transparent;
            }

            #workspaces button {
                background: transparent;
                color: @fg_dark;
                font-weight: bold;
                border: none;
            }

            #workspaces button:hover {
                color: @text;
                background: transparent;
            }

            #workspaces button.active {
              color: #FFFFFF;
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

            #custom-session {
              color: @text;
              font-size: 18px;
            }

            #window {
              color: @fg_dark;
            }

            #clock {
              margin-right: 10px;
            }

            #pulseaudio,
            #wireplumber,
            #battery,
            #custom-clipboard,
            #custom-menu,
            #backlight,
            #idle_inhibitor,
            #network,
            #clock,
            #tray,
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
    '';
  };
}
