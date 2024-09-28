{
  config,
  lib,
  ...
}:
let
  inherit (lib)
    mkIf
    mkOption
    types
    mkEnableOption
    ;

  background-color =
    if config.theme == "paradise" then
      "0 0 8"
    else if config.theme == "aquarium" then
      "240 14 15"
    else
      "120 0 0";
  primary-color =
    if config.theme == "paradise" then
      "0 10 90"
    else if config.theme == "aquarium" then
      "232 19 32"
    else
      "120 0 0";
  cfg = config.opt.services.glance;
in
{
  options.opt.services.glance = {
    enable = mkEnableOption "Glance";
    host = mkOption {
      type = types.str;
      default = "0.0.0.0";
    };
    port = mkOption {
      type = types.int;
      default = 5555;
    };
  };

  config = mkIf cfg.enable {
    services = {
      glance = {
        enable = true;
        settings = {
          server = {
            inherit (cfg) port host;
          };
          theme = {
            inherit background-color primary-color;
            contrast-multiplier = 1.1;
          };
          pages = [
            {
              name = "Home";
              columns = [
                {
                  size = "small";
                  widgets = [
                    {
                      type = "bookmarks";
                      groups = lib.lists.singleton {
                        links = [
                          {
                            title = "Mail";
                            url = "https://app.tuta.com";
                          }
                          {
                            title = "GitHub";
                            url = "https://github.com";
                          }
                          {
                            title = "NixOS Status";
                            url = "https://status.nixos.org";
                          }
                        ];
                      };
                    }
                    {
                      type = "clock";
                      hour-format = "24h";
                      timezones = [ { timezone = "Europe/Paris"; } ];
                    }
                    { type = "calendar"; }
                    {
                      type = "weather";
                      location = "Paris, France";
                    }
                  ];
                }
                {
                  size = "full";
                  widgets = [
                    { type = "hacker-news"; }
                    { type = "lobsters"; }
                    {
                      type = "reddit";
                      subreddit = "neovim";
                    }
                    {
                      type = "reddit";
                      subreddit = "unixporn";
                    }
                  ];
                }
              ];
            }
          ];
        };
      };
    };
  };
}
