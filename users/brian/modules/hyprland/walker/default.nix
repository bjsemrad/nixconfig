{ inputs, pkgs, ... }: {
  home.packages = [
    pkgs.libqalculate
    inputs.nixpkgs-unstable.legacyPackages.${pkgs.system}.iwmenu
    inputs.nixpkgs-unstable.legacyPackages.${pkgs.system}.bzmenu
  ];

  home.file = {
    ".config/walker/scripts/keybinds.sh".source = ./scripts/keybinds.sh;
    ".config/walker/scripts/windows.sh".source = ./scripts/windows.sh;

  };

  # programs.elephant = {
  #
  # };

  programs.walker = {
    enable = true;
    runAsService = true;
    config = {
      force_keyboard_focus = false;    # forces keyboard forcus to stay in Walker
      close_when_open = true;          # close walker when invoking while already opened
      selection_wrap = true;          # wrap list if at bottom or top
      global_argument_delimiter = "#"; # query: firefox#https://benz.dev => ignored after delimiter
      keep_open_modifier = "shift";    # won't close on activation, but select next item
      exact_search_prefix = "'";       # disable fuzzy searching
      disable_mouse = false;           # disable mouse (on input and list only)

      shell = {
        anchor_top = true;
        anchor_bottom = true;
        anchor_left = true;
        anchor_right = true;
      };

      placeholders = {
        default = {
          input = "  Search";
          list = "No Results";
        };
      };

      keybinds = {
        close = "Escape";
        next = "Down";
        previous = "Up";
        toggle_exact = "ctrl e";
        resume_last_query = "ctrl r";
        quick_activate = [ "F1" "F2" "F3" "F4" ];
      };

      providers = {
        default = [
          "desktopapplications"
          "calc"
        ];
        empty = [ "desktopapplications" ];

        prefixes = [
          { prefix = ";"; provider = "providerlist"; }
          { prefix = "/"; provider = "files"; }
          { prefix = "."; provider = "symbols"; }
          { prefix = "!"; provider = "todo"; }
          { prefix = "="; provider = "calc"; }
          { prefix = "@"; provider = "websearch"; }
          { prefix = ":"; provider = "clipboard"; }
          { prefix = "~"; provider = "hyprlandkeybinds";}
        ];

        archlinuxpkgs = {
          default = "install";
          install = "Return";
          remove = "ctrl d";
        };

        calc = {
          default = "copy";
          copy = "Return";
          save = "ctrl s";
          delete = "ctrl d";
        };

        websearch = {
          default = "search";
          search = "Return";
          remove_history = "ctrl BackSpace";
        };

        providerlist = {
          default = "activate";
          activate = "Return";
        };

        clipboard = {
          time_format = "%d.%m. - %H:%M"; # format for clipboard item date
          default = "copy";
          copy = "Return";
          delete = "ctrl d";
          edit = "ctrl o";
          toggle_images_only = "ctrl i";
        };

        desktopapplications = {
          default = "start";
          start = "Return";
          remove_history = "ctrl BackSpace";
          toggle_pin = "ctrl p";
        };

        files = {
          default = "open";
          open = "Return";
          open_dir = "ctrl Return";
          copy_path = "ctrl shift C";
          copy_file = "ctrl c";
        };

        todo = {
          default = "save";
          save = "Return";
          delete = "ctrl d";
          mark_active = "ctrl a";
          mark_done = "ctrl f";
          clear = "ctrl x";
        };

        runner = {
          default = "start";
          start = "Return";
          start_terminal = "shift Return";
          remove_history = "ctrl BackSpace";
        };

        dmenu = {
          default = "select";
          select = "Return";
        };

        symbols = {
          default = "copy";
          copy = "Return";
          remove_history = "ctrl BackSpace";
        };

        unicode = {
          default = "copy";
          copy = "Return";
          remove_history = "ctrl BackSpace";
        };

        menus = {
          default = "activate";
          activate = "Return";
          remove_history = "ctrl BackSpace";
        };
      };
    };

    elephant = {
        providers = [
          "files"
          "desktopapplications"
          "calc"
          "clipboard"
          "menus"
          "providerlist"
      ];

      config = {
        providers = {
              files = {
                min_score = 50;
              };
              desktopapplications = {
                launch_prefix = "uwsm app --";
              };
        };
      };
    };

    theme = {
      name = "matte-black";
      style = ''
            @define-color window_bg_color #000000;
            @define-color accent_bg_color  #a0a8b7;
            @define-color theme_fg_color #a0a8b7;

            * {
              all: unset;
            }

            .normal-icons {
              -gtk-icon-size: 16px;
            }

            .large-icons {
              -gtk-icon-size: 32px;
            }

            scrollbar {
              opacity: 0;
            }

            .box-wrapper {
              box-shadow:
                0 19px 38px rgba(0, 0, 0, 0.3),
                0 15px 12px rgba(0, 0, 0, 0.22);
              background: @window_bg_color;
              padding: 20px;
              border-radius: 20px;
              border: 1px solid darker(@accent_bg_color);
            }

            .preview-box,
            .elephant-hint,
            .placeholder {
              color: @theme_fg_color;
            }

            .box {
            }

            .search-container {
              border-radius: 10px;
            }

            .input placeholder {
              opacity: 0.5;
            }

            .input {
              caret-color: @theme_fg_color;
              background: lighter(@window_bg_color);
              padding: 10px;
              color: @theme_fg_color;
            }

            .input:focus,
            .input:active {
            }

            .content-container {
            }

            .placeholder {
            }

            .scroll {
            }

            .list {
              color: @theme_fg_color;
            }

            child {
            }

            .item-box {
              border-radius: 10px;
              padding: 10px;
            }

            .item-quick-activation {
              margin-left: 10px;
              background: alpha(@accent_bg_color, 0.25);
              border-radius: 5px;
              padding: 10px;
            }

            child:hover .item-box,
            child:selected .item-box {
              background: alpha(@accent_bg_color, 0.25);
            }

            .item-text-box {
            }

            .item-text {
            }

            .item-subtext {
              font-size: 12px;
              opacity: 0.5;
            }

            .item-image {
              margin-right: 10px;
            }

            .keybind-hints {
              font-size: 12px;
              opacity: 0.5;
              color: @theme_fg_color;
            }

            .preview {
              border: 1px solid alpha(@accent_bg_color, 0.25);
              padding: 10px;
              border-radius: 10px;
              color: @theme_fg_color;
            }

            .calc .item-text {
              font-size: 24px;
            }

            .calc .item-subtext {
            }

            .symbols .item-image {
              font-size: 24px;
            }

            .todo.done .item-text-box {
              opacity: 0.25;
            }

            .todo.urgent {
              font-size: 24px;
            }

            .todo.active {
              font-weight: bold;
            }

            .preview .large-icons {
              -gtk-icon-size: 64px;
            }
      '';
    };
  };
}
