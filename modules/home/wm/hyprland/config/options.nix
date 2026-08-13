{
  lib,
  ...
}:
let
  mkLuaInline = lib.generators.mkLuaInline;

  # Commands run once when the compositor starts
  exec-once = [
    "xprop -root -f _XWAYLAND_GLOBAL_OUTPUT_SCALE 32c -set _XWAYLAND_GLOBAL_OUTPUT_SCALE 1"
    "dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP XDG_SESSION_TYPE XDG_SESSION_DESKTOP"
    "systemctl --user import-environment PATH XDG_SESSION_TYPE XDG_SESSION_DESKTOP"
    "systemctl --user restart xdg-desktop-portal-hyprland.service"
    "systemctl --user start kanshi.service"
    "kdeconnect-indicator"
  ];
in
{
  wayland.windowManager.hyprland.settings = {
    animation = [
      {
        leaf = "global";
        enabled = true;
        speed = 5;
        bezier = "default";
      }
      {
        leaf = "border";
        enabled = true;
        speed = 5;
        bezier = "easeOutQuart";
      }
      {
        leaf = "windows";
        enabled = true;
        speed = 3;
        bezier = "easeOutQuart";
      }
      {
        leaf = "windowsIn";
        enabled = true;
        speed = 3;
        bezier = "easeOutQuart";
        style = "slide";
      }
      {
        leaf = "windowsOut";
        enabled = true;
        speed = 3;
        bezier = "easeOutQuart";
        style = "slide";
      }
      {
        leaf = "windowsMove";
        enabled = true;
        speed = 3;
        bezier = "easeOutQuart";
        style = "slide";
      }
      {
        leaf = "layers";
        enabled = true;
        speed = 3;
        bezier = "easeOutQuart";
      }
      {
        leaf = "layersIn";
        enabled = true;
        speed = 3;
        bezier = "easeOutQuart";
        style = "fade";
      }
      {
        leaf = "layersOut";
        enabled = true;
        speed = 3;
        bezier = "easeOutQuart";
        style = "fade";
      }
      {
        leaf = "fade";
        enabled = true;
        speed = 3;
        bezier = "easeOutQuart";
      }
      {
        leaf = "fadeIn";
        enabled = true;
        speed = 3;
        bezier = "easeOutQuart";
      }
      {
        leaf = "fadeOut";
        enabled = true;
        speed = 3;
        bezier = "easeOutQuart";
      }
      {
        leaf = "fadeLayersIn";
        enabled = true;
        speed = 3;
        bezier = "easeOutQuart";
      }
      {
        leaf = "fadeLayersOut";
        enabled = true;
        speed = 3;
        bezier = "easeOutQuart";
      }
      {
        leaf = "workspaces";
        enabled = true;
        speed = 5;
        bezier = "easeOutQuart";
        style = "slide";
      }
      {
        leaf = "specialWorkspace";
        enabled = true;
        speed = 5;
        bezier = "easeOutQuart";
        style = "slidevert";
      }
    ];

    config = {
      animations = {
        enabled = true;
      };

      decoration = {
        rounding = 6;
        inactive_opacity = 0.94;

        blur = {
          enabled = true;
          size = 3;
          passes = 4;
          new_optimizations = true;
          ignore_opacity = true;
          xray = false;
        };
      };

      dwindle = {
        # pseudotile = true;
        preserve_split = true;
      };

      general = {
        gaps_in = 8;
        gaps_out = 12;
        border_size = 0;
        layout = "dwindle";
        resize_on_border = true;
        col = {
          active_border = "rgba(88888888)";
          inactive_border = "rgba(00000088)";
        };
        allow_tearing = true;
      };

      gestures = {
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
        kb_options = "compose:ralt,caps:escape";

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
        # vfr = true;
        vrr = 1;
      };

      render = {
        cm_auto_hdr = 0; # Disable auto HDR - keeps HDR for native HDR content only
      };

      xwayland = {
        force_zero_scaling = true;
      };
    };

    curve = [
      {
        _args = [
          "easeOutQuart"
          {
            type = "bezier";
            points = [
              [
                0.25
                1
              ]
              [
                0.5
                1
              ]
            ];
          }
        ];
      }
    ];

    env = [
      {
        _args = [
          "GDK_SCALE"
          "1"
        ];
      }
      {
        _args = [
          "XDG_SESSION_DESKTOP"
          "Hyprland"
        ];
      }
      {
        _args = [
          "LIBVA_DRIVER_NAME"
          "nvidia"
        ];
      }
      {
        _args = [
          "__GLX_VENDOR_LIBRARY_NAME"
          "nvidia"
        ];
      }
      {
        _args = [
          "GBM_BACKEND"
          "nvidia-drm"
        ];
      }
      {
        _args = [
          "__GL_GSYNC_ALLOWED"
          "0"
        ];
      }
      {
        _args = [
          "__GL_VRR_ALLOWED"
          "0"
        ];
      }
      {
        _args = [
          "NVD_BACKEND"
          "direct"
        ];
      }
    ];

    monitor = [
      # output, mode, position, scale
      {
        output = "eDP-1";
        mode = "highres";
        position = "0x0";
        scale = 1;
      }
      {
        output = "DP-2";
        mode = "2560x1440@240";
        position = "auto";
        scale = 1;
      }
      # Dell AW3225QF with HDR (sdrMinLuminance and sdrMaxLuminance use defaults)
      # {
      #   output = "desc:Dell Inc. AW3225QF F1X4YZ3";
      #   mode = "highrr";
      #   position = "auto";
      #   scale = 1.6;
      #   bitdepth = 10;
      #   cm = "hdr";
      #   sdrbrightness = 2;
      #   sdrsaturation = 1.0;
      #   vrr = 0;
      # }
    ];

    on = {
      _args = [
        "hyprland.start"
        (mkLuaInline ''
          function()
            ${lib.concatMapStringsSep "\n" (cmd: "  hl.exec_cmd(${lib.generators.toLua { } cmd})") exec-once}
          end
        '')
      ];
    };
  };
}
