{
  lib,
  config,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.meadow.impermanence;
in
{
  options.meadow.impermanence.enable = mkEnableOption "impermanence";
  config = mkIf cfg.enable {
    users = {
      users.gwen = {
        hashedPasswordFile = "/persist/passwords/user";
        uid = 1000;
      };
    };
    environment.persistence."/persist" = {
      directories = [
        "/etc/nixos"
        "/etc/NetworkManager/system-connections"
        "/etc/secureboot"
        "/var/db/sudo"
        "/var/lib/tailscale"
      ];
      files = [
        "/etc/machine-id"
        "/etc/wg.key"
      ];
    };
  };
}
