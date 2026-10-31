{
  pkgs,
  lib,
  config,
  ...
}:
let
  inherit (lib) mkIf;
  cfg = config.meadow.default.wm == "niri";
  # Noctalia and Mandara already ship a notification daemon
  standalone = config.meadow.programs.shell == "none" && !config.meadow.programs.noctalia.enable;
in
{
  config = mkIf (cfg && standalone) {
    home.packages = [ pkgs.libnotify ];

    # https://github.com/emersion/mako/blob/master/doc/mako.5.scd
    services.mako = {
      enable = true;
      settings = {
        actions = true;
        markup = true;
        icons = true;
        layer = "overlay";
        anchor = "top-right";
        border-size = 0;
        border-radius = 10;
        padding = 10;
        width = 330;
        height = 200;
        default-timeout = 5000;
        max-icon-size = 32;
      };
    };
  };
}
