{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib)
    mkIf
    ;

  cfg = config.opt.music.mpd;
in
{
  # Allows mpd to work with playerctl.
  config = mkIf cfg.enable {
    home.packages = [ pkgs.playerctl ];
    services.mpdris2.enable = true;
    services.playerctld.enable = true;
  };
}
