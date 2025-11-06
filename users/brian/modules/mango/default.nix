{ config, inputs, osConfig, ... }: {
  imports = [ inputs.mangowm.hmModules.mango ];

  home.file = {
    ".config/mango/monitors.conf".source =
      builtins.toPath (./. + "/${osConfig.networking.hostName}_monitors.conf");
  };

  wayland.windowManager.mango = {
    enable = true;
    settings = ''
      # see config.conf
      source=~/.config/mango/monitors.conf
      adaptive_sync=1
      animations=0
      borderpx=2

      sloppyfocus=0
      focus_on_activate=1
      enable_floating_snap=1

      scroller_default_proportion=1.0
      scroller_structs=16
      edge_scroller_pointer_focus=0

      xkb_rules_options=ctrl:nocaps

      bind=SUPER,Return,spawn,ghostty
      bind=SUPER,q,killclient,
      bind=SUPER+SHIFT+CTRL,L,quit
      bind=SUPER,d,spawn,walker
      bind=SUPER,b,spawn,brave
      bind=SUPER+SHIFT+CTRL,r,reload_config

      bind=SUPER,o,toggleoverview
      bind=SUPER+SHIFT+CTRL+ALT,s,setlayout,scroller
      bind=SUPER+SHIFT+CTRL+ALT,t,setlayout,tile
      bind=SUPER+SHIFT+CTRL+ALT,g,setlayout,grid

      bind=NONE,XF86PowerOff,spawn,$HOME/.config/wlogout/scripts/wlogout.sh
      bind=SUPER+CTRL+SHIFT,P,spawn,$HOME/.config/wlogout/scripts/wlogout.sh

      #Gestures 
      gesturebind=none,left,3,focusdir,right
      gesturebind=none,right,3,focusdir,left
      gesturebind=none,up,3,focusdir,down
      gesturebind=none,down,3,focusdir,up
      gesturebind=none,right,4,viewtoleft_have_client
      gesturebind=none,left,4,viewtoright_have_client
      gesturebind=none,up,4,toggleoverview
      gesturebind=none,down,4,toggleoverview

      trackpad_natural_scrolling=1
      mouse_natural_scrolling=1


      #Mouse
      #mousebind=SUPER,btn_left,moveresize,curmove
      #mousebind=SUPER,btn_right,moveresize,curresize
      #mousebind=NONE,btn_middle,togglemaximizescreen,0
      axisbind=SUPER,DOWN,viewtoleft_have_client
      axisbind=SUPER,UP,viewtoright_have_client


      # switch window focus
      bind=SUPER,Tab,focusstack,next
      bind=SUPER,Left,focusdir,left
      bind=SUPER,Right,focusdir,right
      bind=SUPER,Up,focusdir,up
      bind=SUPER,Down,focusdir,down
      bind=SUPER,Up,focusdir,uprestore_minimized
      bind=SUPER,Down,focusdir,down

      bind=SUPER+SHIFT,Left,exchange_client,left
      bind=SUPER+SHIFT,Right,exchange_client,right
      bind=SUPER+SHIFT,Up,exchange_client,up
      bind=SUPER+SHIFT,Down,exchange_client,down

      bind=SUPER+CTRL,Right,resizewin,10,0
      bind=SUPER+CTRL,Left,resizewin,-10,0

      bind=SUPER+SHIFT,F,togglefullscreen
      bind=SUPER+SHIFT+CTRL,m,restore_minimized

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
      # bind=Alt,1,tagsilent,1
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


      windowrule=tags:1,appid:firefox
      windowrule=tags:1,appid:brave-browser
      windowrule=tags:2,appid:discord
      windowrule=tags:2,appid:signal
      windowrule=tags:5,appid:jetbrains-idea
      windowrule=tags:5,appid:Code
      windowrule=tags:10,appid:BambooStudio
      windowrule=tags:4,appid:com.mitchellh.ghostty
      windowrule=tags:3,appid:^(brave-amail.com).*
      windowrule=tags:3,appid:^(brave-mail.proton.me).*
      windowrule=tags:3,appid:^(brave-chatgpt.com).*


      border_radius=10
    '';
    autostart_sh = ''
      # see autostart.sh
      # Note: here no need to add shebang
    '';
  };
}
