{ config, lib, ... }:
let
  inherit (lib)
    mkIf
    mkOption
    types
    mkEnableOption
    ;

  host = "task.elyth.xyz";
  cfg = config.opt.services.vikunja;
in
{
  options.opt.services.vikunja = {
    enable = mkEnableOption "Vikunja";
    host = mkOption {
      type = types.str;
      default = "0.0.0.0";
    };
    port = mkOption {
      type = types.int;
      default = 4444;
    };
  };

  config = mkIf cfg.enable {

    services = {
      vikunja = {
        enable = true;
        inherit (cfg) port;
        frontendHostname = host;
        frontendScheme = "https";
        settings = {
          service = {
            enableregistration = false;
          };
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
