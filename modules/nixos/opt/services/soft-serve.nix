{ config, lib, ... }:
let
  inherit (lib)
    mkIf
    mkOption
    types
    mkEnableOption
    ;

  host = "git.elyth.xyz";
  cfg = config.opt.services.soft-serve;
in
{
  options.opt.services.soft-serve = {
    enable = mkEnableOption "soft-serve";
    host = mkOption {
      type = types.str;
      default = "0.0.0.0";
    };
    port = mkOption {
      type = types.int;
      default = 9999;
    };
  };

  config = mkIf cfg.enable {

    services = {
      soft-serve = {
        enable = true;
        settings = {
          name = "elyth's repos";
          log_format = "text";
          ssh = {
            listen_addr = ":${builtins.toString cfg.port}";
            public_url = "ssh://git.elyth.xyz:${builtins.toString cfg.port}";
            max_timeout = 30;
            idle_timeout = 120;
          };
          stats.listen_addr = ":23235";
        };
      };
      cloudflared.tunnels = {
        "9f52eb17-9286-4b74-8526-28094e48f79f" = {
          credentialsFile = config.sops.secrets.cloudflared-tunnel-creds.path;
          default = "http_status:404";
          ingress = {
            ${host} = {
              service = "ssh://localhost:${builtins.toString cfg.port}";
            };
          };
        };
      };
    };
  };
}
