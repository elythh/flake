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
      ];
      files = [
        "/etc/machine-id"
        # "/tmp/style.css"
      ];
    };
  };
}
