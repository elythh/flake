{ config, lib, pkgs, ... }:

{
  imports = [

    ../programs/swaylock.nix
    #../programs/waybar.nix

    ../services/cliphist.nix
    ../services/swaybg.nix
    ../services/swayidle.nix
  ];
  home = {
    packages = with pkgs; [
      autotiling-rs
      cliphist
      dbus
      libnotify
      libcanberra-gtk3
      wf-recorder
      brightnessctl
      pamixer
      slurp
      glib
      grim
      gtk3
      hyprpicker
      swaysome
      wl-clipboard
      wl-screenrec
      wlr-randr
      wtype
      sassc
      xdg-utils
      ydotool
      wlr-randr
    ];
  };

  systemd.user.targets.hyprland-session.Unit.Wants = [ "xdg-desktop-autostart.target" ];
  wayland.windowManager.sway = with config.colorscheme.colors; {
    enable = true;
    systemd.enable = true;
    package = pkgs.swayfx;
    extraConfig = ''

      for_window [app_id="spad"] move scratchpad, resize set width 900 height 600
      for_window [app_id="smusicpad"] move scratchpad, resize set width 850 height 550

      set $bg-color 	         #${mbg}
      set $inactive-bg-color   #${darker}
      set $text-color          #${foreground}
      set $inactive-text-color #${foreground}
      set $urgent-bg-color     #${color9}

      # window colors
      #                       border              background         text                 indicator
      client.focused          $bg-color           $bg-color          $text-color          $bg-color 
      client.unfocused        $inactive-bg-color $inactive-bg-color $inactive-text-color  $inactive-bg-color
      client.focused_inactive $inactive-bg-color $inactive-bg-color $inactive-text-color  $inactive-bg-color
      client.urgent           $urgent-bg-color    $urgent-bg-color   $text-color          $urgent-bg-color

      font pango:Iosevka Nerd Font 12
      titlebar_separator enable
      titlebar_padding 6
      title_align center
      default_border normal 2
      default_floating_border normal 2
  
      exec_always --no-startup-id xrdb -merge ~/.Xresources &
      exec_always --no-startup-id copyq &
      exec_always --no-startup-id kanshi &
      exec_always --no-startup-id nm-applet &
      exec --no-startup-id ags &
      exec_always --no-startup-id swaysome init 1 &
      exec_always --no-startup-id mpDris2 &
      exec_always --no-startup-id autotiling-rs &
      exec --no-startup-id swayidle -w \
          timeout 580 'waylock' \
          timeout 600 'swaymsg "output * power off"' resume 'swaymsg "output * power on"' \
          before-sleep 'waylock'
      ## SWAYFX CONFIG
      corner_radius 10

      output * bg ${config.wallpaper} fill
    '';
    config = {
      terminal = "wezterm";
      menu = "ags -t launcher";
      modifier = "Mod4";

      keycodebindings =
        let
          cfg = config.wayland.windowManager.sway.config;
          mod = cfg.modifier;
          left = "43"; # h
          down = "44"; # j
          up = "45"; # k
          right = "46"; # l
        in
        {
          "${mod}+${left}" = "focus left";
          "${mod}+${down}" = "focus down";
          "${mod}+${up}" = "focus up";
          "${mod}+${right}" = "focus right";

          "${mod}+Shift+${left}" = "move left";
          "${mod}+Shift+${down}" = "move down";
          "${mod}+Shift+${up}" = "move up";
          "${mod}+Shift+${right}" = "move right";
        };

      keybindings =
        let
          cfg = config.wayland.windowManager.sway.config;
          mod = cfg.modifier;
        in
        {

          "${mod}+Shift+s" = "exec 'grim -g \"$(slurp)\" - | satty -f -'";
          "Shift+print" = "exec 'grim - | wl-copy'";

          "XF86MonBrightnessUp" = "exec 'brightnessctl s 5+'";
          "XF86MonBrightnessDown" = "exec 'brightnessctl s 5-'";

          "XF86AudioRaiseVolume" = "exec 'pamixer -u ; pamixer -i 5'";
          "XF86AudioLowerVolume" = "exec 'pamixer -u ; pamixer -d 5'";
          "XF86AudioMute" = "exec 'pamixer -t'";

          "${mod}+Return" = "exec ${cfg.terminal}";
          "${mod}+Shift+q" = "reload";
          "${mod}+d" = "exec ${cfg.menu}";
          "${mod}+Shift+p" = "exec rofi-rbw --no-help --clipboarder wl-copy";
          "${mod}+p" = "exec ags -t panel";
          "${mod}+Shift+t" = "exec ags -t work";
          "${mod}+b" = "exec ags -t dock";
          "${mod}+Shift+i" = "exec ags -t bluetoothmenu";

          "${mod}+v" = "exec 'swayscratch spad'";
          "${mod}+z" = "exec 'swayscratch smusicpad'";
          #"${mod}+${cfg.left}" = "focus left";
          #"${mod}+${cfg.down}" = "focus down";
          #"${mod}+${cfg.up}" = "focus up";
          #"${mod}+${cfg.right}" = "focus right";

          "${mod}+Left" = "focus left";
          "${mod}+Down" = "focus down";
          "${mod}+Up" = "focus up";
          "${mod}+Right" = "focus right";

          #"${mod}+Shift+${cfg.left}" = "move left";
          #"${mod}+Shift+${cfg.down}" = "move down";
          #"${mod}+Shift+${cfg.up}" = "move up";
          #"${mod}+Shift+${cfg.right}" = "move right";

          "${mod}+Shift+Left" = "move left";
          "${mod}+Shift+Down" = "move down";
          "${mod}+Shift+Up" = "move up";
          "${mod}+Shift+Right" = "move right";

          "${mod}+Shift+b" = "splith";
          "${mod}+Shift+v" = "splitv";
          "${mod}+f" = "fullscreen";
          "${mod}+a" = "focus parent";

          "${mod}+s" = "layout stacking";
          "${mod}+w" = "layout tabbed";
          "${mod}+e" = "layout toggle split";

          "${mod}+Shift+space" = "floating toggle";
          "${mod}+space" = "focus mode_toggle";

          # Change focus between workspaces
          "${mod}+1" = "exec swaysome focus 1";
          "${mod}+2" = "exec swaysome focus 2";
          "${mod}+3" = "exec swaysome focus 3";
          "${mod}+4" = "exec swaysome focus 4";
          "${mod}+5" = "exec swaysome focus 5";
          "${mod}+6" = "exec swaysome focus 6";
          "${mod}+7" = "exec swaysome focus 7";
          "${mod}+8" = "exec swaysome focus 8";
          "${mod}+9" = "exec swaysome focus 9";
          "${mod}+0" = "exec swaysome focus 0";

          # Move containers between workspaces
          "${mod}+Shift+1" = "exec swaysome move 1";
          "${mod}+Shift+2" = "exec swaysome move 2";
          "${mod}+Shift+3" = "exec swaysome move 3";
          "${mod}+Shift+4" = "exec swaysome move 4";
          "${mod}+Shift+5" = "exec swaysome move 5";
          "${mod}+Shift+6" = "exec swaysome move 6";
          "${mod}+Shift+7" = "exec swaysome move 7";
          "${mod}+Shift+8" = "exec swaysome move 8";
          "${mod}+Shift+9" = "exec swaysome move 9";
          "${mod}+Shift+0" = "exec swaysome move 0";

          "${mod}+Alt+1" = "exec swaysome focus-group 1";
          "${mod}+Alt+2" = "exec swaysome focus-group 2";
          "${mod}+Alt+3" = "exec swaysome focus-group 3";
          "${mod}+Alt+4" = "exec swaysome focus-group 4";
          "${mod}+Alt+5" = "exec swaysome focus-group 5";
          "${mod}+Alt+6" = "exec swaysome focus-group 6";
          "${mod}+Alt+7" = "exec swaysome focus-group 7";
          "${mod}+Alt+8" = "exec swaysome focus-group 8";
          "${mod}+Alt+9" = "exec swaysome focus-group 9";
          "${mod}+Alt+0" = "exec swaysome focus-group 0";

          "${mod}+Alt+Shift+1" = "exec swaysome move-to-group 1";
          "${mod}+Alt+Shift+2" = "exec swaysome move-to-group 2";
          "${mod}+Alt+Shift+3" = "exec swaysome move-to-group 3";
          "${mod}+Alt+Shift+4" = "exec swaysome move-to-group 4";
          "${mod}+Alt+Shift+5" = "exec swaysome move-to-group 5";
          "${mod}+Alt+Shift+6" = "exec swaysome move-to-group 6";
          "${mod}+Alt+Shift+7" = "exec swaysome move-to-group 7";
          "${mod}+Alt+Shift+8" = "exec swaysome move-to-group 8";
          "${mod}+Alt+Shift+9" = "exec swaysome move-to-group 9";
          "${mod}+Alt+Shift+0" = "exec swaysome move-to-group 0";

          "${mod}+o" = "exec swaysome next-output";
          "${mod}+Shift+o" = "exec swaysome prev-output";

          "${mod}+Alt+o" = "exec swaysome workspace-group-next-output";
          "${mod}+Alt+Shift+o" = "exec swaysome workspace-group-prev-output";

          "${mod}+Shift+minus" = "move scratchpad";
          "${mod}+minus" = "scratchpad show";

          "${mod}+Shift+c" = "kill";
          "${mod}+Shift+e" =
            "exec swaynag -t warning -m 'You pressed the exit shortcut. Do you really want to exit sway? This will end your Wayland session.' -b 'Yes, exit sway' 'swaymsg exit'";

          "${mod}+r" = "mode resize";
        };
      input = {
        "type:touchpad" = {
          tap = "enabled";
          natural_scroll = "enabled";
        };
        "*" = {
          xkb_layout = "us";
          xkb_options = "caps:escape,compose:ralt";
        };
      };
      output = {
        "DVI-D-1" = {
          resolution = "1920x1080";
          position = "0,0";
        };
        "HDMI-A-1" = {
          resolution = "1920x1080";
          position = "1920,0";
        };
      };

      gaps = {
        bottom = 5;
        horizontal = 5;
        vertical = 5;
        inner = 5;
        left = 5;
        outer = 5;
        right = 5;
        top = 5;
        smartBorders = "off";
        smartGaps = false;
      };


      bars = [
      ];
    };
  };
}
