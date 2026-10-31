{
  pkgs,
  lib,
  config,
  ...
}:
let
  inherit (lib) mkIf optionalString getExe;
  cfg = config.meadow.default.wm == "niri";

  _ = getExe;

  noctalia = config.meadow.programs.noctalia.enable || config.meadow.programs.shell == "noctalia";
  mandara = config.meadow.programs.shell == "mandara";

  # Get default application
  terminal = config.home.sessionVariables.TERMINAL;

  # OCR (Optical Character Recognition) utility
  ocrScript =
    let
      inherit (pkgs)
        grim
        libnotify
        slurp
        tesseract5
        wl-clipboard
        ;
    in
    pkgs.writeShellScriptBin "wl-ocr" ''
      ${_ grim} -g "$(${_ slurp})" -t ppm - | ${_ tesseract5} - - | ${wl-clipboard}/bin/wl-copy
      ${_ libnotify} "$(${wl-clipboard}/bin/wl-paste)"
    '';

  zellij-attach = pkgs.writeShellScriptBin "zellij-attach" ''
    #! /bin/sh

    session=$(zellij ls -sn | rofi -dmenu -theme ~/.config/rofi/config.rasi -p "zellij session:" )

    if [[ -z $session ]]; then
      exit
    fi

    ${terminal} -e zellij attach --create $session
  '';

  pamixerBin = "${pkgs.pamixer}/bin/pamixer";
  brilloBin = "${pkgs.brillo}/bin/brillo";

  # Mod+[Shift+]{1..10} to focus [move column to] workspace {1..10}
  workspaces = lib.concatMapStringsSep "\n" (
    x:
    let
      key = toString (lib.mod x 10);
    in
    ''
      Mod+${key} { focus-workspace ${toString x}; }
      Mod+Shift+${key} { move-column-to-workspace ${toString x}; }
    ''
  ) (lib.range 1 10);
in
{
  imports = [
    ./services.nix
  ];
  config = mkIf cfg {
    home = {
      packages = with pkgs; [
        brightnessctl
        cliphist
        dbus
        glib
        grim
        gtk3
        libnotify
        pamixer
        playerctl
        slurp
        wf-recorder
        wl-clipboard
        brillo
        wlr-randr
        wtype
        ydotool
        xprop
        xwayland-satellite
        kdePackages.kdeconnect-kde

        ocrScript
        zellij-attach
        pulseaudio
      ];

      sessionVariables = {
        XDG_SESSION_DESKTOP = "niri";
        QT_QPA_PLATFORM = "wayland";
        QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
        SDL_VIDEODRIVER = "wayland";
        CLUTTER_BACKEND = "wayland";
        GDK_BACKEND = "wayland,x11";
        XDG_SESSION_TYPE = "wayland";
        MOZ_ENABLE_WAYLAND = "1";
        ELECTRON_OZONE_PLATFORM_HINT = "auto";
      };
    };

    systemd.user.targets.tray = {
      Unit = {
        Description = "Home Manager System Tray";
        Requires = [ "graphical-session-pre.target" ];
      };
    };

    # https://github.com/YaLTeR/niri/wiki/Configuration:-Introduction
    xdg.configFile."niri/config.kdl".text = ''
      input {
          keyboard {
              xkb {
                  layout "us"
                  options "compose:ralt,caps:escape"
              }
          }

          touchpad {
              tap
              dwt
              natural-scroll
              scroll-factor 0.8
          }
          mouse { accel-profile "flat"; }

          focus-follows-mouse
      }

      output "eDP-1" {
          scale 1
          position x=0 y=0
      }

      // Picks the highest refresh rate available, kanshi handles the other setups
      output "DP-2" {
          mode "2560x1440"
          scale 1
      }

      environment {
          GDK_SCALE "1"
          XDG_SESSION_DESKTOP "niri"
          ELECTRON_OZONE_PLATFORM_HINT "auto"
          LIBVA_DRIVER_NAME "nvidia"
          __GLX_VENDOR_LIBRARY_NAME "nvidia"
          GBM_BACKEND "nvidia-drm"
          __GL_GSYNC_ALLOWED "0"
          __GL_VRR_ALLOWED "0"
          NVD_BACKEND "direct"
      }

      spawn-at-startup "kdeconnect-indicator"

      screenshot-path "~/Pictures/Screenshots/%Y-%m-%d %H-%M-%S.png"

      prefer-no-csd

      hotkey-overlay { skip-at-startup; }

      cursor {
          xcursor-theme "${config.stylix.cursor.name}"
          xcursor-size ${toString config.stylix.cursor.size}
          hide-when-typing
      }

      // X11 clients (Steam, games, ...) run through xwayland-satellite
      xwayland-satellite {
          path "${_ pkgs.xwayland-satellite}"
      }

      layout {
          gaps 12
          center-focused-column "never"
          focus-ring { off; }
          border { off; }
          tab-indicator {
              hide-when-single-tab
              place-within-column
          }
      }

      animations {
          slowdown 0.6
      }

      window-rule {
          geometry-corner-radius 6
          clip-to-geometry true
          draw-border-with-background false
          background-effect {
              blur true
              xray false
          }
      }

      window-rule {
          match is-active=false
          opacity 0.94
      }

      // Games & Steam: no blur/rounding, allow tearing
      window-rule {
          match app-id="^steam_app_"
          match app-id="^gamescope$"
          geometry-corner-radius 0
          opacity 1.0
          background-effect { blur false; }
      }

      blur {
          passes 4
          offset 3.0
      }

      ${optionalString noctalia ''
        // Noctalia, https://docs.noctalia.dev/noctalia/compositor-settings/niri/
        window-rule {
            match app-id="dev.noctalia.Noctalia"
            open-floating true
            default-column-width { fixed 1080; }
            default-window-height { fixed 920; }
        }

        layer-rule {
            match namespace="^noctalia-(bar-[^\"]+|notification|dock|panel|attached-panel|osd)$"
            background-effect { xray false; }
        }
      ''}

      ${optionalString mandara ''
        // Mandara writes its layer rules and binds here, our own binds win on conflicts
        include optional=true "~/.config/mandara/generated/niri.kdl"
        spawn-at-startup "mandara"
      ''}

      debug {
          // Nvidia flickers in the bottom right corner at 4K 240Hz when frames are queued before rendering finishes
          wait-for-frame-completion-before-queueing
          ${optionalString noctalia ''
            // Allows notification actions and window activation from Noctalia
            honor-xdg-activation-with-invalid-serial
          ''}
      }
      binds {
          // Compositor commands
          Ctrl+Shift+Q { quit skip-confirmation=true; }
          Mod+Q { close-window; }
          Mod+F { fullscreen-window; }
          Mod+M { maximize-column; }
          Mod+Space { toggle-window-floating; }
          Mod+Shift+Space { switch-focus-between-floating-and-tiling; }
          Mod+C { center-column; }

          // Tabbed columns (Hyprland groups)
          Mod+G { toggle-column-tabbed-display; }
          Mod+Tab { focus-window-down-or-top; }
          Mod+Shift+Tab { focus-window-up-or-bottom; }
          Mod+BracketLeft { consume-or-expel-window-left; }
          Mod+BracketRight { consume-or-expel-window-right; }

          // Move focus
          Mod+Left { focus-column-left; }
          Mod+Right { focus-column-right; }
          Mod+Up { focus-window-or-workspace-up; }
          Mod+Down { focus-window-or-workspace-down; }

          // Move windows
          Mod+Shift+Left { move-column-left; }
          Mod+Shift+Right { move-column-right; }
          Mod+Shift+Up { move-window-up-or-to-workspace-up; }
          Mod+Shift+Down { move-window-down-or-to-workspace-down; }
          Mod+Ctrl+Left { focus-monitor-left; }
          Mod+Ctrl+Right { focus-monitor-right; }
          Mod+Ctrl+Shift+Left { move-column-to-monitor-left; }
          Mod+Ctrl+Shift+Right { move-column-to-monitor-right; }

          // Resize (Hyprland resize submap)
          Mod+R { switch-preset-column-width; }
          Mod+Minus { set-column-width "-10%"; }
          Mod+Equal { set-column-width "+10%"; }
          Mod+Shift+Minus { set-window-height "-10%"; }
          Mod+Shift+Equal { set-window-height "+10%"; }

          // Overview (Hyprland special workspace)
          Mod+Grave { toggle-overview; }

          // Cycle through workspaces
          Mod+Alt+Up { focus-workspace-up; }
          Mod+Alt+Down { focus-workspace-down; }
          Mod+WheelScrollDown cooldown-ms=150 { focus-workspace-down; }
          Mod+WheelScrollUp cooldown-ms=150 { focus-workspace-up; }

          // Utilities
          Mod+Return { spawn "run-as-service" "${terminal}"; }
          Mod+Shift+Z { spawn "zellij-attach"; }
          Mod+O { spawn "run-as-service" "wl-ocr"; }

          // Screenshot
          Mod+Shift+S { screenshot; }
          Print { screenshot-screen; }
          Alt+Print { screenshot-window; }

          // Launchers
          Mod+D { spawn "vicinae" "open"; }
          Mod+Shift+P { spawn-sh "rofi-rbw --no-help --clipboarder wl-copy --keybindings Alt+x:type:password"; }
          Mod+Shift+E { spawn "bemoji" "-t"; }
          Mod+Shift+O { spawn "wezterm" "start" "--class" "clipse" "clipse"; }

          // Media / hardware keys
          XF86AudioRaiseVolume allow-when-locked=true { spawn "${pamixerBin}" "-i" "5"; }
          XF86AudioLowerVolume allow-when-locked=true { spawn "${pamixerBin}" "-d" "5"; }
          XF86AudioMute allow-when-locked=true { spawn "${pamixerBin}" "-t"; }
          XF86AudioMicMute allow-when-locked=true { spawn "${pamixerBin}" "--default-source" "--toggle-mute"; }
          XF86AudioPlay allow-when-locked=true { spawn "${_ pkgs.playerctl}" "play-pause"; }
          XF86AudioNext allow-when-locked=true { spawn "${_ pkgs.playerctl}" "next"; }
          XF86AudioPrev allow-when-locked=true { spawn "${_ pkgs.playerctl}" "previous"; }
          XF86MonBrightnessUp allow-when-locked=true { spawn "${brilloBin}" "-q" "-A" "10"; }
          XF86MonBrightnessDown allow-when-locked=true { spawn "${brilloBin}" "-q" "-U" "10"; }
      ${optionalString noctalia ''
        // Noctalia
        Mod+S { spawn-sh "noctalia msg panel-toggle control-center"; }
        Mod+Comma { spawn-sh "noctalia msg settings-toggle"; }
        Mod+Escape { spawn-sh "noctalia msg session lock"; }
        Alt+Tab { spawn-sh "noctalia msg window-switcher hold"; }
      ''}
      ${workspaces}
      }
    '';
  };
}
