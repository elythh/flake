{ config, lib, ... }:
lib.mkIf config.modules.rbw.enable {
  sops.secrets.rbw = {
    path = "${config.home.homeDirectory}/.config/rbw/config.json";
  };
}
