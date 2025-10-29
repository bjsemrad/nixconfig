{ cfg, inputs, ... }: {
  imports = [ inputs.mangowm.hmModules.mango ];
  wayland.windowManager.mango = {
    enable = true;
    settings = ''
      # see config.conf
      monitorrule=eDP-1,0.55,1,scroller,0,1.33,0,0,2880,1920,120
      adaptive_sync=1
      animations=0

      borderpx=3

      xkb_rules_options=ctrl:nocaps

      bind=SUPER,Return,spawn,ghostty
      bind=SUPER,q,killclient,
      bind=SUPER,d,spawn,walker
      bind=SUPER,r,reload_config

      # switch window focus
      bind=SUPER,Tab,focusstack,next
      bind=SUPER,Left,focusdir,left
      bind=SUPER,Right,focusdir,right
      bind=SUPER,Up,focusdir,up
      bind=SUPER,Down,focusdir,down

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
      bind=Alt,1,tag,1,0
      bind=Alt,2,tag,2,0
      bind=Alt,3,tag,3,0
      bind=Alt,4,tag,4,0
      bind=Alt,5,tag,5,0
      bind=Alt,6,tag,6,0
      bind=Alt,7,tag,7,0
      bind=Alt,8,tag,8,0
      bind=Alt,9,tag,9,0



      border_radius=6

      trackpad_natural_scrolling=1
      mouse_natural_scrolling=1
    '';
    autostart_sh = ''
      # see autostart.sh
      # Note: here no need to add shebang
    '';
  };
}
