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

    # gtk3.extraConfig = {
    #   gtk-application-prefer-dark-theme = true;
    # };
    #
    # gtk4.extraConfig = {
    #   gtk-application-prefer-dark-theme = true;
    # };
    #
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
    ];
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

      hl.bind("SUPER + CTRL + ALT + SHIFT + S",  function()
        hl.config({
            general = {
                layout = "scrolling",
            },
        })
      end)
      hl.bind("SUPER + CTRL + ALT + SHIFT + T",  function()
        hl.config({
            general = {
                layout = "dwindle",
            },
        })
      end)

      hl.bind("SUPER + CTRL + ALT + SHIFT + E", exec("systemctl --user restart elephant.service"))

      hl.bind("SUPER + RETURN", exec("ghostty"))
      hl.bind("SUPER + Q", hl.dsp.window.close())
      hl.bind("SUPER + E", exec("thunar"))
      hl.bind("SUPER + B", exec("brave"))
      hl.bind("SUPER + G", hl.dsp.window.float({ action = "toggle" }))
      hl.bind("SUPER + D", exec("walker"))
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
        -- Turned on SystemD so these start automatically now.
        -- hl.exec_cmd("systemctl --user restart --now hyprpaper.service")
        -- hl.exec_cmd("systemctl --user restart --now hyprpolkitagent.service")
        -- hl.exec_cmd("systemctl --user restart --now hypridle.service")
        -- hl.exec_cmd("systemctl --user restart --now elephant.service")
        -- hl.exec_cmd("systemctl --user restart --now walker.service")
        -- hl.exec_cmd("systemctl --user restart --now epochshell")
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
    systemd.enable = true;
  };

}
