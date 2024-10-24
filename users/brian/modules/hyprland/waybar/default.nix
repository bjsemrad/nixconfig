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
          "hyprland/window"
          # "wlr/taskbar"
        ];
        modules-center = [          
          "cpu"
          "memory"
        ];
        modules-right = [
          "tray"
          "custom/recorder"
          "custom/clipboard"
          "pulseaudio#sink"
          "pulseaudio#source"
          "network"
          "bluetooth"
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
          "format" = "{:%a %b %d %I:%M %p} ";
          "interval" = 60;
          "tooltip-format" = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
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
          "format" = "";
          "format-disabled" = "";
          "format-connected" = "";
          "tooltip-format" = "{status} {device_alias}";
          "tooltip-format-connected" = " {device_enumerate}";
          "tooltip-format-enumerate-connected" = "{device_alias}";
          "on-click" = "blueman-manager";
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
          "format-alt" = "{icon} {time}";
          "tooltip-format" = "{capacity}%, {time}";
          "format-icons" = [
            "  "
            "  "
            "  "
            "  "
            "  "
          ];
        };
        "battery#bat2" = {
          "bat" = "BAT2";
        };
        "network" = {
          "format-wifi" = "";
          "format-ethernet" = "";
          "format-disconnected" = "";
          "tooltip-format-wifi" = " {ifname} @ {essid}\nIP: {ipaddr}\nStrength: {signalStrength}%\nFreq: {frequency}MHz\n⬆️ {bandwidthUpBits} ⬇️ {bandwidthDownBits}";
          "tooltip-format-ethernet" = "  {ifname}\nIP: {ipaddr}\n⬆️ {bandwidthUpBits} ⬇️ {bandwidthDownBits}";
          "format-linked" = "{ifname} (No IP)";
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
            @define-color base            #191724;
            @define-color surface         #1f1d2e;
            @define-color overlay         #26233a;

            @define-color muted           #6e6a86;
            @define-color subtle          #908caa;
            @define-color text            #e0def4;

            @define-color love            #eb6f92;
            @define-color gold            #f6c177;
            @define-color rose            #ebbcba;
            @define-color pine            #31748f;
            @define-color foam            #9ccfd8;
            @define-color iris            #c4a7e7;

            @define-color highlightLow    #21202e;
            @define-color highlightMed    #403d52;
            @define-color highlightHigh   #524f67;

            * {
              font-family: JetBrainsMono Nerd Font;
              /*font-weight: bold; */
              font-size: 16px;
            }

            window {
            }

            window#waybar {
              background-color: rgba(17, 17, 17, 1.0);
              /*background-color: rgba(11, 10, 16, 1.0);*/
              transition-property: background-color;
              transition-duration: 0.5s;
              /*border-radius: 5px;*/
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
              background-color: @surface;
              border: 2px solid #0b0a10;
              color: @text;
              border-radius: 10px;
            }

            #workspaces {
              background: transparent;
            }

            #workspaces button {
                background: transparent;
                color: @subtext0;
                font-weight: bold;
                border: none;
            }

            #workspaces button:hover {
                color: @text;
                background: transparent;
            }

            #workspaces button.active {
              color: @white;
              background: transparent;
            }

            #workspaces button.focused {
              color: @crust;
            }

            #taskbar button {
              background: transparent;
              border: none;
            }

            #taskbar button.active {
              background: transparent;
            }

            button.urgent {
                color: #11111b;
                background: #fab387;
                border-radius: 10px;
            }

            #cpu, #disk, #memory, #temperature {
              padding-right: 10px;
            }

            #custom-sep {
              color: #313244;
            }

            #custom-session {
              color: #FFFFFF;
              font-size: 18px;
              margin-right: 10px;
            }

            #window {
              color: #FFFFFF;
            }

            #clock {
              color: @white;
              margin-right: 10px;
            }

            #tray {
              color: @white;
              padding-right: 10px;
              padding-left: 10px;
            }

            #battery {
              padding-right: 5px;
              color: @white;
            }

            #pulseaudio,
            #wireplumber,
            #custom-clipboard,
            #custom-menu,
            #backlight,
            #idle_inhibitor,
            #network,
            #bluetooth {
              color: @white;
              padding-right: 10px;
              padding-left: 10px; 
            }

            #network.disconnected {
              color: @white;
              padding-right: 10px;
            }
            
            #network.disabled {
              color: @red;
              padding-right: 10px;
            }
            
            #pulseaudio.muted {
             padding-right: 10px;
            }

            #pulseaudio {
              padding-right: 10px;
            }
            
            #battery.charging {
              color: @white;
            }
            
            #battery.warning:not(.charging) {
              color: @orange;
            }
            
            #battery.critical:not(.charging) {
              color: @red;
            }

            #custom-recorder {
              padding-right: 10px;
              padding-left: 10px;
            }

            #custom-recorder.enabled {
              padding-right: 10px;
              padding-left: 10px;
      	      color:#c9545d;
            }
    '';
  };
}
