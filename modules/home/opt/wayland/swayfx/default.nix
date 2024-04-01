{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
lib.mkIf config.modules.swayfx.enable {
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
      wlprop
      wl-clipboard
      wl-screenrec
      wlr-randr
      wtype
      sassc
      satty
      xdg-utils
      ydotool
      wlr-randr
    ];
  };

  systemd.user.targets.hyprland-session.Unit.Wants = ["xdg-desktop-autostart.target"];
  wayland.windowManager.sway = with config.colorscheme.palette; {
    enable = true;
    systemd.enable = true;
    xwayland = true;
    package = inputs.swayfx.packages.${pkgs.system}.default;
    extraConfig = ''
      ## SWAYFX CONFIG
      corner_radius 14
      shadows on
      shadow_offset 0 0
      shadow_blur_radius 20
      shadow_color #000000BB

       default_dim_inactive 0.2

       layer_effects "notif" blur enable; shadows enable; corner_radius 20
       layer_effects "osd" blur enable; shadows enable; corner_radius 20
       layer_effects "work"  shadows enable
       layer_effects "panel" shadows enable
       layer_effects "calendarbox"shadows enable; corner_radius 12
       for_window [app_id="spad"] move scratchpad, resize set width 900 height 600
       for_window [class="discord"] move scratchpad, resize set width 900 height 600
       for_window [class="obsidian"] move scratchpad
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
      # titlebar_separator enable
      # titlebar_padding 6
      # title_align center
       default_border none
       default_floating_border normal 2

       exec_always --no-startup-id xrdb -merge ~/.Xresources &
       exec_always discord &
       exec_always --no-startup-id copyq &
       exec_always --no-startup-id kanshi &
       exec_always --no-startup-id nm-applet &
       exec --no-startup-id ags &
       exec_always --no-startup-id swaysome init 0 &
       exec_always --no-startup-id mpDris2 &
       exec_always --no-startup-id autotiling-rs &

       output * bg ${config.wallpaper} fill
    '';
    config = {
      terminal = "wezterm";
      menu = "ags -t launcher";
      modifier = "Mod4";

      keycodebindings = let
        cfg = config.wayland.windowManager.sway.config;
        mod = cfg.modifier;
        left = "43"; # h
        down = "44"; # j
        up = "45"; # k
        right = "46"; # l
      in {
        "${mod}+${left}" = "focus left";
        "${mod}+${down}" = "focus down";
        "${mod}+${up}" = "focus up";
        "${mod}+${right}" = "focus right";

        "${mod}+Shift+${left}" = "move left";
        "${mod}+Shift+${down}" = "move down";
        "${mod}+Shift+${up}" = "move up";
        "${mod}+Shift+${right}" = "move right";
      };

      keybindings = let
        cfg = config.wayland.windowManager.sway.config;
        mod = cfg.modifier;
        screenshot_satty = ''
          grim -g "$(slurp)" - | satty --early-exit -f - --copy-command wl-copy --fullscreen --output-filename ~/Pictures/Screenshots/satty-$(date '+%Y%m%d-%H:%M:%S').png'';
      in {
        "${mod}+Shift+s" = "exec ${screenshot_satty}";
        "${mod}+Ctrl+s" = "exec ~/.local/bin/captureWindow";

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

        "${mod}+v" = "exec 'swayscratch spad'";
        "${mod}+z" = "exec 'swayscratch smusicpad'";

        "${mod}+Left" = "focus left";
        "${mod}+Down" = "focus down";
        "${mod}+Up" = "focus up";
        "${mod}+Right" = "focus right";

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
        "${mod}+Shift+e" = "exec swaynag -t warning -m 'You pressed the exit shortcut. Do you really want to exit sway? This will end your Wayland session.' -b 'Yes, exit sway' 'swaymsg exit'";

        "${mod}+r" = "mode resize";
      };
      input = {
        "type:touchpad" = {
          tap = "enabled";
          natural_scroll = "enabled";
        };
        "*" = {
          xkb_layout = "us";
          xkb_options = "compose:rctrl,caps:escape";
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

      bars = [];
    };
  };
}
