{ lib, config, ... }:
let
  inherit (lib)
    mkIf
    mkOption
    types
    mkEnableOption
    ;

  cfg = config.opt.services.immich;
in
{
  options.opt.services.immich = {
    enable = mkEnableOption "immich";
    host = mkOption {
      type = types.str;
      default = "0.0.0.0";
    };
    port = mkOption {
      type = types.int;
      default = 3333;
    };

  };
  config = mkIf cfg.enable {
    services = {
      immich = {
        enable = true;
        inherit (cfg) port host;
      };
      cloudflared.tunnels = {
        "9f52eb17-9286-4b74-8526-28094e48f79f" = {
          credentialsFile = config.sops.secrets.cloudflared-tunnel-creds.path;
          default = "http_status:404";
          ingress = {
            "photo.elyth.xyz" = {
              service = "http://localhost:${builtins.toString cfg.port}";
            };
          };
        };
      };
    };
  };
}
