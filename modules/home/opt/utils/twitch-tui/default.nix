{ config, pkgs, ... }:
let
in
{

  config = {
    home.packages = [ pkgs.twitch-tui ];

    sops.secrets = {
      twitch-tui = {
        path = "${config.home.homeDirectory}/.config/twt/config.toml";
      };
    };
  };
}
