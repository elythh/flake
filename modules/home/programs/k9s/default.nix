{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;

  cfg = config.meadow.programs.k9s;
in {
  options.meadow.programs.k9s.enable = mkEnableOption "k9s";

  config = mkIf cfg.enable {
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
