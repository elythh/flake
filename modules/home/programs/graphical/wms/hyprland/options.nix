{
  wayland.windowManager.hyprland.settings = {
    exec-once = [

    ];
    animations = {
      enabled = true;

      bezier = [ "md3_decel, 0.05, 0.7, 0.1, 1" ];

      animation = [
        "border, 1, 2, default"
        "fade, 1, 2, md3_decel"
        "windows, 1, 4, md3_decel, popin 60%"
        "workspaces, 1, 4, md3_decel, slidevert"
      ];
    };

    decoration = {
      rounding = "6";
      drop_shadow = "true";
      shadow_range = "16";
      "col.shadow" = "rgba(050505ff)";
      shadow_render_power = "12";
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
      "WLR_DRM_NO_ATOMIC,1"
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
      swallow_regex = "thunar|nemo|wezterm|waybar"; # windows for which swallow is applied
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
      "eDP-1, 1920x1080, 0x0, 1"
    ];

    xwayland.force_zero_scaling = true;
  };
}
