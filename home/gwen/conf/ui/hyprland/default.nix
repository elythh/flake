{ config, lib, pkgs, hyprland, hyprland-plugins, split-monitor-workspaces, ... }:

{
  systemd.user.targets.hyprland-session.Unit.Wants = [ "xdg-desktop-autostart.target" ];
  wayland.windowManager.hyprland = {
    enable = true;
    plugins = [
      split-monitor-workspaces.packages.${pkgs.system}.split-monitor-workspaces
      # hyprland-plugins.packages.${pkgs.system}.hyprbars
    ];
    package = hyprland.packages.${pkgs.system}.hyprland;
    systemd.enable = true;
    extraConfig = ''
      ########################################################################################
       __  __ _       _                 _ 
      |  \/  (_)_ __ (_)_ __ ___   __ _| |
      | |\/| | | '_ \| | '_ ` _ \ / _` | |
      | |  | | | | | | | | | | | | (_| | |
      |_|  |_|_|_| |_|_|_| |_| |_|\__,_|_|
                                    
       _   _                  _                 _    ____             __ _           
      | | | |_   _ _ __  _ __| | __ _ _ __   __| |  / ___|___  _ __  / _(_) __ _ ___ 
      | |_| | | | | '_ \| '__| |/ _` | '_ \ / _` | | |   / _ \| '_ \| |_| |/ _` / __|
      |  _  | |_| | |_) | |  | | (_| | | | | (_| | | |__| (_) | | | |  _| | (_| \__ \
      |_| |_|\__, | .__/|_|  |_|\__,_|_| |_|\__,_|  \____\___/|_| |_|_| |_|\__, |___/
             |___/|_|                                                      |___/    
      #########################################################################################

      # You have to change this based on your monitor 
      monitor=eDP-1,1920x1080@60,2560x0,1
      #monitor=DP-6,1920x1080@60,0x0,1
      monitor=DP-3,highres,0x0,1
      # Status bar :) 
      # exec-once=eww open bar
      exec-once=hyprland-autoname-workspaces

      #Notification 
      exec-once=dunst
      # Wallpaper
      exec-once=swww init
      # For screen sharing 
      exec-once=dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP
      # For keyboard 
      exec-once=fcitx5 -D
      # For lockscreen
      exec-once=swayidle -w timeout 200 'swaylock'
      # Start Page
      # exec-once=~/.config/hypr/scripts/startpage.sh

      # Bluetooth
      exec-once=blueman-applet # Make sure you have installed blueman

      # Screen Sharing 
      exec-once=systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP
      # exec-once=~/.config/hypr/scripts/screensharing.sh

      input {
        kb_layout = us
        kb_variant = 
        kb_options = compose:caps
        repeat_rate=50
        repeat_delay=240

        touchpad {
          disable_while_typing=1
          natural_scroll=1
          clickfinger_behavior=1
          middle_button_emulation=0
          tap-to-click=1
        }
      }


      gestures { 
        workspace_swipe=true 
        workspace_swipe_min_speed_to_force=5
      }

      general {
          layout=dwindle
          sensitivity=1.0 # for mouse cursor

          gaps_in=5
          gaps_out=15
          border_size=2
          col.active_border=0xff5e81ac
          col.inactive_border=0x66333333

          apply_sens_to_raw=0 # whether to apply the sensitivity to raw input (e.g. used by games where you aim using your mouse)
      }

      decoration {
          rounding=12
          blur {
            enabled = true
            size=15 # minimum 1
            passes=3 # minimum 1, more passes = more resource intensive.
            new_optimizations = true   
          }
          drop_shadow=true
          shadow_range=10
          col.shadow=0xffa7caff
          col.shadow_inactive=0x50000000
      }

      blurls=lockscreen

      animations {
          enabled=1
          # bezier=overshot,0.05,0.9,0.1,1.1
          bezier=overshot,0.13,0.99,0.29,1.1
          animation=windows,1,4,overshot,popin
          animation=fade,1,10,default
          animation=workspaces,1,6,overshot,slide
          animation=border,1,10,default
      }

      dwindle {
          pseudotile=1 # enable pseudotiling on dwindle
          # force_split=2
          force_split=1
      }

      master {
        new_on_top=true
      }

      misc {
        disable_hyprland_logo=true
        disable_splash_rendering=true
        mouse_move_enables_dpms=true
        vfr = false
      }

      plugin {
        split-monitor-workspaces {
          count = 5
        }
      }

      ########################################################################################

      \ \        / (_)         | |                   |  __ \     | |          
        \ \  /\  / / _ _ __   __| | _____      _____  | |__) |   _| | ___  ___ 
         \ \/  \/ / | | '_ \ / _` |/ _ \ \ /\ / / __| |  _  / | | | |/ _ \/ __|
          \  /\  /  | | | | | (_| | (_) \ V  V /\__ \ | | \ \ |_| | |  __/\__ \
           \/  \/   |_|_| |_|\__,_|\___/ \_/\_/ |___/ |_|  \_\__,_|_|\___||___/

      ########################################################################################


      # Float Necessary Windows
      windowrule=float,Rofi
      windowrule=float,pavucontrol
      windowrulev2 = float,class:^()$,title:^(Picture in picture)$
      windowrulev2 = float,class:^(brave)$,title:^(Save File)$
      windowrulev2 = float,class:^(brave)$,title:^(Open File)$
      windowrulev2 = float,class:^(LibreWolf)$,title:^(Picture-in-Picture)$
      windowrulev2 = float,class:^(blueman-manager)$
      windowrulev2 = float,class:^(org.twosheds.iwgtk)$
      windowrulev2 = float,class:^(blueberry.py)$
      windowrulev2 = float,class:^(xdg-desktop-portal-gtk)$
      windowrulev2 = float,class:^(geeqie)$

      # Increase the opacity 
      windowrule=opacity 0.92,Spotify
      windowrule=opacity 0.92,Thunar
      windowrule=opacity 0.96,discord
      windowrule=opacity 0.9,VSCodium
      windowrule=opacity 0.88,obsidian

      ^.*nvim.*$
      windowrule=tile,librewolf
      windowrule=tile,spotify
      windowrule=opacity 1,neovim
      bindm=SUPER,mouse:272,movewindow
      bindm=SUPER,mouse:273,resizewindow

      ###########################################
        ____  _           _ _                 
       |  _ \(_)         | (_)                
       | |_) |_ _ __   __| |_ _ __   __ _ ___ 
       |  _ <| | '_ \ / _` | | '_ \ / _` / __|
       | |_) | | | | | (_| | | | | | (_| \__ \
       |____/|_|_| |_|\__,_|_|_| |_|\__, |___/
                                     __/ |    
                                    |___/     

      ###########################################

      # example binds
      bind=SUPER,Q,killactive
      bind=SUPER,F,fullscreen,1
      bind=SUPERSHIFT,F,fullscreen,0
      bind=SUPER,RETURN,exec,kitty
      bind=SUPER,Z,exec,kitty -e ~/.config/hypr/scripts/zellij.sh
      bind=SUPER,W,exec,wallpicker
      bind=SUPERSHIFT,Q,exit,
      bind=SUPER,D,exec, rofi -show drun
      bind=SUPERSHIFT,D,exec, tessen -d rofi
      bind=SUPER,P,pseudo,
      bind=SUPERCTRL,L,exec, swaylock
      bind=SUPER,O,togglegroup

      bind=SUPER,ESCAPE,exec,systemctl suspend

      bind=,XF86AudioMute,exec,~/.config/hypr/scripts/volume mute
      bind=,XF86AudioLowerVolume,exec,~/.config/hypr/scripts/volume down
      bind=,XF86AudioRaiseVolume,exec,~/.config/hypr/scripts/volume up
      bind=,XF86AudioMicMute,exec,pactl set-source-mute @DEFAULT_SOURCE@ toggle

      bindle=,XF86MonBrightnessUp,exec,~/.config/hypr/scripts/brightness up  # increase screen brightness
      bindle=,XF86MonBrightnessDown,exec,~/.config/hypr/scripts/brightness down # decrease screen brightnes
      bind=SUPERSHIFT,C,exec,bash ~/.config/hypr/scripts/hyprPicker.sh
      bind=SUPERSHIFT,E,exec,wlogout
      bind = SUPER, T, togglefloating,
      bind=SUPERSHIFT,P,exec,pomotroid --in-process-gpu

      # Screen shot 
      bind=SUPERSHIFT,S,exec,grim -g "$(slurp)" - | swappy -f -
      bind=SUPERCTRL,S,exec,~/.config/hypr/scripts/screenshots.sh
      # Screen recorder
      bind=SUPER,R,exec,wf-recorder -g "$(slurp)"
      # Emoji selector 
      bind=SUPER,E,exec,anyrun


      bind=SUPERSHIFT,RETURN,layoutmsg,swapwithmaster

      # bind=SUPER,j,layoutmsg,cyclenext
      # bind=SUPER,k,layoutmsg,cycleprev

      bind=SUPER,j,movefocus,d
      bind=SUPER,k,movefocus,u

      bind=SUPER,h,movefocus,l
      bind=SUPER,l,movefocus,r

      bind=SUPER,left,resizeactive,-40 0
      bind=SUPER,right,resizeactive,40 0

      bind=SUPER,up,resizeactive,0 -40
      bind=SUPER,down,resizeactive,0 40

      bind=SUPERSHIFT,h,movewindow,l
      bind=SUPERSHIFT,l,movewindow,r
      bind=SUPERSHIFT,k,movewindow,u
      bind=SUPERSHIFT,j,movewindow,d

      bind = SUPER, 1, split-workspace, 1
      bind = SUPER, 2, split-workspace, 2
      bind = SUPER, 3, split-workspace, 3
      bind = SUPER, 4, split-workspace, 4
      bind = SUPER, 5, split-workspace, 5

      bind = SUPER SHIFT, 1, split-movetoworkspacesilent, 1
      bind = SUPER SHIFT, 2, split-movetoworkspacesilent, 2
      bind = SUPER SHIFT, 3, split-movetoworkspacesilent, 3
      bind = SUPER SHIFT, 4, split-movetoworkspacesilent, 4
      bind = SUPER SHIFT, 5, split-movetoworkspacesilent, 5

      bind = SUPER, y, exec, scratchpad
      bind = SUPERSHIFT, y, exec, scratchpad -g
    '';
  };
}
