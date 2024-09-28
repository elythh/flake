{ config, lib, ... }:
let
  inherit (lib) mkIf mkOption mkEnableOption;

  cfg = config.opt.services.cloudflared-tunnel;
in
{

  options.opt.services.cloudflared-tunnel = {
    enable = mkEnableOption "cloudflared-tunnel";
  };

  config = mkIf cfg.enable {
    services.cloudflared = {
      enable = true;
      tunnels = {
        "9f52eb17-9286-4b74-8526-28094e48f79f" = {
          credentialsFile = config.sops.secrets.cloudflared-tunnel-creds.path;
          default = "http_status:404";
          ingress = {
            "photo.coopteam.work" = {
              service = "http://localhost:3333";
            };
          };
        };
      };
    };
    sops.secrets.cloudflared-tunnel-creds = {
      path = "/run/secret/cloudflare";
      mode = "0777";
    };
  };
}
