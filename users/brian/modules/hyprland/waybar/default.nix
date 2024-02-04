{
  programs.waybar = {
    enable = true;
    settings = {
      mainBar = {
        spacing = 0;
        layer = "top";
        margin-top = 5;
        margin-left = 10;
        margin-right = 10;
        modules-left = [
          "hyprland/workspaces"
          "wlr/taskbar"
        ];
        modules-center = [ "clock"];
        modules-right = [
          "tray"
          "custom/clipboard"
          "backlight"
          "pulseaudio#sink"
          "pulseaudio#source"
          "network"
          "bluetooth"
          "battery"
          "custom/session"
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
          "format" = " | ";
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
          #"on-click" = "$HOME/.config/rofi/scripts/clipboard.sh";
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
          "persistent_workspaces" = {
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
          "icon-size" = 15;
          "spacing" = 15;
        };
        "clock" = {
          "format" = "{:%a %b %d, %G %I:%M %p} ";
          "interval" = 60;
          "tooltip-format" = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
        };
        "cpu" = {
          "format" = "  {usage}%";
        };
        "memory" = {
          "format" = "  {}%";
        };
        "bluetooth" = {
          "format" = "󰂯";
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
      @define-color crust  #232629;

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
        border-radius: 20px;
        font-family: NotoMono Nerd Font, JetBrainsMono Nerd Font;
        font-size: 14px;
      }

      window {
      }

      window#waybar {
        background-color: rgba(0,0,0,0.75);
        transition-property: background-color;
        transition-duration: 0.5s;
      }

      .modules-right {
        background: transparent;
        margin: 0 -12px 0 0;
        border-radius: 20px;
      }
      .modules-center {
        background: transparent;
        margin: 0 0 0 0;
        border-radius: 20px;
      }
      .modules-left {
        background: transparent;
        margin: 0 0 0 -12px;
      }

      tooltip {
        background-color: @crust;
        border: 2px solid #585b70;
        color: @text;
        border-radius: 10px;
      }

      #custom-launcher {
        margin-left: 25px;
        margin-top: 2px;
      }

      #workspaces {
        margin-left: 15px;
        margin-top: 2px;
      }
      #workspaces button {
          background: transparent;
          color: @subtext0;
          padding: 0 10px;
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
        border-radius: 1px;
      }


      button.urgent {
          color: #11111b;
          background: #fab387;
          border-radius: 10px;
      }

      #custom-sep {
        color: #313244;
        font-size: 14px;
      }

      #custom-session {
        color: #FFFFFF;
        font-size: 20px;
        margin-right: 20px;
        margin-left: 5px;
      }

      #window {
        color: #FFFFFF;
        font-size: 14;
      }

      #custom-recorder {
        font-size: 10px;
      }

      #clock {
        color: @white;
        margin-right: 5px;
        margin-left: 5px;
        margin-top: 2px;
      }

      #tray {
        margin-right: 10px;
        margin-top: 2px;
        color: @white;
        padding: 4px;
      }

      #battery {
        margin-right: 1px;
        margin-left: 2px;
        margin-top: 2px;
        color: @white;
        font-size: 18px;
      }

      #pulseaudio,
      #wireplumber,
      #mode,
      #custom-clipboard,
      #custom-power,
      #custom-menu,
      #backlight,
      #idle_inhibitor {
        margin-right: 10px;
        margin-left: 10px;
        margin-top: 2px;
        color: @white;
        font-size: 18px;
      }

      #network {
        margin-right: 10px;
        margin-left: 2px;
        margin-top: 2px;
        color: @white;
        font-size: 18px;
      }

      #bluetooth {
        margin-right: 8px;
        margin-left: 8px;
        margin-top: 2px;
        color: @white;
        font-size: 20px;
      }


      #cpu,
      #memory,
      #temperature {
        color: @white;
        margin-right: 5px;
      }


      #mode {
        color: #cc3436;
        font-weight: bold;
      }

      #network.disconnected {
        color: @white;
      }
      #network.disabled {
        color: @red;
      }
      #idle_inhibitor.activated {
        color: @lavender;
      }
      #pulseaudio.muted {
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
    '';
  };
}
