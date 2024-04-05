{
  config,
  lib,
  pkgs,
  ...
}: {
  # Allows mpd to work with playerctl.
  config = lib.mkIf config.modules.mpd.enable {
    home.packages = [pkgs.playerctl];
    services.mpdris2.enable = true;
    services.playerctld.enable = true;
  };
}
