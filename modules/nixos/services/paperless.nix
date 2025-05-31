{ config, lib, ... }:
let
  inherit (lib)
    mkIf
    mkOption
    types
    mkEnableOption
    ;

  host = "paper.elyth.xyz";
  cfg = config.opt.services.paperless;
in
{
  options.opt.services.paperless = {
    enable = mkEnableOption "paperless";
    host = mkOption {
      type = types.str;
      default = "0.0.0.0";
    };
    port = mkOption {
      type = types.int;
      default = 6666;
    };
  };

  config = mkIf cfg.enable {

    services = {
      paperless = {
        enable = true;
        inherit (cfg) port;
        address = cfg.host;
        passwordFile = config.sops.secrets.paperless_password.path;
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
    sops.secrets.paperless_password = { };
  };
}
