{
  wayland.windowManager.mango.settings = {
    # ===== STARTUP =====
    exec-once = [
      "xprop -root -f _XWAYLAND_GLOBAL_OUTPUT_SCALE 32c -set _XWAYLAND_GLOBAL_OUTPUT_SCALE 1"
      "dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP XDG_SESSION_TYPE XDG_SESSION_DESKTOP"
      "systemctl --user import-environment PATH XDG_SESSION_TYPE XDG_SESSION_DESKTOP"
      "systemctl --user start kanshi.service"
      "vicinae server"
    ];

    # Environment variables moved to extraConfig (see bottom of file)

    # ===== DIMENSIONS (Borders & Gaps) =====
    borderpx = 0; # Border width (you had this disabled)
    gappih = 8; # Horizontal inner gap
    gappiv = 8; # Vertical inner gap
    gappoh = 12; # Horizontal outer gap
    gappov = 12; # Vertical outer gap

    # ===== COLORS =====
    rootcolor = "0x323232ff";
    bordercolor = "0x444444ff"; # Inactive border
    focuscolor = "0x88888888"; # Active border (from your Hyprland config)
    urgentcolor = "0xad401fff";

    # State-specific colors
    maximizescreencolor = "0x89aa61ff";
    scratchpadcolor = "0x516c93ff";
    globalcolor = "0xb153a7ff";
    overlaycolor = "0x14a57cff";

    # ===== CURSOR =====
    cursor_size = 24;
    cursor_theme = "Adwaita";

    # ===== ANIMATIONS =====
    animations = 1;
    layer_animations = 1;
    animation_type_open = "zoom";
    animation_type_close = "fade";
    layer_animation_type_open = "slide";
    layer_animation_type_close = "slide";

    # Animation durations (in milliseconds)
    animation_duration_move = 300;
    animation_duration_open = 300;
    animation_duration_tag = 300;
    animation_duration_close = 300;
    animation_duration_focus = 0;

    # Bezier curves (easeOutQuart-like from Hyprland)
    animation_curve_open = "0.25,1.0,0.5,1.0";
    animation_curve_move = "0.25,1.0,0.5,1.0";
    animation_curve_tag = "0.25,1.0,0.5,1.0";
    animation_curve_close = "0.25,1.0,0.5,1.0";

    # Fade settings
    animation_fade_in = 1;
    animation_fade_out = 1;
    fadein_begin_opacity = 0.5;
    fadeout_begin_opacity = 0.94; # Match your inactive opacity

    # ===== EFFECTS =====
    # Blur (matching your Hyprland config: size 3, passes 4)
    blur = 1;
    blur_optimized = 1; # IMPORTANT: keeps performance good
    blur_params_radius = 3;
    blur_params_num_passes = 4;
    blur_params_noise = 0.02;
    blur_params_brightness = 0.9;
    blur_params_contrast = 0.9;
    blur_params_saturation = 1.2;

    # Shadows
    shadows = 0; # Disabled to match your Hyprland (you had no shadows)
    shadow_only_floating = 1;

    # Corner radius (matching your Hyprland: rounding 6)
    border_radius = 6;
    no_radius_when_single = 0;

    # Opacity
    focused_opacity = 1.0;
    unfocused_opacity = 0.94; # Match your Hyprland inactive_opacity

    # ===== INPUT DEVICES =====
    # Keyboard
    repeat_rate = 25;
    repeat_delay = 600;
    xkb_rules_layout = "us";
    xkb_rules_options = "compose:rctrl,caps:escape";

    # Mouse
    mouse_accel_profile = 1; # Flat (match your Hyprland)
    mouse_accel_speed = 0.0;

    # Touchpad
    tap_to_click = 1;
    trackpad_natural_scrolling = 1;
    disable_while_typing = 1;
    trackpad_accel_profile = 1; # Flat
    trackpad_scroll_factor = 0.8;
  };

  # ===== ENVIRONMENT VARIABLES & EXTRA CONFIG =====
  # Environment variables go in extraConfig
  wayland.windowManager.mango.extraConfig = ''
    # Monitor configuration
    monitorrule=make:Dell Inc.,model:AW3225QF,width:3840,height:2160,refresh:240,scale:1.6,x:0,y:0,vrr:0

    # Environment variables
    env = GDK_SCALE,1
    env = XDG_SESSION_DESKTOP,Mango
    env = LIBVA_DRIVER_NAME,nvidia
    env = __GLX_VENDOR_LIBRARY_NAME,nvidia
    env = GBM_BACKEND,nvidia-drm
    env = __GL_GSYNC_ALLOWED,0
    env = __GL_VRR_ALLOWED,0
    env = NVD_BACKEND,direct
  '';
}
