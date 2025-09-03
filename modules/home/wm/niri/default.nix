{
  pkgs,
  lib,
  config,
  ...
}:
let
  inherit (lib) mkIf;
  cfg = config.meadow.default.wm == "niri";
in
{
  imports = [
    ./services.nix
  ];
  config = mkIf cfg {
    home.packages = [
      pkgs.xfce.thunar
      pkgs.niri
      pkgs.playerctl
      pkgs.wireplumber
      pkgs.xwayland-satellite
      pkgs.wl-clipboard
    ];
    services.gnome-keyring.enable = true;

    xdg.portal = {
      enable = true;
      extraPortals = [ pkgs.xdg-desktop-portal-gnome ];
      configPackages = [ pkgs.niri ];
    };

    # https://github.com/YaLTeR/niri/blob/main/resources/default-config.kdl

    xdg.configFile."niri/config.kdl".text = ''
      input {
          keyboard {
              repeat-delay 600
              repeat-rate 25
              track-layout "global"
          }

          touchpad {
              tap
              //natural-scroll
              dwt
              click-method "clickfinger"
              accel-speed 0.0
          }
          mouse { accel-speed 0.0; }
          trackpoint { accel-speed 0.0; }
          trackball { accel-speed 0.0; }
          warp-mouse-to-focus
          workspace-auto-back-and-forth
      }

      gestures {
          dnd-edge-view-scroll {
              trigger-width 30
              delay-ms 100
              max-speed 1500
          }

          dnd-edge-workspace-switch {
              trigger-height 50
              delay-ms 100
              max-speed 1500
          }

          hot-corners {
              // off
          }
      }

      screenshot-path "~/Pictures/Screenshots/%Y-%m-%d %H-%M-%S.png"

      prefer-no-csd

      output "DP-4" {
        background-color "#25254B"
      }

      output "DP-5" {
        background-color "#25254B"
      }

      overview {
          backdrop-color "#25254B"
          workspace-shadow {
              off
              softness 40.0
              spread 10.0
              color "#00000050"
          }
          zoom 0.700000
      }

      layout {
          gaps 16
          struts {
              left 0
              right 0
              top 0
              bottom 0
          }
          focus-ring {
              width 3
          }
          border { off; }

          center-focused-column "never"
          always-center-single-column
      }

      cursor {
          xcursor-theme "default"
          xcursor-size 24
          hide-when-typing
      }

      hotkey-overlay { skip-at-startup; }

      xwayland-satellite {
          path "${pkgs.xwayland-satellite}/bin/xwayland-satellite"
      }

      binds {
          MouseForward { toggle-overview; }
          Mod+C { center-window; }
          Mod+J { focus-workspace-down; }
          Mod+F { maximize-column; }
          Mod+B { spawn "zen-beta"; }
          Mod+Return { spawn "foot"; }
          Mod+I { consume-or-expel-window-left; }
          Mod+Period { toggle-overview; }
          Mod+H { focus-column-left; }
          Mod+O { consume-or-expel-window-right; }
          Mod+Q { close-window; }
          Mod+R { switch-preset-column-width; }
          Mod+L { focus-column-right; }
          Mod+Shift+Ctrl+L { quit skip-confirmation=true; }
          Mod+Shift+Down { move-column-to-workspace-down; }
          Mod+Shift+End { move-workspace-down; }
          Mod+Shift+F { fullscreen-window; }
          Mod+Shift+J { move-workspace-up; }
          Mod+Shift+H { move-column-left; }
          Mod+Shift+L { move-column-right; }
          Mod+Shift+K { move-column-to-workspace-up; }
          Mod+Space { spawn "vicinae"; }
          Mod+K { focus-workspace-up; }
          Mod+V { spawn "nautilus"; }
          Mod+W { close-window; }
          Print { screenshot; }
          Shift+Print { screenshot-window; }
          XF86AudioLowerVolume { spawn "${pkgs.wireplumber}/bin/wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "5%-"; }
          XF86AudioNext { spawn "${lib.getExe pkgs.playerctl}" "next"; }
          XF86AudioPlay { spawn "${lib.getExe pkgs.playerctl}" "play-pause"; }
          XF86AudioPrev { spawn "${lib.getExe pkgs.playerctl}" "previous"; }
          XF86AudioRaiseVolume { spawn "${pkgs.wireplumber}/bin/wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "5%+"; }
          XF86AudioStop { spawn "${lib.getExe pkgs.playerctl}" "pause"; }
          XF86MonBrightnessDown { spawn "${lib.getExe pkgs.brightnessctl}" "set" "5%-"; }
          XF86MonBrightnessUp { spawn "${lib.getExe pkgs.brightnessctl}" "set" "5%+"; }

          Mod+1 { focus-workspace "code"; }
          Mod+2 { focus-workspace "browser"; }
          Mod+3 { focus-workspace "test"; }
          Mod+4 { focus-workspace "music"; }
          Mod+5 { focus-workspace "slack"; }
      }

      switch-events {
          lid-close { spawn "${lib.getExe pkgs.niri}" "msg" "action" "power-off-monitors"; }
          //"loginctl" "lock-session"
          tablet-mode-on { spawn "bash" "-c" "gsettings set org.gnome.desktop.a11y.applications screen-keyboard-enabled true"; }
          tablet-mode-off { spawn "bash" "-c" "gsettings set org.gnome.desktop.a11y.applications screen-keyboard-enabled false"; }
      }

      window-rule {
          match
          draw-border-with-background false
          geometry-corner-radius 8.0 8.0 8.0 8.0
          clip-to-geometry true
      }

      window-rule {
          match is-active=false
          opacity 0.9
      }

      layer-rule {
          match namespace="notifications"
          block-out-from "screen-capture"
      }

      animations {
          slowdown 0.6
          window-open { off; }
          window-close { off; }
      }

      window-rule {
          match app-id="scrcpy"
          open-floating false;
          default-column-width { fixed 472; }
          geometry-corner-radius 18.0 18.0 18.0 18.0
      }

      workspace "browser" {
          open-on-output "DP-5"
      }

      workspace "slack" {
          open-on-output "DP-5"
      }

      window-rule {
          match at-startup=true app-id="zen-beta"
          open-on-workspace "browser"
      }
      window-rule {
          match at-startup=true app-id="Slack"
          open-on-workspace "slack"
      }
    '';
  };
}
