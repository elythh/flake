{
  config,
  lib,
  pkgs,
  namespace,
  ...
}:
let
  inherit (lib) mkIf;
  inherit (lib.${namespace}) mkBoolOpt;

  cfg = config.${namespace}.suites.music;
in
{
  options.${namespace}.suites.music = {
    enable = mkBoolOpt false "Whether or not to enable common music configuration.";
  };

  config = mkIf cfg.enable {
    home.packages =
      with pkgs;
      [
        musikcube
        pulsemixer
      ]
      ++ lib.optionals pkgs.stdenv.isLinux [
        ardour
        mpd-notification
        mpdevil
        spicetify-cli
        tageditor
        youtube-music
      ];
  };
}
