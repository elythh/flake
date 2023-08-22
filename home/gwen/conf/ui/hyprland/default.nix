{ config, lib, pkgs, hyprland, hyprland-plugins, colors, ... }:

{
  systemd.user.targets.hyprland-session.Unit.Wants = [ "xdg-desktop-autostart.target" ];
  wayland.windowManager.hyprland = with colors; {
    enable = true;
    package = hyprland.packages.${pkgs.system}.hyprland;
    systemdIntegration = true;
    extraConfig = ''
      env = PATH,$HOME/.cargo/bin:$PATH
      $mainMod = SUPER
      # $scripts=$HOME/.config/hypr/scripts
      monitor=eDP-1,preferred,960x1080,1
      workspace=eDP-1,1
      monitor=DP-2,1920x1080,1920x0,1
      workspace=DP-2,6
      monitor=DP-3,1920x1080,0x0,1
      workspace=DP-3,11

      workspace=eDP-1,1
      workspace=eDP-1,2
      workspace=eDP-1,3
      workspace=eDP-1,4
      workspace=eDP-1,5

      workspace=DP-3,6
      workspace=DP-3,7
      workspace=DP-3,8
      workspace=DP-3,9
      workspace=DP-3,10

      workspace=DP-2,11
      workspace=DP-2,12
      workspace=DP-2,13
      workspace=DP-2,14
      workspace=DP-2,15

      # Source a file (multi-file configs)
      # source = ~/.config/hypr/myColors.conf
      input {
        kb_layout = us
        kb_variant = intl
        kb_model =
        kb_options = caps:escape
        kb_rules =
        follow_mouse = 1 # 0|1|2|3
        float_switch_override_focus = 2
        numlock_by_default = true
        touchpad {
        natural_scroll = yes
        }
        sensitivity = 0 # -1.0 - 1.0, 0 means no modification.
      }
      device:tpps/2-elan-trackpoint {
        enabled = false
      }
      general {
        gaps_in = 8
        gaps_out = 8
        border_size = 3
        col.active_border = rgb(${color4})
        col.group_border = rgb(${color8})
        col.group_border_active = rgb(${color4})
        col.group_border_locked = rgb(${color9})
        col.group_border_locked_active = rgb(${color1})
      wl-clipboard
        col.inactive_border = rgba(595959aa)
        layout = dwindle # master|dwindle
      }
      dwindle {
        no_gaps_when_only = false
        force_split = 0
        special_scale_factor = 0.8
        split_width_multiplier = 1.0
        use_active_for_splits = true
        pseudotile = yes
        preserve_split = yes
      }
      master {
        new_is_master = true
        special_scale_factor = 0.8
        new_is_master = true
        no_gaps_when_only = false
      }
      # cursor_inactive_timeout = 0
      decoration {
        multisample_edges = true
        active_opacity = 1
        inactive_opacity = 1
        fullscreen_opacity = 1.0
        rounding = 6
        drop_shadow = true
        shadow_range = 4
        shadow_render_power = 3
        shadow_ignore_window = true
      # col.shadow =
      # col.shadow_inactive
      # shadow_offset
        dim_inactive = false
      # dim_strength = #0.0 ~ 1.0
        blur {
          enabled: true
          size = 20
          passes = 4
          new_optimizations = true
        }
      }
      animations {
        enabled=1
        bezier = md3_standard, 0.2, 0, 0, 1
        bezier = md3_decel, 0.05, 0.7, 0.1, 1
        bezier = md3_accel, 0.3, 0, 0.8, 0.15
        bezier = overshot, 0.05, 0.9, 0.1, 1.1
        bezier = crazyshot, 0.1, 1.5, 0.76, 0.92 
        bezier = hyprnostretch, 0.05, 0.9, 0.1, 1.0
        bezier = fluent_decel, 0.1, 1, 0, 1
        # Animation configs
        animation = windows, 1, 2, md3_decel, popin 80%
        animation = border, 1, 10, default
        animation = fade, 1, 2, default
        animation = workspaces, 1, 3, hyprnostretch, slide
        animation = specialWorkspace, 1, 3, md3_decel, fade
      }
      gestures {
        workspace_swipe = true
        workspace_swipe_fingers = 3
        workspace_swipe_distance = 180
        workspace_swipe_invert = true
        workspace_swipe_min_speed_to_force = 15
        workspace_swipe_cancel_ratio = 0.5
        workspace_swipe_create_new = false
      }
      misc {
        groupbar_titles_font_size = 10
        groupbar_gradients = false
        disable_autoreload = true
        disable_hyprland_logo = true
        always_follow_on_dnd = true
        layers_hog_keyboard_focus = true
        animate_manual_resizes = false
        enable_swallow = true
        swallow_regex =
        focus_on_activate = true
      }
      device:epic mouse V1 {
        sensitivity = -0.5
      }
      bind = $mainMod, Return, exec, wezterm
      bind = $mainMod SHIFT, Return, exec, wezterm -e zellij
      bind = $mainMod ALT, Return, exec, wezterm -e zellij a
      bind = $mainMod SHIFT, C, killactive,
      bind = $mainMod SHIFT, Q, exit,
      bind = $mainMod SHIFT, Space, togglefloating,
      bind = $mainMod,F,fullscreen
      bind = $mainMod,Y,pin
      bind = $mainMod, P, pseudo, # dwindle
      bind = $mainMod, J, togglesplit, # dwindle
      #-----------------------#
      # Toggle grouped layout #
      #-----------------------#
      bind = $mainMod, K, togglegroup,
      bind = $mainMod SHIFT, k, moveintogroup, l
      bind = $mainMod SHIFT, L, lockactivegroup, toggle
      bind = $mainMod, Tab, changegroupactive, f
      #------------#
      # change gap #
      #------------#
      bind = $mainMod SHIFT, G,exec,hyprctl --batch "keyword general:gaps_out 5;keyword general:gaps_in 3"
      bind = $mainMod , G,exec,hyprctl --batch "keyword general:gaps_out 0;keyword general:gaps_in 0"
      #--------------------------------------#
      # Move focus with mainMod + arrow keys #
      #--------------------------------------#
      bind = $mainMod, left, movefocus, l
      bind = $mainMod, right, movefocus, r
      bind = $mainMod, up, movefocus, u
      bind = $mainMod, down, movefocus, d
      #----------------------------------------#
      # Switch workspaces with mainMod + [0-9] #
      #----------------------------------------#
      bind = $mainMod, 1, exec, hyprsome workspace 1
      bind = $mainMod, 2, exec, hyprsome workspace 2
      bind = $mainMod, 3, exec, hyprsome workspace 3
      bind = $mainMod, 4, exec, hyprsome workspace 4
      bind = $mainMod, 5, exec, hyprsome workspace 5
      bind = $mainMod, L, exec, hyprsome workspace +1
      bind = $mainMod, H, exec, hyprsome workspace -1
      bind = $mainMod, period, exec, hyprsome workspace e+1
      bind = $mainMod, comma, exec, hyprsome workspacee-1
      bind = $mainMod, Q, exec, hyprsome workspaceQQ
      bind = $mainMod, T, exec, hyprsome workspaceTG
      bind = $mainMod, M, exec, hyprsome workspaceMusic
      #-------------------------------#
      # special workspace(scratchpad) #
      #-------------------------------#
      bind = $mainMod, minus, movetoworkspace,special
      bind = $mainMod, equal, togglespecialworkspace
      #----------------------------------#
      # move window in current workspace #
      #----------------------------------#
      bind = $mainMod SHIFT,left ,movewindow, l
      bind = $mainMod SHIFT,right ,movewindow, r
      bind = $mainMod SHIFT,up ,movewindow, u
      bind = $mainMod SHIFT,down ,movewindow, d

      #---------------------------------------------------------------#
      # Move active window to a workspace with mainMod + ctrl + [0-9] #
      #---------------------------------------------------------------#
      bind = $mainMod CTRL, 1, exec, hyprsome move 1
      bind = $mainMod CTRL, 2, exec, hyprsome move 2
      bind = $mainMod CTRL, 3, exec, hyprsome move 3
      bind = $mainMod CTRL, 4, exec, hyprsome move 4
      bind = $mainMod CTRL, 5, exec, hyprsome move 5
      bind = $mainMod CTRL, left, exec, hyprsome movetoworkspace -1
      bind = $mainMod CTRL, right, exec, hyprsome movetoworkspace +1
      # same as above, but doesnt switch to the workspace
      bind = $mainMod SHIFT, 1, exec, hyprsome movefocus 1
      bind = $mainMod SHIFT, 2, exec, hyprsome movefocus 2
      bind = $mainMod SHIFT, 3, exec, hyprsome movefocus 3
      bind = $mainMod SHIFT, 4, exec, hyprsome movefocus 4
      bind = $mainMod SHIFT, 5, exec, hyprsome movefocus 5
      # Scroll through existing workspaces with mainMod + scroll
      bind = $mainMod, mouse_down, workspace, e+1
      bind = $mainMod, mouse_up, workspace, e-1
      #-------------------------------------------#
      # switch between current and last workspace #
      #-------------------------------------------#
      binds {
           workspace_back_and_forth = 1
           allow_workspace_cycles = 1
      }
      bind=$mainMod,slash,workspace,previous
      #------------------------#
      # quickly launch program #
      #------------------------#
      #bind=$mainMod,M,exec,netease-cloud-music-gtk4
      bind=$mainMod SHIFT,F,exec, nemo
      bind=$mainMod,A,exec, rofi -modi run -show run
      #-----------------------------------------#
      # control volume,brightness,media players-#
      #-----------------------------------------#
      bind=,XF86AudioRaiseVolume,exec, pamixer -i 5
      bind=,XF86AudioLowerVolume,exec, pamixer -d 5
      bind=,XF86AudioMute,exec, pamixer -t
      bind=,XF86AudioMicMute,exec, pamixer --default-source -t
      bind=,XF86MonBrightnessUp,exec, brightnessctl s 10%+
      bind=,XF86MonBrightnessDown, exec, brightnessctl s 10%-
      bind=,XF86AudioPlay,exec, mpc -q toggle 
      bind=,XF86AudioNext,exec, mpc -q next 
      bind=,XF86AudioPrev,exec, mpc -q prev
      #---------------------#
      # control screenshots #
      #---------------------#
      bind=$mainMod SHIFT, s, exec, captureArea
      bind=$mainMod SHIFT, f, exec, captureAll
      bind=$mainMod SHIFT, w, exec, captureScreen
      #---------------#
      # waybar toggle #
      # --------------#
      bind=$mainMod,O,exec,killall -SIGUSR1 .waybar-wrapped
      #---------------#
      # resize window #
      #---------------#
      bind=ALT,R,submap,resize
      submap=resize
      binde=,right,resizeactive,15 0
      binde=,left,resizeactive,-15 0
      binde=,up,resizeactive,0 -15
      binde=,down,resizeactive,0 15
      binde=,l,resizeactive,15 0
      binde=,h,resizeactive,-15 0
      binde=,k,resizeactive,0 -15
      binde=,j,resizeactive,0 15
      bind=,escape,submap,reset 
      submap=reset
      bind=CTRL SHIFT, left, resizeactive,-30 0
      bind=CTRL SHIFT, right, resizeactive,30 0
      bind=CTRL SHIFT, up, resizeactive,0 -30
      bind=CTRL SHIFT, down, resizeactive,0 30
      bind=CTRL SHIFT, l, resizeactive, 30 0
      bind=CTRL SHIFT, h, resizeactive,-30 0
      bind=CTRL SHIFT, k, resizeactive, 0 -30
      bind=CTRL SHIFT, j, resizeactive, 0 30
      bindm = $mainMod, mouse:272, movewindow
      bindm = $mainMod, mouse:273, resizewindow
      exec = export WALLPAPER=~/.config/awesome/theme/wallpapers/${colors.name}/${colors.wallpaper}
      exec = swaybg -i ~/.config/awesome/theme/wallpapers/${name}/${wallpaper} &
      exec = bash -c ~/.local/bin/genmenupic
      exec = dunst &
      exec-once = xss-lock lock &
      exec-once = syncthing --no-browser &
      exec-once = eww open bar0 && eww open bar1 && eww open bar2 && eww reload &
      exec-once = xrdb -merge ~/.Xresources &

      layerrule = blur,lockscreen
      layerrule = blur,gtk-layer-shell
      layerrule = blur,waybar
      #---------------#
      # windows rules #
      #---------------#
      #`hyprctl clients` get class、title...
      windowrule=float,title:^(Picture-in-Picture)$
      windowrule=size 960 540,title:^(Picture-in-Picture)$
      windowrule=move 25%-,title:^(Picture-in-Picture)$
      windowrule=float,imv
      windowrule=move 25%-,imv
      windowrule=size 960 540,imv
      windowrule=float,mpv
      windowrule=move 25%-,mpv
      windowrule=size 960 540,mpv
      windowrule=float,danmufloat
      windowrule=move 25%-,danmufloat
      windowrule=pin,danmufloat
      windowrule=rounding 5,danmufloat
      windowrule=size 960 540,danmufloat
      windowrule=float,termfloat
      windowrule=move 25%-,termfloat
      windowrule=size 960 540,termfloat
      windowrule=rounding 5,termfloat
      windowrule=opacity 0.95,title:Telegram
      windowrule=opacity 0.95,title:QQ
      windowrule=opacity 0.95,title:NetEase Cloud Music Gtk4
      windowrule=workspace name:QQ, title:Icalingua++
      windowrule=workspace name:TG, title:Telegram
      windowrule=workspace name:Music, title:NetEase Cloud Music Gtk4
      windowrule=workspace name:Music, musicfox
      windowrule=float,ncmpcpp
      windowrule=move 25%-,ncmpcpp
      windowrule=size 960 540,ncmpcpp
      windowrule=noblur,^(firefox)$
    '';
  };
}
