{
  config,
  inputs,
  osConfig,
  ...
}:
{
  imports = [ inputs.mangowm.hmModules.mango ];

  home.file = {
    ".config/mango/monitors.conf".source = builtins.toPath (
      ./. + "/${osConfig.networking.hostName}_monitors.conf"
    );
  };

  wayland.windowManager.mango = {
    enable = true;
    extraConfig = ''
      # see config.conf
      source=~/.config/mango/monitors.conf

      # ----------------
      # General
      # ----------------
      animations=0
      layer_animations=0
      tag_num=10

      sloppy_focus=0
      focus_on_activate=1
      enable_floating_snap=1

      # ----------------
      # Scroller layout (mirrors niri's layout block and Hyprland's scrolling layout)
      # ----------------
      tag_rule=id:*,layout_name:scroller
      scroller_default_proportion=1.0
      scroller_proportion_preset=0.33,0.5,0.66,1.0
      scroller_ignore_proportion_single=1
      scroller_focus_center=0
      scroller_prefer_center=0
      scroller_structs=6
      edge_scroller_pointer_focus=0

      gap_inner_horizontal=6
      gap_inner_vertical=6
      gap_outer_horizontal=6
      gap_outer_vertical=6

      # ----------------
      # Decoration
      # ----------------
      border_px=2
      border_radius=10
      focus_color=0xe2b86bff
      border_color=0x282c34ff
      urgent_color=0x9b0000ff
      root_color=0x121212ff

      shadows=1
      shadow_only_floating=0
      shadows_size=5
      shadows_blur=30
      shadows_position_x=0
      shadows_position_y=5
      shadows_color=0x00000077

      # ----------------
      # Input
      # ----------------
      xkb_rules_options=ctrl:nocaps
      numlock_on=1
      tap_to_click=1
      trackpad_natural_scrolling=1
      mouse_natural_scrolling=1

      # ----------------
      # Apps / launcher / panels
      # ----------------
      bind=SUPER,Return,spawn,ghostty
      bind=SUPER,q,killclient
      bind=SUPER,b,spawn,brave
      bind=SUPER,e,spawn,thunar
      bind=SUPER,d,spawn,epochctl launcher provider apps
      bind=SUPER,space,spawn,epochctl launcher providers
      bind=SUPER+SHIFT,slash,spawn,epochctl launcher provider keybinds
      bind=SUPER+SHIFT,w,spawn,epochctl launcher provider windows
      bind=SUPER+SHIFT,c,spawn,epochctl launcher provider clipboard
      bind=SUPER+SHIFT,f,spawn,epochctl launcher provider files

      bind=SUPER+ALT+SHIFT,t,spawn,epochctl panel toggle tailscale
      bind=SUPER+ALT+SHIFT,l,spawn,epochctl panel toggle localsend
      bind=SUPER+ALT+SHIFT,w,spawn,epochctl panel toggle wifi
      bind=SUPER+ALT+SHIFT,b,spawn,epochctl panel toggle bluetooth
      bind=SUPER+ALT+SHIFT,a,spawn,epochctl panel toggle audio
      bind=SUPER+ALT+SHIFT,h,spawn,epochctl panel toggle homeassistant

      bind=SUPER+ALT,l,spawn,epochctl lock
      bind=NONE,XF86PowerOff,spawn_shell,$HOME/.config/wlogout/scripts/wlogout.sh
      bind=SUPER+CTRL+SHIFT,p,spawn_shell,$HOME/.config/wlogout/scripts/wlogout.sh

      bind=NONE,Print,spawn,epochctl capture screenshot region
      bind=CTRL,Print,spawn,epochctl capture screenshot fullscreen
      bind=ALT,Print,spawn,epochctl capture screenshot window
      bind=SUPER+CTRL+SHIFT,i,spawn,epochctl capture screenshot region
      bind=SUPER+CTRL+SHIFT+ALT,i,spawn,epochctl capture screenshot region --annotate

      bind=SUPER+CTRL+ALT+SHIFT,l,spawn_shell,curl -X GET "https://home.semrad.net/api/webhook/-WaJcaS6CZ1F-V-0exl8Nuhmq"

      bind=SUPER+SHIFT,e,quit
      bind=SUPER+SHIFT+CTRL,r,reload_config

      # ----------------
      # Media
      # ----------------
      bindl=NONE,XF86AudioRaiseVolume,spawn,wpctl set-volume -l 1.0 @DEFAULT_AUDIO_SINK@ 5%+
      bindl=NONE,XF86AudioLowerVolume,spawn,wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-
      bindl=NONE,XF86AudioMute,spawn,wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
      bindl=NONE,XF86AudioMicMute,spawn,wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle
      bind=SUPER+SHIFT+CTRL,m,spawn,wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle
      bind=SUPER+SHIFT+CTRL,s,spawn,wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
      bindl=NONE,XF86MonBrightnessUp,spawn,brightnessctl s 5%+
      bindl=NONE,XF86MonBrightnessDown,spawn,brightnessctl s 5%-

      # ----------------
      # Layouts
      # ----------------
      bind=SUPER+SHIFT+CTRL+ALT,s,setlayout,scroller
      bind=SUPER+SHIFT+CTRL+ALT,t,setlayout,dwindle
      bind=SUPER,o,toggleoverview

      # ----------------
      # Focus / move (columns left-right, windows within a column up-down)
      # ----------------
      bind=SUPER,Left,focusdir,left
      bind=SUPER,Right,focusdir,right
      bind=SUPER,Up,focusdir,up
      bind=SUPER,Down,focusdir,down
      bind=SUPER,h,focusdir,left
      bind=SUPER,l,focusdir,right
      bind=SUPER,k,focusdir,up
      bind=SUPER,j,focusdir,down

      bind=SUPER+SHIFT,Left,exchange_client,left
      bind=SUPER+SHIFT,Right,exchange_client,right
      bind=SUPER+SHIFT,Up,exchange_client,up
      bind=SUPER+SHIFT,Down,exchange_client,down
      bind=SUPER+SHIFT,h,exchange_client,left
      bind=SUPER+SHIFT,l,exchange_client,right
      bind=SUPER+SHIFT,k,exchange_client,up
      bind=SUPER+SHIFT,j,exchange_client,down

      bind=SUPER,Tab,focuslast
      bind=SUPER+SHIFT,Tab,view,-1,0

      # Column stacking, mirroring niri's consume/expel: pull the focused window into the
      # column in that direction, or push it back out into its own column.
      bind=SUPER+ALT,Left,scroller_stack,left
      bind=SUPER+ALT,Right,scroller_stack,right
      bind=SUPER+ALT,Up,scroller_stack,up
      bind=SUPER+ALT,Down,scroller_stack,down
      bind=SUPER+CTRL+SHIFT,Left,scroller_stack,left
      bind=SUPER+CTRL+SHIFT,Right,scroller_stack,right
      bind=SUPER,comma,scroller_stack,left
      bind=SUPER,period,scroller_stack,right

      # Column widths
      bind=SUPER,r,switch_proportion_preset
      bind=SUPER+CTRL,Left,resizewin,-100,0
      bind=SUPER+CTRL,Right,resizewin,+100,0
      bind=SUPER+CTRL,Up,resizewin,0,-100
      bind=SUPER+CTRL,Down,resizewin,0,+100

      bind=SUPER,f,togglefullscreen
      bind=SUPER,m,togglemaximizescreen
      bind=SUPER,g,togglefloating
      bind=SUPER+SHIFT+CTRL+ALT,m,restore_minimized

      # Monitors
      bind=SUPER+SHIFT+CTRL,h,tagmon,left
      bind=SUPER+SHIFT+CTRL,l,tagmon,right
      bind=SUPER+SHIFT+CTRL,k,tagmon,up
      bind=SUPER+SHIFT+CTRL,j,tagmon,down

      # ----------------
      # Tags (workspaces)
      # ----------------
      bind=SUPER+ALT+CTRL,Right,viewtoright,0
      bind=SUPER+ALT+CTRL,Left,viewtoleft,0
      bind=SUPER+ALT+CTRL+SHIFT,Right,tagtoright,0
      bind=SUPER+ALT+CTRL+SHIFT,Left,tagtoleft,0
      bind=SUPER,u,viewtoright_have_client,0
      bind=SUPER,i,viewtoleft_have_client,0
      bind=SUPER+ALT,u,tagtoright,0
      bind=SUPER+ALT,i,tagtoleft,0

      bind=SUPER,1,view,1,0
      bind=SUPER,2,view,2,0
      bind=SUPER,3,view,3,0
      bind=SUPER,4,view,4,0
      bind=SUPER,5,view,5,0
      bind=SUPER,6,view,6,0
      bind=SUPER,7,view,7,0
      bind=SUPER,8,view,8,0
      bind=SUPER,9,view,9,0
      bind=SUPER,0,view,10,0

      # tag: move client to the tag and focus it
      # tagsilent: move client to the tag and not focus it
      bind=SUPER+SHIFT,1,tag,1,0
      bind=SUPER+SHIFT,2,tag,2,0
      bind=SUPER+SHIFT,3,tag,3,0
      bind=SUPER+SHIFT,4,tag,4,0
      bind=SUPER+SHIFT,5,tag,5,0
      bind=SUPER+SHIFT,6,tag,6,0
      bind=SUPER+SHIFT,7,tag,7,0
      bind=SUPER+SHIFT,8,tag,8,0
      bind=SUPER+SHIFT,9,tag,9,0
      bind=SUPER+SHIFT,0,tag,10,0

      # ----------------
      # Mouse / gestures
      # ----------------
      mousebind=SUPER,btn_left,moveresize,curmove
      mousebind=SUPER+CTRL,btn_left,moveresize,curresize

      axisbind=SUPER,DOWN,focusdir,left
      axisbind=SUPER,UP,focusdir,right
      axisbind=SUPER,LEFT,focusdir,left
      axisbind=SUPER,RIGHT,focusdir,right
      axisbind=SUPER+CTRL,LEFT,exchange_client,left
      axisbind=SUPER+CTRL,RIGHT,exchange_client,right
      axisbind=SUPER+SHIFT,DOWN,viewtoright_have_client,0
      axisbind=SUPER+SHIFT,UP,viewtoleft_have_client,0

      gesturebind=none,left,3,focusdir,right
      gesturebind=none,right,3,focusdir,left
      gesturebind=none,up,3,focusdir,down
      gesturebind=none,down,3,focusdir,up
      gesturebind=none,left,4,viewtoright_have_client,0
      gesturebind=none,right,4,viewtoleft_have_client,0
      gesturebind=none,up,4,toggleoverview
      gesturebind=none,down,4,toggleoverview

      # ----------------
      # Window rules
      # ----------------
      window_rule=tags:1,app_id:^(firefox)$
      window_rule=tags:1,app_id:^(brave-browser)$
      window_rule=tags:2,app_id:^(discord)$
      window_rule=tags:2,app_id:^(org\.signal\.Signal)$
      window_rule=tags:3,app_id:^(Proton Mail)$
      window_rule=tags:3,app_id:^(brave-gmail\.com).*
      window_rule=tags:3,app_id:^(brave-mail\.proton\.me).*
      window_rule=tags:4,app_id:^(Alacritty)$
      window_rule=tags:4,app_id:^(kitty)$
      window_rule=tags:4,app_id:^(com\.mitchellh\.ghostty)$
      window_rule=tags:5,app_id:^(jetbrains-idea)$
      window_rule=tags:5,app_id:^(Code)$
      window_rule=tags:5,app_id:^(code-url-handler)$
      window_rule=tags:6,app_id:^(steam)$
      window_rule=tags:7,app_id:^(brave-todo).*
      window_rule=tags:8,app_id:^(brave-music).*
      window_rule=tags:9,app_id:^(Cider)$
      window_rule=tags:9,app_id:^(brave-chatgpt\.com).*
      window_rule=tags:9,app_id:^(brave-claude\.ai).*
      window_rule=tags:10,app_id:^(BambuStudio)$

      window_rule=is_floating:1,app_id:^(blueman-manager)$
      window_rule=is_floating:1,app_id:^(nm-connection-editor)$
      window_rule=is_floating:1,app_id:^(pavucontrol)$
      window_rule=is_floating:1,width:420,height:640,app_id:.*nngceckbapebfimnlniiiahkandclblb.*

      # Keep password managers out of screen captures
      window_rule=shield_when_capture:1,app_id:^(Bitwarden)$
      window_rule=shield_when_capture:1,app_id:.*nngceckbapebfimnlniiiahkandclblb.*

      layer_rule=no_animation:1,layer_name:^(walker)$
      layer_rule=shield_when_capture:1,no_animation:1,layer_name:^(Bitwarden)$
    '';
    autostart_sh = ''
      # Same as niri: Hyprland leaves hyprland-session.target (and graphical-session.target) up
      # when it exits, so make sure epochshell is actually running for this session.
      systemctl --user stop hyprland-session.target
      systemctl --user is-active -q epochshell.service || {
        systemctl --user reset-failed epochshell.service
        systemctl --user restart epochoxide.service epochshell.service
      }
    '';
  };
}
