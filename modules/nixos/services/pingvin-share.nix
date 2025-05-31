{ config, lib, ... }:
let
  inherit (lib)
    mkIf
    mkOption
    types
    mkEnableOption
    ;

  hostname = "share.elyth.xyz";
  cfg = config.opt.services.pingvin-share;
in
{
  options.opt.services.pingvin-share = {
    enable = mkEnableOption "pingvin-share";
    hostname = mkOption {
      type = types.str;
      default = "0.0.0.0";
    };
    frontPort = mkOption {
      type = types.int;
      default = 2323;
    };
    backPort = mkOption {
      type = types.int;
      default = 2424;
    };
  };

  config = mkIf cfg.enable {

    services = {
      pingvin-share = {
        enable = true;
        frontend = {
          port = cfg.frontPort;
        };
        backend = {
          port = cfg.backPort;
        };
        dataDir = "/media/share";
      };
      cloudflared.tunnels = {
        "9f52eb17-9286-4b74-8526-28094e48f79f" = {
          credentialsFile = config.sops.secrets.cloudflared-tunnel-creds.path;
          default = "http_status:404";
          ingress = {
            ${hostname} = {
              service = "http://localhost:${builtins.toString cfg.frontPort}";
            };
          };
        };
      };
    };
  };
}
