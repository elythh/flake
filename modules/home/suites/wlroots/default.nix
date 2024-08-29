{
  config,
  lib,
  namespace,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf;
  inherit (lib.${namespace}) mkBoolOpt enabled;

  cfg = config.${namespace}.suites.wlroots;
in
{
  options.${namespace}.suites.wlroots = {
    enable = mkBoolOpt false "Whether or not to enable common wlroots configuration.";
  };

  config = mkIf cfg.enable {
    home.packages = [
      pkgs.wdisplays
      pkgs.wl-clipboard
      pkgs.wlr-randr
      pkgs.wl-screenrec
    ];

    elyth = {
      programs = {
        graphical = {
          addons = {
            swappy = enabled;
            swaync = enabled;
            hyprlock = enabled;
          };

          bars = {
            waybar = enabled;
          };
        };
      };

      services = {
        cliphist = enabled;
        keyring = enabled;
      };
    };

    # using nixos module
    # services.network-manager-applet.enable = true;
    services = {
      blueman-applet.enable = true;
    };
  };
}
