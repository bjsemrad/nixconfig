import { opt, mkOptions } from "lib/option"
import { distro } from "lib/variables"
import { icon } from "lib/utils"
import icons from "lib/icons"
import weather from "service/weather"

const options = mkOptions(OPTIONS, {
    autotheme: opt(false),

    wallpaper: {
        resolution: opt<import("service/wallpaper").Resolution>(1920),
        market: opt<import("service/wallpaper").Market>("random"),
    },

    theme: {
        dark: {
            primary: {
                // bg: opt("#51a4e7"),
                bg: opt("#89b4fa"), //catppuccin blue
                //bg: opt("#9ccfd8"), //rosepine blue
                // fg: opt("#141414"),
                fg: opt("#403d52"), //rosepine
            },
            error: {
                // bg: opt("#e55f86"),
                bg: opt("#f38ba8"), //catppuccin
                //bg: opt("#eb6f92"), //rosepine 
                fg: opt("#141414"),
            },
            bg: opt("#171717"),
            // bg: opt("#191724"), //rosepine
            fg: opt("#eeeeee"),
            // fg: opt("#cdd6f4"), //catppuccin text
            // fg: opt("#e0def4"), //rosepine
            // widget: opt("#e0def4"), //rosepine
            // border: opt("#e0def4"), //rosepine
            // widget: opt("#cdd6f4"), //catppuccin
            // border: opt("#cdd6f4"), //catppuccin
            widget: opt("#eeeeee"), 
            border: opt("#eeeeee"),
        },
        light: {
            primary: {
                bg: opt("#426ede"),
                fg: opt("#eeeeee"),
            },
            error: {
                bg: opt("#b13558"),
                fg: opt("#eeeeee"),
            },
            bg: opt("#fffffa"),
            fg: opt("#080808"),
            widget: opt("#080808"),
            border: opt("#080808"),
        },

        blur: opt(1.0),
        scheme: opt<"dark" | "light">("dark"),
        widget: { opacity: opt(94) },
        border: {
            width: opt(1),
            opacity: opt(96),
        },

        shadows: opt(true),
        padding: opt(7),
        spacing: opt(12),
        radius: opt(11),
    },

    transition: opt(100),

    font: {
        size: opt(10),
        name: opt("Ubuntu Nerd Font"),
    },

    bar: {
        flatButtons: opt(true),
        position: opt<"top" | "bottom">("top"),
        corners: opt(25), //50
        transparent: opt(false),
        layout: {
            start: opt<Array<import("widget/bar/Bar").BarWidget>>([
                // "launcher",
                "workspaces",
                "taskbar",
                "expander",
                "messages",
            ]),
            center: opt<Array<import("widget/bar/Bar").BarWidget>>([
                "date",
            ]),
            end: opt<Array<import("widget/bar/Bar").BarWidget>>([
                "expander",
                "media",
                "systray",
                "screenrecord",
                "system",
                "battery",
                "powermenu",
            ]),
        },
        launcher: {
            icon: {
                colored: opt(true),
                icon: opt(icon(distro.logo, icons.ui.search)),
            },
            label: {
                colored: opt(false),
                label: opt(" "),// label: opt(" Applications"),
            },
            action: opt(() => App.toggleWindow("launcher")),
        },
        date: {
            format: opt("%a %b %d, %G %I:%M %p"),
            action: opt(() => App.toggleWindow("datemenu")),
        },
        battery: {
            bar: opt<"hidden" | "regular" | "whole">("hidden"),
            // charging:  opt("#31748f"), //rosepine //opt("#00D787"),
            charging: opt("#a6e3a1"), //catppuccin
            percentage: opt(false),
            blocks: opt(7),
            width: opt(50),
            low: opt(30),
        },
        workspaces: {
            workspaces: opt(9),
        },
        taskbar: {
            iconSize: opt(0),
            monochrome: opt(false),
            exclusive: opt(false),
        },
        messages: {
            action: opt(() => App.toggleWindow("datemenu")),
        },
        systray: {
            ignore: opt([
                "KDE Connect Indicator",
                "spotify-client",
            ]),
        },
        media: {
            monochrome: opt(true),
            preferred: opt("spotify"),
            direction: opt<"left" | "right">("right"),
            format: opt("{artists} - {title}"),
            length: opt(40),
        },
        powermenu: {
            monochrome: opt(true),
            action: opt(() => App.toggleWindow("powermenu")),
        },
    },

    launcher: {
        width: opt(0),
        margin: opt(80),
        nix: {
            pkgs: opt("nixpkgs/nixos-unstable"),
            max: opt(8),
        },
        sh: {
            max: opt(16),
        },
        apps: {
            iconSize: opt(32),
            max: opt(10),
            favorites: opt([
                [
                    // "firefox",
                ],
            ]),
        },
    },

    overview: {
        scale: opt(9),
        workspaces: opt(9),
        monochromeIcon: opt(true),
    },

    powermenu: {
        sleep: opt("systemctl suspend"),
        reboot: opt("systemctl reboot"),
        logout: opt("pkill Hyprland"),
        shutdown: opt("shutdown now"),
        layout: opt<"line" | "box">("line"),
        labels: opt(true),
    },

    quicksettings: {
        avatar: {
            image: opt(`/var/lib/AccountsService/icons/${Utils.USER}`),
            size: opt(70),
        },
        width: opt(380),
        position: opt<"left" | "center" | "right">("right"),
        // networkSettings: opt("gtk-launch gnome-control-center"),
        networkSettings: opt("$HOME/.config/rofi/scripts/networkmanager.sh"),
        media: {
            monochromeIcon: opt(true),
            coverSize: opt(100),
        },
    },

    datemenu: {
        position: opt<"left" | "center" | "right">("center"),
        weather: {
            interval: opt(60_000),
            unit: opt<"metric" | "imperial" | "standard">("metric"),
            key: opt<string>(
                JSON.parse(Utils.readFile(`${App.configDir}/.weather`) || "{}")?.key || "",
            ),
            cities: opt<Array<number>>(
                JSON.parse(Utils.readFile(`${App.configDir}/.weather`) || "{}")?.cities || [],
            ),
        },
    },

    osd: {
        progress: {
            vertical: opt(true),
            pack: {
                h: opt<"start" | "center" | "end">("end"),
                v: opt<"start" | "center" | "end">("center"),
            },
        },
        microphone: {
            pack: {
                h: opt<"start" | "center" | "end">("center"),
                v: opt<"start" | "center" | "end">("end"),
            },
        },
    },

    notifications: {
        position: opt<Array<"top" | "bottom" | "left" | "right">>(["top", "right"]),
        blacklist: opt(["Spotify"]),
        width: opt(440),
    },

    hyprland: {
        gaps: opt(3),
        inactiveBorder: opt("#282828"),
        gapsWhenOnly: opt(true),
    },
})

globalThis["options"] = options
export default options
