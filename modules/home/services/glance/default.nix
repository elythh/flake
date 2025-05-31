{
  config,
  lib,
  ...
}: let
  inherit
    (lib)
    mkIf
    mkOption
    types
    mkEnableOption
    ;

  cfg = config.meadow.services.glance;
in {
  options.meadow.services.glance = {
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
                      timezones = [{timezone = "Europe/Paris";}];
                    }
                    {type = "calendar";}
                    {
                      type = "weather";
                      location = "Paris, France";
                    }
                  ];
                }
                {
                  size = "full";
                  widgets = [
                    {type = "hacker-news";}
                    {type = "lobsters";}
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
