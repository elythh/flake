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
    };
    sops.secrets.cloudflared-tunnel-creds = {
      path = "/run/secret/cloudflare";
      mode = "0777";
    };
  };
}
