{
  wayland.windowManager.hyprland.settings = {
    exec-once = [
      "clipse -listen"
      "wl-paste --type text --watch cliphist store"
      "wl-paste --type text --watch cliphist store"
      "wl-paste --type image --watch cliphist store"
      "xprop -root -f _XWAYLAND_GLOBAL_OUTPUT_SCALE 32c -set _XWAYLAND_GLOBAL_OUTPUT_SCALE 1"
      "dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"
      "systemctl --user import-environment PATH"
      "systemctl --user restart xdg-desktop-portal.service"
      "systemctl --user restart xdg-desktop-portal-wlr.service"
    ];
    animations = {
      enabled = true;
      first_launch_animation = true;

      bezier = [
        "easeOutQuart, 0.25, 1, 0.5, 1"
      ];

      animation = [
        "global, 1, 5, default"
        "border, 1, 5, easeOutQuart"
        "windows, 1, 3, easeOutQuart"
        "windowsIn, 1, 3, easeOutQuart, slide"
        "windowsOut, 1, 3, easeOutQuart, slide"
        "windowsMove, 1, 3, easeOutQuart, slide"
        "layers, 1, 3, easeOutQuart"
        "layersIn, 1, 3, easeOutQuart, fade"
        "layersOut, 1, 3, easeOutQuart, fade"
        "fade, 1, 3, easeOutQuart"
        "fadeIn, 1, 3, easeOutQuart"
        "fadeOut, 1, 3, easeOutQuart"
        "fadeLayersIn, 1, 3, easeOutQuart"
        "fadeLayersOut, 1, 3, easeOutQuart"
        "workspaces, 1, 5, easeOutQuart, slide"
        "specialWorkspace, 1, 5, easeOutQuart, slidevert"
      ];
    };

    decoration = {
      rounding = "6";
      inactive_opacity = "0.94";

      blur = {
        enabled = "yes";
        size = "3";
        passes = "4";
        new_optimizations = "on";
        ignore_opacity = "on";
        xray = "false";
      };
    };

    dwindle = {
      pseudotile = true;
      preserve_split = true;
    };

    env = [
      "GDK_SCALE,1"
      "WLR_DRM_NO_ATOMIC,1"
      "XDG_SESSION_DESKTOP,Hyprland"
    ];

    general = {
      gaps_in = "8";
      gaps_out = "12";
      border_size = "0";
      layout = "dwindle";
      resize_on_border = "true";
      "col.active_border" = "rgba(88888888)";
      "col.inactive_border" = "rgba(00000088)";

      allow_tearing = true;
    };

    gestures = {
      workspace_swipe = true;
      workspace_swipe_forever = true;
    };

    group = {
      groupbar = {
        font_size = 16;
        gradients = false;
      };
    };

    input = {
      kb_layout = "us";
      kb_options = "compose:rctrl,caps:escape";

      accel_profile = "flat";
      follow_mouse = 1;

      touchpad = {
        disable_while_typing = true;
        natural_scroll = true;
        scroll_factor = 0.8;
      };
    };

    misc = {
      enable_swallow = true; # hide windows that spawn other windows
      swallow_regex = "nemo|wezterm|waybar"; # windows for which swallow is applied
      disable_autoreload = false;
      disable_hyprland_logo = true;
      disable_splash_rendering = true;
      focus_on_activate = true;
      force_default_wallpaper = 0;
      key_press_enables_dpms = true;
      mouse_move_enables_dpms = true;
      vfr = true;
      vrr = 1;
    };

    monitor = [
      # name, resolution, position, scale
      "eDP-1, highres, 0x0, 1"
    ];

    xwayland.force_zero_scaling = true;
  };
}
