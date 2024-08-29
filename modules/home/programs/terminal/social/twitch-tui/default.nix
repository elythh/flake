{
  config,
  pkgs,
  namespace,
  lib,
  ...
}:
let
  inherit (lib) mkIf;
  inherit (lib.${namespace}) mkBoolOpt;

  cfg = config.${namespace}.programs.terminal.social.twitch-tui;
in
{
  options.${namespace}.programs.terminal.social.twitch-tui = {
    enable = mkBoolOpt false "Enable twitch-tui";
  };
  config = mkIf cfg.enable {
    home.packages = [ pkgs.twitch-tui ];

    sops.secrets = {
      twitch-tui = {
        path = "${config.home.homeDirectory}/.config/twt/config.toml";
      };
    };
  };
}
