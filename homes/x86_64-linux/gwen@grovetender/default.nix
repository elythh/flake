{
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (lib.${namespace}) enabled;
in
{
  elyth = {
    user = {
      enable = true;
      inherit (config.snowfallorg.user) name;
    };

    programs = {
      graphical = {
        apps = {
          thunderbird = enabled;
          zathura = enabled;
        };

        bars = {
          waybar = {
            fullSizeOutputs = [
              "DP-1"
              "HDMI-A-1"
            ];
            condensedOutputs = [ "DP-3" ];
          };
        };

        browsers = {
          firefox = {
            gpuAcceleration = true;
            hardwareDecoding = true;
          };
        };

        wms = {
          hyprland = {
            enable = true;
            # enableDebug = true;

            appendConfig = # bash
              ''
                exec-once = hyprctl setcursor ${config.${namespace}.theme.gtk.cursor.name} ${
                  builtins.toString config.${namespace}.theme.gtk.cursor.size
                }
              '';

          };
        };
      };

      terminal = {
        tools = {
          git = {
            enable = true;
          };

          run-as-service = enabled;
          ssh = enabled;
        };
      };
    };

    services = {
      hyprpaper = enabled;

      rnnoise = enabled;

      sops = {
        enable = true;
        defaultSopsFile = lib.snowfall.fs.get-file "secrets/gwen/secrets.yaml";
        sshKeyPaths = [ "${config.home.homeDirectory}/.ssh/id_ed25519" ];
      };
    };

    system = {
      xdg = enabled;
    };

    suites = {
      art = enabled;
      business = enabled;
      common = enabled;
      desktop = enabled;

      development = {
        enable = true;

        dockerEnable = true;
        gameEnable = true;
        kubernetesEnable = true;
        nixEnable = true;
        sqlEnable = true;
      };

      emulation = enabled;
      games = enabled;
      music = enabled;
      networking = enabled;
      photo = enabled;
      social = enabled;
      video = enabled;
    };

    theme.stylix = enabled;
  };

  home.stateVersion = "24.05";
}
