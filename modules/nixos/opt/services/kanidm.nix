{
  lib,
  pkgs,
  config,
  ...
}:
let
  inherit (lib)
    mkIf
    mkEnableOption
    ;

  host = "sso.elyth.xyz";
  cfg = config.opt.services.kanidm;
in
{
  options.opt.services.kanidm = {
    enable = mkEnableOption "kanidm";
    port = 3434;
    domain = host;
  };

  config = mkIf cfg.enable {
    sops.secrets = {

      kanidm-admin-password = { };
      kanidm-idm-admin-password = { };
      kanidm-oauth2-grafana = { };
      kanidm-oauth2-forgejo = { };
    };

    services = {
      kanidm = {
        # we need to change the package so we have patches that allow us to provision secrets
        package = pkgs.kanidm.withSecretProvisioning;

        enableServer = true;
        serverSettings = {
          inherit (cfg) domain;
          origin = "https://${cfg.domain}";
          bindaddress = "${cfg.host}:${toString cfg.port}";
          ldapbindaddress = "${cfg.host}:3636";
          trust_x_forward_for = true;

          online_backup = {
            path = "/srv/storage/kanidm/backups";
            schedule = "0 0 * * *";
          };
        };

        provision = {
          enable = true;

          adminPasswordFile = config.sops.secrets.kanidm-admin-password.path;
          idmAdminPasswordFile = config.sops.secrets.kanidm-idm-admin-password.path;

          persons = {
            gwen = {
              displayName = "gwen";
              legalName = "gwen";
              mailAddresses = [ "gwen@omg.lol" ];
              groups = [
                "grafana.access"
                "grafana.admins"
                "forgejo.access"
                "forgejo.admins"
              ];
            };
          };

          groups = {
            "forgejo.access" = { };
            "forgejo.admins" = { };
          };

          systems.oauth2 = {
            # forgejo = {
            #   displayName = "Forgejo";
            #   originUrl = "https://${cfg'.forgejo.domain}/user/oauth2/Isabel%27s%20SSO/callback";
            #   originLanding = "https://${cfg'.forgejo.domain}/";
            #   basicSecretFile = config.age.secrets.kanidm-oauth2-forgejo.path;
            #   scopeMaps."forgejo.access" = [
            #     "openid"
            #     "email"
            #     "profile"
            #   ];
            #   # WARNING: PKCE is currently not supported by gitea/forgejo,
            #   # see https://github.com/go-gitea/gitea/issues/21376
            #   allowInsecureClientDisablePkce = true;
            #   preferShortUsername = true;
            #   claimMaps.groups = {
            #     joinType = "array";
            #     valuesByGroup."forgejo.admins" = [ "admin" ];
            #   };
            # };
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

    systemd.services.kanidm = {
      after = [ "acme-selfsigned-internal.${host}.target" ];
      serviceConfig = {
        RestartSec = "60";
      };
    };
  };
}
