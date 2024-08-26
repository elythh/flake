{ config, lib, ... }:
{
  config = lib.mkIf config.modules.k9s.enable {
    programs.k9s = {
      enable = true;

      settings.skin = "k9s";
    };
    sops.secrets.kubernetes = {
      path = "${config.home.homeDirectory}/.kube/config";
      mode = "0700";
    };
  };
}
