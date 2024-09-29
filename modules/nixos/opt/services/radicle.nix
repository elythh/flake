{ config, lib, ... }:
let
  inherit (lib)
    mkIf
    mkOption
    types
    mkEnableOption
    ;

  host = "git.elyth.xyz";
  cfg = config.opt.services.radicle;
in
{
  options.opt.services.radicle = {
    enable = mkEnableOption "radicle";
    nodeHost = mkOption {
      type = types.str;
      default = "0.0.0.0";
    };
    nodePort = mkOption {
      type = types.int;
      default = 8888;
    };
  };

  config = mkIf cfg.enable {

    sops.secrets.privateSSH = { };
    services.radicle = {
      enable = true;
      privateKeyFile = config.sops.secrets.privateSSH.path;
      publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICsZ/9N72VrtwfZVklSPgaDTLSSRYVlP1l+7cDZwIj6v gwenchlan.lekerneau@radiofrance.com - default key";
      node.openFirewall = true;
      node.listenAddress = cfg.nodeHost;
      node.listenPort = cfg.nodePort;
      settings = {
        "web" = {
          "pinned" = {
            "repositories" = [
              "rad:z2LVturRkPgEvcvwYJHyAiNajQGg1"
            ];
          };
        };
      };
      httpd.enable = true;
      httpd.nginx.serverName = host;
      httpd.nginx.enableACME = true;
      httpd.nginx.forceSSL = true;
    };
    security.acme.defaults.email = "gwen@omg.lol";
    security.acme.acceptTerms = true;
  };
}
