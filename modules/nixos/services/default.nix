{
  lib,
  config,
  pkgs,
  ...
}:
let
  inherit (lib)
    mkIf
    mkEnableOption
    ;
in
{
  options.meadow.services = {
    pipewire.enable = mkEnableOption "pipewire";
  };
  config = {
    services = {
      gvfs.enable = true;
      blueman.enable = true;
      dbus.enable = true;
      upower.enable = true;
      logind = {
        settings.Login = {
          HandlePowerKey = "suspend";
          HandleLidSwitch = "suspend";
          HandleLidSwitchExternalPower = "lock";
        };
      };

      tailscale = mkIf config.meadow.programs.tailscale.enable { enable = true; };

      xserver.enable = true;
      xserver.xkb = {
        layout = "us";
      };

      xserver.xkb.options = "compose:rctrl,caps:escape";

      # pipewire is newer and just better
      pipewire = mkIf config.meadow.services.pipewire.enable {
        enable = true;

        audio.enable = true;
        pulse.enable = true;
        jack.enable = true;

        alsa = {
          enable = true;
          support32Bit = true;
        };

        extraLadspaPackages = [ pkgs.deepfilternet ];

        extraConfig.pipewire = {
          "99-deepfilter" = {
            "context.modules" = [
              {
                name = "libpipewire-module-filter-chain";
                args = {
                  "node.description" = "DeepFilter Noise Canceling Source";
                  "media.name" = "DeepFilter Noise Canceling Source";
                  "filter.graph" = {
                    nodes = [
                      {
                        type = "ladspa";
                        name = "df";
                        plugin = "libdeep_filter_ladspa";
                        label = "deep_filter_mono";
                        control = {
                          "Attenuation Limit (dB)" = 40;
                        };
                      }
                    ];
                  };
                  "capture.props" = {
                    "node.name" = "capture.deepfilter_input";
                    "node.passive" = true;
                    "audio.rate" = 48000;
                  };
                  "playback.props" = {
                    "node.name" = "deepfilter_output";
                    "media.class" = "Audio/Source";
                    "audio.rate" = 48000;
                  };
                };
              }
            ];
          };

          "10-loopback" = {
            "context.modules" = [
              {
                "node.description" = "playback loop";
                "audio.position" = [
                  "FL"
                  "FR"
                ];

                "capture.props" = {
                  "node.name" = "playback_sink";
                  "node.description" = "playback-sink";
                  "media.class" = "Audio/Sink";
                };

                "playback.props" = {
                  "node.name" = "playback_sink.output";
                  "node.description" = "playback-sink-output";
                  "media.class" = "Audio/Source";
                  "node.passive" = true;
                };
              }
            ];
          };
        };
      };

      gnome = {
        gnome-keyring.enable = true;
        glib-networking.enable = true;
      };

      # greetd = mkIf config.meadow.programs.wayland.enable {
      #   enable = true;
      #   settings = {
      #     terminal.vt = 1;
      #     default_session = {
      #       command = concatStringsSep " " [
      #         (getExe pkgs.greetd.tuigreet)
      #         "--time"
      #         "--remember"
      #         "--remember-user-session"
      #         "--asterisks"
      #         "--sessions 'hyprland'"
      #         "--cmd 'start-hyprland'"
      #       ];
      #       user = "greeter";
      #     };
      #   };
      # };
    };
    systemd.user.services = {
      pipewire.wantedBy = [ "default.target" ];
      pipewire-pulse.wantedBy = [ "default.target" ];
    };
  };
}
