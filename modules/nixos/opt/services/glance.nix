{ config, lib, ... }:
let
  inherit (lib)
    mkIf
    mkOption
    types
    mkEnableOption
    ;

  host = "home.elyth.xyz";
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
            background-color = "240 13 14";
            primary-color = "50 33 68";
            negative-color = "358 100 68";
            contrast-multiplier = 1.2;
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
      cloudflared.tunnels = {
        "9f52eb17-9286-4b74-8526-28094e48f79f" = {
          credentialsFile = config.sops.secrets.cloudflared-tunnel-creds.path;
          default = "http_status:404";
          ingress = {
            ${host} = {
              service = "http://localhost:${builtins.toString cfg.port}";
            };
          };
        };
      };
    };
  };
}
