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
          "wlr/taskbar"
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
            @define-color base   #3b4045;/*rgba(30,30,46, 0.8);*/ /*#1e1e2e;*/
            @define-color mantle #31363b;
            @define-color crust  rgba(11, 10, 16, 0.95); /*#232629;*/

            @define-color text     #fcfcfc;
            @define-color subtext0 #a6adc8;
            @define-color subtext1 #bac2de;

            @define-color hover #3daee6;

            @define-color surface0 #313244;
            @define-color surface1 #45475a;
            @define-color surface2 #585b70;

            @define-color overlay0 #6c7086;
            @define-color overlay1 #7f849c;
            @define-color overlay2 #9399b2;

            @define-color blue      #7EBAE4; 
            @define-color lavender  #b4befe;
            @define-color sapphire  #74c7ec;
            @define-color sky       #89dceb;
            @define-color teal      #94e2d5;
            @define-color green     #27ae60;
            @define-color orange    #f67400;
            @define-color yellow    #fdbc4b;
            @define-color peach     #fab387;
            @define-color maroon    #eba0ac;
            @define-color red       #da4453;
            @define-color mauve     #cba6f7;
            @define-color pink      #f5c2e7;
            @define-color flamingo  #f2cdcd;
            @define-color rosewater #f5e0dc;
            * {
              font-family: JetBrains Mono Nerd Font;
              /*font-weight: bold; */
              font-size: 16px;
            }

            window {
            }

            window#waybar {
              background-color: rgba(0, 0, 0, 1.0);
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
              background-color: @crust;
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
