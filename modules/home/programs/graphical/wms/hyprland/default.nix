{
  config,
  inputs,
  lib,
  pkgs,
  system,
  namespace,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption getExe;
  inherit (lib.${namespace}) enabled;
  inherit (inputs) hyprland;

  cfg = config.${namespace}.programs.graphical.wms.hyprland;

  _ = lib.getExe;

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

  # Volume control utility
  volumectl =
    let
      inherit (pkgs) libnotify pamixer libcanberra-gtk3;
    in
    pkgs.writeShellScriptBin "volumectl" ''
      #!/usr/bin/env bash

      case "$1" in
      up)
        ${_ pamixer} -i "$2"
        ;;
      down)
        ${_ pamixer} -d "$2"
        ;;
      toggle-mute)
        ${_ pamixer} -t
        ;;
      esac

      volume_percentage="$(${_ pamixer} --get-volume)"
      isMuted="$(${_ pamixer} --get-mute)"

      if [ "$isMuted" = "true" ]; then
        ${libnotify}/bin/notify-send --transient \
          -u normal \
          -a "VOLUMECTL" \
          -i audio-volume-muted-symbolic \
          "VOLUMECTL" "Volume Muted"
      else
        ${libnotify}/bin/notify-send --transient \
          -u normal \
          -a "VOLUMECTL" \
          -h string:x-canonical-private-synchronous:volumectl \
          -h int:value:"$volume_percentage" \
          -i audio-volume-high-symbolic \
          "VOLUMECTL" "Volume: $volume_percentage%"

        ${libcanberra-gtk3}/bin/canberra-gtk-play -i audio-volume-change -d "volumectl"
      fi
    '';

  # Brightness control utility
  lightctl =
    let
      inherit (pkgs) libnotify brightnessctl;
    in
    pkgs.writeShellScriptBin "lightctl" ''
      case "$1" in
      up)
        ${_ brightnessctl} -q s +"$2"%
        ;;
      down)
        ${_ brightnessctl} -q s "$2"%-
        ;;
      esac

      brightness_percentage=$((($(${_ brightnessctl} g) * 100) / $(${_ brightnessctl} m)))
      ${libnotify}/bin/notify-send --transient \
        -u normal \
        -a "LIGHTCTL" \
        -h string:x-canonical-private-synchronous:lightctl \
        -h int:value:"$brightness_percentage" \
        -i display-brightness-symbolic \
        "LIGHTCTL" "Brightness: $brightness_percentage%"
    '';
in
{
  options.${namespace}.programs.graphical.wms.hyprland = {
    enable = mkEnableOption "Hyprland.";
    enableDebug = mkEnableOption "Enable debug mode.";
    appendConfig = lib.mkOption {
      type = lib.types.lines;
      default = "";
      description = ''
        Extra configuration lines to add to bottom of `~/.config/hypr/hyprland.conf`.
      '';
    };
    prependConfig = lib.mkOption {
      type = lib.types.lines;
      default = "";
      description = ''
        Extra configuration lines to add to top of `~/.config/hypr/hyprland.conf`.
      '';
    };
  };

  imports = lib.snowfall.fs.get-non-default-nix-files ./.;

  config = mkIf cfg.enable {
    home = {
      packages = with pkgs; [
        config.wayland.windowManager.hyprland.package

        autotiling-rs
        brightnessctl
        cliphist
        glib
        grim
        gtk3
        hyprpicker
        libcanberra-gtk3
        libnotify
        pamixer
        sassc
        slurp
        wf-recorder
        wl-clipboard
        wl-screenrec
        wlr-randr
        wlr-randr
        wtype
        ydotool
        wlprop
        xorg.xprop

        ocrScript
        volumectl
        lightctl
      ];

      sessionVariables = {
        CLUTTER_BACKEND = "wayland";
        GDK_BACKEND = "wayland,x11";
        MOZ_ENABLE_WAYLAND = "1";
        MOZ_USE_XINPUT2 = "1";
        SDL_VIDEODRIVER = "wayland";
        WLR_DRM_NO_ATOMIC = "1";
        XDG_SESSION_TYPE = "wayland";
        _JAVA_AWT_WM_NONREPARENTING = "1";
        __GL_GSYNC_ALLOWED = "0";
        __GL_VRR_ALLOWED = "0";
      };
    };

    elyth = {
      programs = {
        graphical = {
          launchers = {
            anyrun = enabled;
            rofi = enabled;
          };

          screenlockers = {
            hyprlock = enabled;
          };
        };
      };

      services = {
        cliphist.systemdTargets = [ "hyprland-session.target" ];

        hypridle = enabled;

        hyprpaper = {
          enable = true;
        };

        kanshi = enabled;
      };

      suites = {
        wlroots = enabled;
      };

      theme = {
        gtk = enabled;
        qt = enabled;
      };

    };

    wayland.windowManager.hyprland = {
      enable = true;

      extraConfig = # bash
        ''
          ${cfg.prependConfig}

          ${cfg.appendConfig}
        '';

      package =
        if cfg.enableDebug then
          hyprland.packages.${system}.hyprland-debug
        else
          hyprland.packages.${system}.hyprland;

      settings = {
        exec = [ "${getExe pkgs.libnotify} --icon ~/.face -u normal \"Hello $(whoami)\"" ];
      };

      systemd = {
        enable = true;
        enableXdgAutostart = true;
        extraCommands = [
          "systemctl --user stop hyprland-session.target"
          "systemctl --user reset-failed"
          "systemctl --user start hyprland-session.target"
        ];

        variables = [ "--all" ];
      };

      xwayland.enable = true;
    };
  };
}
